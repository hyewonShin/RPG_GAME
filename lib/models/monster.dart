import 'package:rpg_game/models/character.dart';
import 'package:rpg_game/models/game.dart';
import 'package:chalkdart/chalk.dart';

class Monster {
  // 몬스터 이름
  String monsterName = "";

  // 몬스터의 체력
  int monsterHp;

  // 랜덤으로 지정할 공격력 범위 최댓값
  //몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.
  int monsterAttack;

  // 방어력(몬스터의 방어력은 0이라고 가정합니다.)
  int monsterDefense;

  Monster(this.monsterName, this.monsterHp, this.monsterAttack)
      : monsterDefense = 0;

  @override
  String toString() =>
      'monsterName : $monsterName / monsterHp : $monsterHp / monsterAttack : $monsterAttack';

  // 공격 메서드
  //캐릭터에게 공격을 가하여 피해를 입힙니다.
  //캐릭터에게 입히는 데미지는 몬스터의 공격력에서 캐릭터의 방어력을 뺀 값이며, 최소 데미지는 0 이상입니다.
  void attackCharacter(Character character) {
    print('🔨 ${chalk.red({monsterName})} 의 턴');

    int gameTurnCount = ++Game.turnCount;

    int demage = monsterAttack - character.heroDefense;

    if (demage > 0) {
      character.heroHp -= demage;
      print('$monsterName이(가) ${character.heroName}에게 $demage의 데미지를 입혔습니다.');
      print(
          '${character.heroName} - 체력:${character.heroHp} 공격력:${character.heroAttack} 방어력:${character.heroDefense}');
      showStatus();
    } else {
      print('몬스터의 공격력이 0 이하이기 때문에 공격할 수 없습니다 ! \n');
    }

    //몬스터의 방어력 증가 기능 추가
    if (gameTurnCount % 3 == 0) {
      //3턴마다 방어력이 2씩 증가
      monsterDefense += 2;

      // 3턴마다 몬스터의 방어력이 2가 증가하면 카운터 변수를 0으로 초기화
      gameTurnCount == 0;

      print('⚠️  $monsterName의 방어력이 증가했습니다! 현재 방어력: $monsterDefense \n');
    }
  }

  // 상태를 출력하는 메서드
  //몬스터의 현재 체력과 공격력을 매 턴마다 출력합니다.
  void showStatus() {
    print(
        '$monsterName - 체력:$monsterHp 공격력:$monsterAttack 방어력:$monsterDefense \n');
  }
}
