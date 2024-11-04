import 'package:rpg_game/models/monster.dart';

class Game {
  //캐릭터
  String character = '';

  //몬스터 리스트
  List<Monster> monsters = [];

  //물리친 몬스터 개수(몬스터 리스트의 개수보다 클 수 없습니다.)
  int killMonterCount = 0;

  //게임을 시작하는 메서드
  void startGame() {}

  //전투를 진행하는 메서드
  void battle() {}
}
