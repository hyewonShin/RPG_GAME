import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:rpg_game/models/character.dart';
import 'package:rpg_game/models/monster.dart';
import 'package:dartenv/dartenv.dart';
import 'package:chalkdart/chalk.dart';

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

  // 게임의 턴을 카운트하는 변수
  static int turnCount = 0;

  Future<void> loadCharacterStats(String heroName) async {
    try {
      // charactor.txt 파일로부터 캐릭터 데이터 불러오기
      final file = File(env('CHARACTERS_PATH'));
      final contents = await file.readAsString();
      final stats = contents.split(',');

      // 캐릭터의 데이터가 3개가 아닌 경우 오류내기
      if (stats.length != 3) throw FormatException('Invalid character data');

      // 캐릭터의 체력
      int heroHp = int.parse(stats[0]);

      // 캐릭터의 공격력
      int heroAttack = int.parse(stats[1]);

      // 캐릭터의 방어력
      int heroDefense = int.parse(stats[2]);

      // 캐릭터의 체력 증가 기능 실행 후 bonusHeroHp반환하여 인스턴스에 넣어주기
      bonusHeroHp = bonusHp(heroHp);

      // 캐릭터 인스턴스 생성
      character = Character(heroName, bonusHeroHp, heroAttack, heroDefense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //몬스터 정보를 불러오는 메서드
  Future<void> loadMonsterStats() async {
    try {
      // monster.txt 파일로부터 몬스터 데이터 불러오기
      final file = File(env('MONSTERS_PATH'));
      final contents = await file.readAsString();
      final stats = contents.split('\n');

      for (var item in stats) {
        final monster = item.split(',');

        // 몬스터의 이름
        String monsterName = monster[0];

        // 몬스터의 체력
        int monsterHp = int.parse(monster[1]);

        // 몬스터의 공격범위
        int monsterAttackRange = int.parse(monster[2]);

        // 랜덤으로 지정할 공격력 범위 최대값 (int)
        //몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.
        int monsterAttack =
            Random().nextInt(monsterAttackRange - character!.heroDefense + 1) +
                character!.heroDefense;

        // Monster 인스턴스 생성하여 List<Monster> 에 차곡차곡 담아주기
        monsters.add(Monster(monsterName, monsterHp, monsterAttack));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  //게임을 시작하는 메서드
  void startGame(heroName) async {
    try {
      print('⭐⭐⭐ 멋진 영웅 ${chalk.blueBright(heroName)}의 게임을 시작합니다! ⭐⭐⭐ \n');
      await loadCharacterStats(heroName); // cvs파일에서 캐릭터 정보 불러옴
      await loadMonsterStats(); // cvs파일에서 몬스터 정보 불러옴
      character!.showStatus(); //캐릭터의 기본정보 출력

      // 게임에 필요한 정보를 모두 불러온 이후, 전투를 진행하는 메서드 실행
      await battle();

      // 캐릭터의 체력이 0 이하가 되면 게임이 종료
      if (character!.heroHp <= 0) {
        print('😵 캐릭터의 hp가 다하여 게임이 종료되었습니다.');
        // 결과를 저장하는 메서드 => y 입력 할 경우 result.txt 파일에 저장
        saveFile(character!.heroName, character!.heroHp, false);
        return;
      }
    } catch (e) {
      print('startGame() 에러 발생 > $e');
    }
  }

  //전투를 진행하는 메서드
  Future battle() async {
    try {
      // 외부 while문 : 캐릭터가 살아있고, 상대할 몬스터가 존재할동안 전투를 지속
      while (character!.heroHp >= 0 && monsters.isNotEmpty) {
        // 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑아서 대결 시작
        Monster? randomMonster = await getRandomMonster();

        if (randomMonster != null) {
          // randomMonster가 null 이 아닌 경우에만 로직 실행
          print('👀 두둥-! 새로운 몬스터가 나타났습니다 !');
          print('${chalk.redBright({
                randomMonster.monsterName
              })} - 체력: ${randomMonster.monsterHp}, 공격력: ${randomMonster.monsterAttack}, 방어력 ${randomMonster.monsterDefense} \n');

          // 내부 while문 : 캐릭터와 몬스터가 둘 다 살아있는 동안 전투를 지속.
          while (character!.heroHp > 0 && randomMonster.monsterHp > 0) {
            print('🧐 ${chalk.blueBright({character!.heroName})} 의 턴');

            stdout.write("행동을 선택하세요(1: 공격, 2: 방어): ");
            String? action =
                stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

            // 특수 아이템 사용 여부 체크한 이후, 사용자 응답에 따라 specialItem() 실행
            character!.useItemCheck(character!.heroAttack);

            if (action == "1") {
              // 캐릭터가 몬스터를 공격하고 이겼는지 여부를 return 값으로 반환
              bool? win = character!.attackMonster(randomMonster);

              if (win != null) {
                // 몬스터를 물리쳤을 경우
                monsters.remove(randomMonster); // 물리친 몬스터 리스트에서 제거
                killedMonter += 1; // 물리친 몬스터의 개수 카운트

                if (killedMonter >= 5) {
                  // 설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 승리 !
                  print(
                      '🏅 ${character!.heroName} 용사님 축하합니다! 모든 몬스터를 물리쳤습니다 🥳');
                  // 결과를 저장하는 메서드 => y 입력 할 경우 result.txt 파일에 저장
                  saveFile(character!.heroName, character!.heroHp, true);
                  return;
                } else {
                  // 몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택
                  stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): ');
                  String? nextGame = stdin.readLineSync(
                      encoding: Encoding.getByName('utf-8')!);

                  if (nextGame == 'y' || nextGame == 'Y') {
                    print('\n계속해서 게임을 진행합니다. \n');
                  } else if (nextGame == 'n' || nextGame == 'N') {
                    print('n을 입력하셨습니다. 게임을 종료합니다!');
                    return;
                  }
                }
              } else {
                // 몬스터를 물리치지 못한 경우 : 몬스터가 캐릭터를 공격 !
                randomMonster.attackCharacter(character!);
              }
            } else if (action == "2") {
              // 캐릭터의 방어 액션
              await character!.defend(randomMonster);

              // 몬스터가 캐릭터를 공격
              await randomMonster.attackCharacter(character!);

              // 특수 아이템 사용 여부 체크한 이후, 사용자 응답에 따라 specialItem() 실행
              character!.useItemCheck(character!.heroAttack);
            } else {
              print('1,2 중 하나를 입력해주세요 ! \n');
            }
          }
        }
      }
    } catch (e) {
      print('battle() 에러 발생 > $e');
    }
  }

  // 몬스터를 랜덤으로 반환하는 메서드
  Future<Monster?> getRandomMonster() async {
    try {
      if (monsters.isEmpty) {
        print('몬스터 리스트가 비어있습니다 !');
      } else {
        int randomIndex = Random().nextInt(monsters.length);
        return monsters[randomIndex];
      }
    } catch (e) {
      print('getRandomMonster() 에러 발생 > $e');
    }
  }

// 캐릭터의 이름, 남은 체력, 게임 결과(승리/패배) 저장하는 메서드
  void saveFile(String heroName, int heroHp, bool win) {
    try {
      final file = File(env('SAVE_PATH'));

      stdout.write('결과를 저장하시겠습니까? (y/n) ');
      String? result =
          stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

      if (result == 'y' || result == 'Y') {
        // 1) 기본 기능
        // file.writeAsStringSync(
        //     'heroName: $heroName / heroHp: $heroHp / win: $win ',
        //     mode: FileMode.append);

        // 2) 추가 기능(명예의 전당) 을 위한 저장 형식 변경(value만 누적)
        file.writeAsStringSync('$heroName/$heroHp/$win|',
            mode: FileMode.append);
      } else if (result == 'n' || result == 'N') {
        print('게임 결과를 저장하지 않고 종료합니다.');
        return;
      }
    } catch (e) {
      print('saveFile() 에러 발생 > $e');
    }
  }

  // [도전] 캐릭터의 체력 증가 기능
  //30%의 확률로 캐릭터에게 보너스 체력을 제공
  int bonusHp(int heroHp) {
    try {
      Random random = Random();
      bool result = random.nextDouble() <= 0.3;

      if (result) {
        bonusHeroHp = heroHp + 10;
        print('🚀 보너스 체력(+10)을 얻었습니다! 현재 체력: $bonusHeroHp');
        return bonusHeroHp;
      } else {
        print('랜덤게임 - 아쉽게도 보너스 체력을 얻지 못했습니다.');
        return heroHp;
      }
    } catch (e) {
      print('bonusHp() 에러 발생 > $e');
      return heroHp;
    }
  }

  // [도전] 전투 시 캐릭터의 아이템 사용 기능
  //아이템 사용 시 캐릭터는 한 턴 동안 공격력이 두 배로 변경
  static void specialItem(heroAttack) {
    try {
      stdout.write('특수 아이템을 사용하려면 3번을 입력하세요: ');
      String? result =
          stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

      if (result == '3') {
        //한 턴 동안 공격력이 두 배로 변경
        Character.useItem = true;
        int useheroAttack = heroAttack * 2;
        heroAttack = useheroAttack;
        print('🚀 특수 아이템을 사용합니다(공격력X2) ! 현재 공격력: $useheroAttack \n');
      } else {
        print('잘못된 번호입니다 \n');
        return;
      }
    } catch (e) {
      print('specialItem() 에러 발생 > $e');
    }
  }

  // [도전] 추가기능 : 명예의 전당
  //게임에서 승리한 캐릭터 중 방어력이 가장 높은 캐릭터 한 명 선정
  Future hallOfFame() async {
    try {
      final file = File(env('SAVE_PATH'));
      final contents = await file.readAsString();
      final stats = contents.split('|');

      String? topHero;
      int maxHp = 0;

      for (String hero in stats) {
        var heroData = hero.split('/');

        if (heroData.length >= 3) {
          var name = heroData[0];
          var hp = int.parse(heroData[1]);
          var win = heroData[2];

          if (win == "true") {
            if (hp > maxHp) {
              maxHp = hp;
              topHero = name;
            }
          }
        }
      }
      print(chalk.yellow('🎉 TOP RANKING  >>>  $topHero 용사님 🎉 \n'));
    } catch (e) {
      print('hallOfFame() 에러 발생 > $e');
    }
  }
}
