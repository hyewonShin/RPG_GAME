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
  bool? attackMonster(Monster monster) {
    try {
      // 캐릭터가 몬스터를 공격할 수 있는 데미지
      // 데미지 = 캐릭터의 공격력 - 몬스터의 방어력
      int demage = heroAttack - monster.monsterDefense;

      if (demage > 0) {
        monster.monsterHp -= demage;
        print(
            '🗡️  $heroName이(가) ${monster.monsterName}에게 $demage 데미지를 입혔습니다.');
        showStatus();
      } else {
        print('캐릭터의 공격력이 0 이하이기 때문에 공격할 수 없습니다 ! \n');
        // 이 경우에 어떻게 처리할지 생각해보기
      }

      // 몬스터의 체력이 0보다 작아지면 캐릭터의 승리 => true 반환
      if (monster.monsterHp <= 0) {
        print('🥳 ${monster.monsterName}을 물리쳤습니다 !');
        return true;
      }
      // 전투중에는 false반환
      return false;
    } catch (e) {
      print('attackMonster() 에러 발생 > $e');
    }
  }

  // 방어 메서드
  Future defend(Monster monster) async {
    try {
      print(
          '💊 $heroName이(가) 방어 태세를 취하여 ${monster.monsterAttack} 만큼 체력을 얻었습니다');
      // 대결 상대인 몬스터가 입힌 데미지만큼 캐릭터의 체력을 상승시킵니다.
      heroHp += monster.monsterAttack;
      showStatus(); // 캐릭터의 상태 출력
    } catch (e) {
      print('defend() 에러 발생 > $e');
    }
  }

  // 상태를 출력하는 메서드
  //캐릭터의 현재 체력, 공격력, 방어력을 매 턴마다 출력합니다.
  void showStatus() {
    print('$heroName - 체력:$heroHp 공격력:$heroAttack 방어력:$heroDefense \n');
  }

  // 아이템 사용을 처리하는 함수
  // useItem이 false인 경우 Game 클래스의 specialItem() 실행
  void useItemCheck(heroAttack) {
    try {
      if (!useItem) {
        Game.specialItem(heroAttack);
      }
    } catch (e) {
      print('useItemCheck() 에러 발생 > $e');
    }
  }
}
