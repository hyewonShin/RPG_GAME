import 'dart:convert';
import 'dart:io';
import 'package:rpg_game/models/game.dart';

Future<void> main() async {
  try {
    Game game = Game();

    // await사용하여 명예의 전당 기능 가장 먼저 실행되도록 함.
    await game.hallOfFame();

    // 사용자로부터 캐릭터 이름 입력받기 기능
    stdout.write("캐릭터의 이름을 입력하세요: ");
    String? heroName =
        stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

    RegExp regex = RegExp(r'^[a-zA-Z가-힣]+$'); // 한글, 영문 대소문자만 허용
    if (heroName! == "") {
      print('캐릭터의 이름은 빈 문자열이 아니어야 합니다.');
      return;
    }
    if (!regex.hasMatch(heroName)) {
      print('캐릭터의 이름은 한글,영문 대소문자만 가능합니다 !');
      return;
    }

    // 캐릭터 이름 입력받은 이후 게임 시작`
    game.startGame(heroName);
  } catch (e) {
    print('main() 에러 발생 > $e');
  }
}
