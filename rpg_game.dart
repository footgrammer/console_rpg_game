import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';
import 'game.dart';
import 'dart:core';

String? getCharacterName() {
  bool isCorrectInput = false;
  while (!isCorrectInput) {
    RegExp nameRegulation = RegExp(r"^[ㄱ-ㅎ가-힣a-zA-Z]*$");
    stdout.write('캐릭터의 이름을 입력해 주세요! : ');
    String? name = stdin.readLineSync();
    if (name != null && name.isNotEmpty) {
      if (!nameRegulation.hasMatch(name)) {
        print('캐릭터의 이름은 한글, 영어만 사용할 수 있습니다.');
        print('');
      } else {
        isCorrectInput = true;
        return name.trim();
      }
    } else {
      print('캐릭터의 이름은 빈 문자열이 될 수 없습니다.');
      print('');
    }
  }
  return null;
}

Future<Character> loadCharacterStats() async {
  try {
    final file = await File('./gameStats/characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('잘못된 형식의 파일입니다.');

    String name = getCharacterName()!;
    int health = int.parse(stats[0]);
    int attackingPower = int.parse(stats[1]);
    int defensivePower = int.parse(stats[2]);
    Character character = Character(
      name,
      health,
      attackingPower,
      defensivePower,
    );
    return character;
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다 : $e');
    exit(1);
  }
}

Future<List<Monster>> loadMonsterStats(Character character) async {
  try {
    final file = await File('./gameStats/monsters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length % 2 == 1) throw FormatException('잘못된 형식의 파일입니다.');

    List<Monster> monsters = [];
    for (int i = 0; i < stats.length; i += 2) {
      String name = stats[i];
      int health = int.parse(stats[i + 1]);
      int attackingPower = Random().nextInt(100) + character.defensivePower;
      int defensivePower = 0;
      Monster monster = Monster(name, health, attackingPower, defensivePower);
      monsters.add(monster);
      print(
        '몬스터 ${monster.name} : 체력 ${monster.stamina}, 공격력 ${monster.maxAttackingPower}, 방어력 ${monster.defensivePower}',
      );
    }
    return monsters;
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다 : $e');
    exit(1);
  }
}

void main() async {
  try {
    Character character = await loadCharacterStats();
    List<Monster> monsters = await loadMonsterStats(character);
    Game game = Game(character, monsters);
    game.startGame();
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다. : $e');
  }
}
