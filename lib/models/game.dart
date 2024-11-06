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
  int killedMonterCount = 5;
  int killedMonter = 0;

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
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //게임을 시작하는 메서드
  void startGame(heroName) async {
    print('⭐⭐⭐ 멋진 영웅 $heroName의 게임을 시작합니다 !⭐⭐⭐');
    character!.showStatus();
    print('-----------------------------------------------');

    await battle();
  }

  // 랜덤으로 지정할 공격력 범위 최대값 (int) =>  int monsterAttack;
  // → 몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다.
  //   랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.

  //전투를 진행하는 메서드
  Future battle() async {
    while (character!.heroHp >= 0 && monsters.isNotEmpty) {
      Monster randomMonster = await getRandomMonster();
      print('👀 두둥-! 새로운 몬스터가 나타났습니다 !');
      print(
          '${randomMonster.monsterName} - 체력: ${randomMonster.monsterHp}, 공격력: ${randomMonster.monsterAttack}');

      //  캐릭터와 몬스터가 둘 다 살아있는 동안 전투를 지속.
      while (character!.heroHp > 0 && randomMonster.monsterHp > 0) {
        print('-----------------------------------------------');
        print('🧐 ${character!.heroName} 의 턴');
        stdout.write("행동을 선택하세요(1: 공격, 2: 방어): ");
        String? action =
            stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

        if (action == "1") {
          bool win = character!.attackMonster(randomMonster);
          if (win) {
            // 몬스터를 물리침
            monsters.remove(randomMonster); // 물리친 몬스터 리스트에서 제거
            killedMonter += 1;
          } else {
            randomMonster.attackCharacter(character!);

            if (character!.heroHp <= 0) {
              print('-----------------------------------------------');
              print('😵 캐릭터의 hp가 다하여 게임이 종료되었습니다.');
              fileWrite(character!.heroName, character!.heroHp, false);
              return;
            }
          }

          if (killedMonter >= killedMonterCount) {
            // 설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 승리
            print('🏅 ${character!.heroName} 용사님 축하합니다! 모든 몬스터를 물리쳤습니다 🥳');
            fileWrite(character!.heroName, character!.heroHp, true);
            return;
          } else {
            stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): ');
            String? nextGame =
                stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

            if (nextGame == 'y' || nextGame == 'Y') {
              stdout.write('계속해서 게임을 진행합니다.');
              print('-----------------------------------------------');
            } else if (nextGame == 'n' || nextGame == 'N') {
              print('n을 입력하셨습니다. 게임을 종료합니다!');
              return;
            }
          }
        } else if (action == "2") {
          character!.defend(randomMonster);
          randomMonster.attackCharacter(character!);
        } else {
          print('1,2 중 하나를 입력해주세요 !');
        }
      }
    }
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

// 캐릭터의 이름, 남은 체력, 게임 결과(승리/패배) 저장하는 메서드
void fileWrite(String heroName, int heroHp, bool win) {
  final filePath = env('SAVE_PATH');
  final file = File(filePath);

  stdout.write('결과를 저장하시겠습니까? (y/n) ');
  String? result = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

  if (result == 'y' || result == 'Y') {
    file.writeAsStringSync('heroName: $heroName / heroHp: $heroHp / win: $win');
  } else if (result == 'n' || result == 'N') {
    print('게임 결과를 저장하지 않고 종료합니다.');
    return;
  }
}
