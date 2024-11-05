import 'dart:io';
import 'package:rpg_game/models/character.dart';
import 'package:rpg_game/models/monster.dart';
import 'package:dartenv/dartenv.dart';

class Game {
  //캐릭터
  String character = '';

  //몬스터 리스트
  List<Monster> monsters = [];

  //물리친 몬스터 개수(몬스터 리스트의 개수보다 클 수 없습니다.)
  int killMonterCount = 0;

  //캐릭터 정보를 불러오는 메서드
  Future<void> loadCharacterStats() async {
    try {
      final filePath = env('CHARACTERS_PATH');
      final file = File(filePath);
      final contents = await file.readAsString();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('Invalid character data');

      int heroHp = int.parse(stats[0]);
      int heroAttack = int.parse(stats[1]);
      int heroDefense = int.parse(stats[2]);

      print(heroHp);
      print(heroAttack);
      print(heroDefense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //몬스터 정보를 불러오는 메서드
  Future<void> loadMonsterStats() async {
    try {
      final file = File(env('MONSTERS_PATH'));
      final contents = await file.readAsString();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('Invalid monster data');

      int monsterHp = int.parse(stats[0]);
      int monsterAttack = int.parse(stats[1]);
      int monsterDefense = int.parse(stats[2]);

      print(monsterHp);
      print(monsterAttack);
      print(monsterDefense);
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //게임을 시작하는 메서드
  void startGame() async {}

  //전투를 진행하는 메서드
  void battle() {}
}
