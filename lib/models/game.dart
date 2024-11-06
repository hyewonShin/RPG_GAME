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

  // bonusHp() 의 결과값인 캐릭터의 체력
  int bonusHeroHp = 0;

  int useheroAttack = 0;

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

      bonusHeroHp = bonusHp(heroHp);

      character = Character(heroName, bonusHeroHp, heroAttack, heroDefense);
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
        int monsterAttackRange = int.parse(monster[2]);
        int monsterAttack =
            Random().nextInt(monsterAttackRange - character!.heroDefense + 1) +
                character!.heroDefense;

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
    // bonusHp(character!.heroHp);
    print('-----------------------------------------------');

    await battle();
  }

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
          specialItem(character!.heroAttack);
          if (win) {
            // 몬스터를 물리침
            monsters.remove(randomMonster); // 물리친 몬스터 리스트에서 제거
            killedMonter += 1;

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
                print('-----------------------------------------------');
                print('계속해서 게임을 진행합니다.');
              } else if (nextGame == 'n' || nextGame == 'N') {
                print('n을 입력하셨습니다. 게임을 종료합니다!');
                return;
              }
            }
          } else {
            randomMonster.attackCharacter(character!);

            if (character!.heroHp <= 0) {
              print('-----------------------------------------------');
              print('😵 캐릭터의 hp가 다하여 게임이 종료되었습니다.');
              fileWrite(character!.heroName, character!.heroHp, false);
              return;
            }
          }
        } else if (action == "2") {
          character!.defend(randomMonster);
          randomMonster.attackCharacter(character!);
          specialItem(character!.heroAttack);
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

// 캐릭터의 이름, 남은 체력, 게임 결과(승리/패배) 저장하는 메서드
  void fileWrite(String heroName, int heroHp, bool win) {
    final filePath = env('SAVE_PATH');
    final file = File(filePath);

    stdout.write('결과를 저장하시겠습니까? (y/n) ');
    String? result = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

    if (result == 'y' || result == 'Y') {
      file.writeAsStringSync(
          'heroName: $heroName / heroHp: $heroHp / win: $win');
    } else if (result == 'n' || result == 'N') {
      print('게임 결과를 저장하지 않고 종료합니다.');
      return;
    }
  }

//캐릭터의 체력 증가 기능
//30%의 확률로 캐릭터에게 보너스 체력을 제공
  int bonusHp(int heroHp) {
    Random random = Random();
    bool result = random.nextDouble() <= 0.3;

    if (result) {
      bonusHeroHp = heroHp + 10;
      print('🚀 보너스 체력을 얻었습니다! 현재 체력: $bonusHeroHp');
      return bonusHeroHp;
    } else {
      print('아쉽게도 보너스 체력을 얻지 못했습니다.');
      return heroHp;
    }
  }

  // 전투 시 캐릭터의 아이템 사용 기능
  //아이템 사용 시 캐릭터는 한 턴 동안 공격력이 두 배로 변경
  void specialItem(heroAttack) {
    stdout.write('특수 아이템을 사용하려면 3번을 입력하세요: ');
    String? result = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

    bool useItem = character!.useItemCheck();

    if (useItem) return print('이미 사용한 아이템입니다');

    if (result == '3') {
      //한 턴 동안 공격력이 두 배로 변경
      useheroAttack = heroAttack * 2;
      character!.heroAttack = useheroAttack;
      Character.useItem = true;
      print('특수 아이템을 사용합니다 ! 현재 공격력: $useheroAttack');
    } else {
      print('잘못된 번호입니다');
      return;
    }
  }
}
