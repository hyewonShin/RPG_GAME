import 'dart:convert';
import 'dart:io';
import 'package:rpg_game/models/character.dart';
import 'package:rpg_game/models/monster.dart';
import 'package:dartenv/dartenv.dart';
import 'dart:core';

class Game {
  //캐릭터
  Character? character;

  // 몬스터 리스트
  List<Monster> monsters = [];

  //물리친 몬스터 개수(몬스터 리스트의 개수보다 클 수 없습니다.)
  int killedMonterCount = 0;

  //캐릭터 정보를 불러오는 메서드
  Future<Character?> loadCharacterStats(String heroName) async {
    try {
      final filePath = env('CHARACTERS_PATH');
      final file = File(filePath);
      final contents = await file.readAsString();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('Invalid character data');

      int heroHp = int.parse(stats[0]);
      int heroAttack = int.parse(stats[1]);
      int heroDefense = int.parse(stats[2]);

      character = Character(heroName, heroHp, heroAttack, heroDefense);

      // print('🐱character > $character');
      return character;
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //몬스터 정보를 불러오는 메서드
  Future<Character?> loadMonsterStats() async {
    try {
      final file = File(env('MONSTERS_PATH'));
      final contents = await file.readAsString();
      final stats = contents.split('\n');

      for (var item in stats) {
        final monster = item.split(',');

        String monsterName = monster[0];
        int monsterHp = int.parse(monster[1]);
        int monsterAttack = int.parse(monster[2]);

        monsters.add(Monster(monsterName, monsterHp, monsterAttack));
      }
      // print('⭐monsters > $monsters');
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //게임을 시작하는 메서드
  void startGame() async {
    Game game = Game();

    stdout.write("👉🏻 캐릭터의 이름을 입력하세요: ");

    String? heroName =
        stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

    RegExp regex = RegExp(r'^[a-zA-Z가-힣]+$');
    if (regex.hasMatch(heroName ?? "")) {
      Character? heroData = await game.loadCharacterStats(heroName!);
      // print('heroData > $heroData');
      print('⭐⭐⭐ 멋진 영웅 $heroName의 게임을 시작합니다 !⭐⭐⭐');
      print(
          '$heroName - 체력:${heroData?.heroHp} 공격력:${heroData?.heroAttack} 방어력:${heroData?.heroDefense}');
    } else {
      print('캐릭터의 이름은 한글,영문 대소문자만 가능합니다 !');
    }
  }

  //전투를 진행하는 메서드
  void battle() {}
}
