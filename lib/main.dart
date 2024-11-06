import 'dart:convert';
import 'dart:io';

import 'package:rpg_game/models/game.dart';

Future<void> main() async {
  Game game = Game();

  stdout.write("👉🏻 캐릭터의 이름을 입력하세요: ");

  String? heroName = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

  RegExp regex = RegExp(r'^[a-zA-Z가-힣]+$');
  if (heroName! == "") {
    print('캐릭터의 이름은 빈 문자열이 아니어야 합니다.');
    return;
  }
  if (!regex.hasMatch(heroName)) {
    print('캐릭터의 이름은 한글,영문 대소문자만 가능합니다 !');
    return;
  }
  await game.loadCharacterStats(heroName);
  await game.loadMonsterStats();
  game.startGame(heroName);
}
