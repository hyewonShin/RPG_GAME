import 'package:rpg_game/models/game.dart';

void main() async {
  Game game = Game();
  game.loadCharacterStats();
  game.loadMonsterStats();
}
