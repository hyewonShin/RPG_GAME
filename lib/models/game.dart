import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:rpg_game/models/character.dart';
import 'package:rpg_game/models/monster.dart';
import 'package:dartenv/dartenv.dart';

class Game {
  //캐릭터
  Character? character;

  // 몬스터 리스트
  List<Monster> monsters = [];

  //물리친 몬스터 개수(몬스터 리스트의 개수보다 클 수 없습니다.)
  int killedMonterCount = 0;

  Future<void> loadCharacterStats(String heroName) async {
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
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //몬스터 정보를 불러오는 메서드
  Future<void> loadMonsterStats() async {
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
      // return monsters;
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //게임을 시작하는 메서드
  void startGame(heroName) async {
    print('⭐⭐⭐ 멋진 영웅 $heroName의 게임을 시작합니다 !⭐⭐⭐');
    character!.showStatus();
    print('-----------------------------------------------');

    if (character!.heroHp < 0) {
      print('게임 종료!');
      return;
    } else {
      battle();
    }
  }

  // 게임이 연속적으로 이어지게 만들기
  // 캐릭터의 체력은 대결간에 누적
  // 몬스터를 물리치면 '다음 몬스터와 대결하시겠습니까?' => 새로운 게임 시작
  // 설정한 물리친 개수만큼 몬스터를 물리치면 게임에서 승리
  // 캐릭터의 체력이 0 이하이면 게임 종료

  // 랜덤으로 지정할 공격력 범위 최대값 (int) =>  int monsterAttack;
  // → 몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다.
  //   랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.

  // 게임 종류 후 결과를 파일에 저장

  //전투를 진행하는 메서드
  Future battle() async {
    Monster randomMonster = await getRandomMonster();
    print('👀 두둥-! 새로운 몬스터가 나타났습니다 !');
    print(
        '${randomMonster.monsterName} - 체력: ${randomMonster.monsterHp}, 공격력: ${randomMonster.monsterAttack}');

    print('-----------------------------------------------');
    print('🧐 ${character!.heroName} 의 턴');
    stdout.write("행동을 선택하세요(1: 공격, 2: 방어): ");
    String? action = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

    bool whileloop = true;
    // while (whileloop) {
    if (action == "1") {
      bool win = character!.attackMonster(randomMonster);
      if (win) {
        // 몬스터를 물리침
        monsters.remove(randomMonster); // 물리친 몬스터 리스트에서 제거
        print('monsters.length > ${monsters.length}');
        killedMonterCount = killedMonterCount + 1;
        print('killedMonterCount > $killedMonterCount');
        print('다음 몬스터와 싸우시겠습니까?');
      } else {
        randomMonster.attackCharacter(character!);
      }
    } else if (action == "2") {
      character!.defend(randomMonster);
      randomMonster.attackCharacter(character!);
    } else {
      print('1,2 중 하나를 입력해주세요 !');
    }
    // }
  }

//랜덤으로 몬스터를 불러오는 메서드
  Future<Monster> getRandomMonster() async {
    if (monsters.isEmpty) {
      print('몬스터 리스트가 비어있습니다 !');
    }
    int randomIndex = Random().nextInt(monsters.length);
    return monsters[randomIndex];
  }
}
