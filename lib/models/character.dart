import 'package:rpg_game/models/game.dart';
import 'package:rpg_game/models/monster.dart';

class Character {
  // 캐릭터 이름
  String heroName = "";

  // 캐릭터의 체력
  int heroHp;

  // 캐릭터의 공격력
  int heroAttack;

  // 캐릭터의 방어력
  int heroDefense;

  // 아이템 사용 여부 확인
  static bool useItem = false;

  Character(this.heroName, this.heroHp, this.heroAttack, this.heroDefense);

  @override
  String toString() =>
      'heroName : $heroName / heroHp : $heroHp / heroHp : $heroHp / heroAttack > $heroAttack';

  // 공격 메서드
  //몬스터에게 공격을 가하여 피해를 입힙니다.
  bool attackMonster(Monster monster) {
    monster.monsterHp -= heroAttack;

    int demage = heroAttack - monster.monsterDefense;

    if (demage > 0) {
      print('🗡️  $heroName이(가) ${monster.monsterName}에게 $demage 데미지를 입혔습니다.');
      showStatus();
    } else {
      print('캐릭터의 공격력이 0 이하이기 때문에 공격할 수 없습니다 ! \n');
    }

    if (monster.monsterHp <= 0) {
      print('🥳 ${monster.monsterName}을 물리쳤습니다 !');
      return true;
    }

    return false;
  }

  // 방어 메서드
  //방어 시 특정 행동을 수행합니다.
  //예) 대결 상대인 몬스터가 입힌 데미지만큼 캐릭터의 체력을 상승시킵니다.
  Future defend(Monster monster) async {
    print('💊 $heroName이(가) 방어 태세를 취하여 ${monster.monsterAttack} 만큼 체력을 얻었습니다');
    heroHp += monster.monsterAttack;
    showStatus();
  }

  // 상태를 출력하는 메서드
  //캐릭터의 현재 체력, 공격력, 방어력을 매 턴마다 출력합니다.
  void showStatus() {
    print('$heroName - 체력:$heroHp 공격력:$heroAttack 방어력:$heroDefense \n');
  }

  // 아이템 사용을 처리하는 함수
  void useItemCheck(heroAttack) {
    if (!useItem) {
      Game.specialItem(heroAttack);
    }
  }
}
