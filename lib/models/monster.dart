import 'dart:io';

import 'package:rpg_game/models/character.dart';
import 'package:dartenv/dartenv.dart';

class Monster {
  // 몬스터 이름
  String monsterName = "";

  // 몬스터의 체력
  int monsterHp = 0;

  // 랜덤으로 지정할 공격력 범위 최댓값
  //몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.
  int monsterAttack = 0;

  // 방어력(몬스터의 방어력은 0이라고 가정합니다.)
  int monsterDefense = 0;

  Monster(this.monsterName, this.monsterHp, this.monsterAttack)
      : monsterDefense = 0;

  @override
  String toString() =>
      'monsterName : $monsterName / monsterHp : $monsterHp / monsterAttack : $monsterAttack';

  // 공격 메서드
  //캐릭터에게 공격을 가하여 피해를 입힙니다.
  //캐릭터에게 입히는 데미지는 몬스터의 공격력에서 캐릭터의 방어력을 뺀 값이며, 최소 데미지는 0 이상입니다.
  void attackCharacter(Character character) {}

  // 상태를 출력하는 메서드
  //몬스터의 현재 체력과 공격력을 매 턴마다 출력합니다.
  void showStatus() {
    print('$monsterName - 체력:$monsterHp 공격력:$monsterAttack');
    // return '$heroName - 체력:$heroHp 공격력:$heroAttack 방어력:$heroDefense';
  }
}
