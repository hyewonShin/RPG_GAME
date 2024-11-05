import 'package:rpg_game/models/monster.dart';

class Character {
  // 캐릭터 이름
  String heroName = "";

  // 캐릭터의 체력
  int heroHp = 0;

  // 캐릭터의 공격력
  int heroAttack = 0;

  // 캐릭터의 방어력
  int heroDefense = 0;

  Character(this.heroName, this.heroHp, this.heroAttack, this.heroDefense);

  @override
  String toString() =>
      'heroName : $heroName / heroHp : $heroHp / heroHp : $heroHp / heroAttack > $heroAttack';

  // 공격 메서드
  //몬스터에게 공격을 가하여 피해를 입힙니다.
  void attackMonster(Monster monster) {}

  // 방어 메서드
  //방어 시 특정 행동을 수행합니다.
  //예) 대결 상대인 몬스터가 입힌 데미지만큼 캐릭터의 체력을 상승시킵니다.
  void defend() {}

  // 상태를 출력하는 메서드
  //캐릭터의 현재 체력, 공격력, 방어력을 매 턴마다 출력합니다.
  void showStatus() {}
}
