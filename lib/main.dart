import 'dart:convert';
import 'dart:io';
import 'package:rpg_game/models/character.dart';
import 'package:rpg_game/models/game.dart';
import 'package:rpg_game/models/monster.dart';

void main() async {
  Game game = Game();

  stdout.write("👉🏻 캐릭터의 이름을 입력하세요: ");

  String? heroName = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

  RegExp regex = RegExp(r'^[a-zA-Z가-힣]+$');
  if (!regex.hasMatch(heroName ?? "")) {
    print('캐릭터의 이름은 한글,영문 대소문자만 가능합니다 !');
    return;
  }
  Character? heroData = await game.loadCharacterStats(heroName!);
  await game.loadMonsterStats();
  // print('heroData > $heroData');

  print('⭐⭐⭐ 멋진 영웅 $heroName의 게임을 시작합니다 !⭐⭐⭐');
  print(
      '$heroName - 체력:${heroData?.heroHp} 공격력:${heroData?.heroAttack} 방어력:${heroData?.heroDefense}');
  Monster randomMonster = game.getRandomMonster();

  print('👀 두둥-! 새로운 몬스터가 나타났습니다 !');
  print(
      '${randomMonster.monsterName} - 체력: ${randomMonster.monsterHp}, 공격력: ${randomMonster.monsterAttack}');

  // game.startGame();
}
