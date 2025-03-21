import 'character.dart';
import 'monster.dart';
import 'dart:math';
import 'dart:io';
import 'dart:core';

class Game {
  late Character character;
  late List<Monster> monsterLists;
  late int deadMonsters;
  late int originalStamina;

  Game(Character character, List<Monster> monsterLists) {
    this.character = character;
    this.monsterLists = monsterLists;
    this.deadMonsters = 0;
    this.originalStamina = character.stamina;
  }

  // 30% 확률로 true 리턴
  bool hasBonusStamina() {
    int percent = Random().nextInt(100);
    if (percent < 30) {
      return true;
    } else {
      return false;
    }
  }

  void startGame() {
    print('게임을 시작합니다.');
    if (hasBonusStamina()) {
      // 보너스 체력이 당첨되면
      print('[당첨] 보너스 체력 +10이 제공되었습니다.');
      character.stamina += 10;
    }

    print(
      '${character.name} - 체력 : ${character.stamina}, 공격력 : ${character.attackingPower}, 방어력 : ${character.defensivePower}',
    );
    battle();
  }

  void battle() {
    bool continueGame = true; // 게임 진행 여부
    while (continueGame) {
      // 몬스터 죽음 여부
      bool isMonsterDead = false;

      // 캐릭터 죽음 여부
      bool isCharacterDead = false;

      // 잔여 몬스터 체크
      if (monsterLists.length == 0) {
        print('[알림] 남아 있는 몬스터가 없습니다!');
        print('축하드립니다! 게임에서 승리하셨습니다!');
        this.saveResult(character, '승리');
        print('게임을 종료합니다.');

        continueGame = false;
      } else {
        Monster monster = getRandomMonster();
        int playCount = 1; // 처음 시작이 첫 번째 판이기 때문에 1로 설정

        while (!isMonsterDead) {
          print(' ');
          print('${character.name}의 턴');
          stdout.write('행동을 선택하세요. (1: 공격, 2: 방어, 3: 아이템 사용) : ');
          String? action = stdin.readLineSync();

          if (action == '1') {
            // 3턴마다 몬스터의 방어력이 2씩 증가
            if (playCount % 3 == 0 && playCount != 0) {
              monster.defensivePower += 2;
              print(
                '${monster.name}의 방어력이 증가했습니다. 현재 방어력 : ${monster.defensivePower}',
              );
            }
            // 공격을 선택하면.
            int damage = character.attackMonster(monster);

            monster.stamina -= damage;
            print('${monster.name}의 체력 : ${monster.stamina}');
            if (monster.stamina <= 0) {
              print('${monster.name}를 물리쳤습니다.');
              character.showStatus();
              deadMonsters++;
              monsterLists.remove(monster);
              isMonsterDead = true;
            } else {
              int damage = monster.attackCharacter(character);
              character.stamina -= damage;
              character.showStatus();
              monster.showStatus();
              playCount++;
              if (character.stamina <= 0) {
                // 캐릭터가 죽으면
                isCharacterDead = true;
                print('${character.name}이(가) 죽었습니다.');
                this.saveResult(character, '패배');
                print('게임이 종료됩니다.');
                break;
              }
            }
          } else if (action == '2') {
            // 3턴마다 몬스터의 방어력이 2씩 증가
            if (playCount % 3 == 0 && playCount != 0) {
              monster.defensivePower += 2;
              print(
                '${monster.name}의 방어력이 증가했습니다. 현재 방어력 : ${monster.defensivePower}',
              );
            }
            // 방어를 입력하면 체력충전
            character.stamina += character.defend();
            if (character.stamina > originalStamina) {
              character.stamina = originalStamina;
              print('초기 체력값인 $originalStamina보다 더 많이 체력을 얻을 수 없습니다.');
            }
            character.showStatus();

            int damage = monster.attackCharacter(character);
            character.stamina -= damage;
            character.showStatus();
            monster.showStatus();
            playCount++;
            if (character.stamina <= 0) {
              // 캐릭터가 죽으면
              isCharacterDead = true;
              print('${character.name}이(가) 죽었습니다.');
              this.saveResult(character, '패배');
              print('게임이 종료됩니다.');
              break;
            }
          } else if (action == '3') {
            // 3턴마다 몬스터의 방어력이 2씩 증가
            if (playCount % 3 == 0 && playCount != 0) {
              monster.defensivePower += 2;
              print(
                '${monster.name}의 방어력이 증가했습니다. 현재 방어력 : ${monster.defensivePower}',
              );
            }
            //아이템을 사용하면
            int damage = character.attackWithItem(monster);
            if (damage == -1) {
              // 아이템을 이미 사용했다면
            } else {
              monster.stamina -= damage;
              print('${monster.name}의 체력 : ${monster.stamina}');
              if (monster.stamina <= 0) {
                print('${monster.name}를 물리쳤습니다.');
                character.showStatus();
                deadMonsters++;
                monsterLists.remove(monster);
                isMonsterDead = true;
              } else {
                int damage = monster.attackCharacter(character);
                character.stamina -= damage;
                character.showStatus();
                monster.showStatus();
                playCount++;
                if (character.stamina <= 0) {
                  // 캐릭터가 죽으면
                  isCharacterDead = true;
                  print('${character.name}이(가) 죽었습니다.');
                  this.saveResult(character, '패배');
                  print('게임이 종료됩니다.');
                  break;
                }
              }
            }
          } else {
            // 잘못된 입력
            print('''잘못된 입력입니다.''');
          }
        }

        if (isCharacterDead) {
          // 캐릭터가 죽었으면
          continueGame = false;
        } else {
          // 캐릭터가 살아 있으면
          bool correctAnswer = false;
          while (!correctAnswer) {
            stdout.write('다음 몬스터와 싸우시겠습니까? (네/아니오) : ');
            String? answer = stdin.readLineSync();
            if (answer == null) {
              // null 값 헨들링
              print('잘못된 입력입니다. 다시 입력해 주세요.');
              continue;
            } else {
              answer = answer.trim();
              switch (answer) {
                case '네':
                  correctAnswer = true;
                case '아니오':
                  correctAnswer = true;
                  continueGame = false;
                  this.saveResult(character, '게임중지');
                  print('게임이 종료되었습니다.');
                default:
                  print('잘못된 입력입니다. 다시 입력해 주세요.');
                  correctAnswer = false;
              }
            }
          }
        }
      }
    }
  }

  Monster getRandomMonster() {
    print('  ');
    print('새로운 몬스터가 나타났습니다.');
    Monster monster = monsterLists[Random().nextInt(monsterLists.length)];
    print(
      '${monster.name} - 체력 : ${monster.stamina}, 공격력 : ${monster.maxAttackingPower}, 방어력 : ${monster.defensivePower}',
    );
    return monster;
  }

  void saveResult(Character character, String result) {
    stdout.write('결과를 저장하겠습니까? (네/아니오) : ');
    String? answer = stdin.readLineSync();
    if (answer == null) {
      print(answer);
      print('잘못된 입력입니다.');
      print('');
      saveResult(character, result);
    } else {
      answer = answer.trim();
    }
    switch (answer) {
      case '네':
        String contents = '''
    이름 : ${character.name}
    체력 : ${character.stamina}
    결과 : $result
    ''';
        var now = DateTime.now();
        var file = File(
          './results/${now.year.toString()}-${now.month.toString()}-${now.day.toString()}-${character.name}.txt',
        );
        file.writeAsStringSync(contents);
        break;
      case '아니오':
        break;
      default:
        print('잘못된 입력입니다.');
        print('');
        saveResult(character, result);
        break;
    }
  }
}
