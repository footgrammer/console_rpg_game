import 'character.dart';

class Monster {
  String name;
  int stamina;
  int maxAttackingPower;
  int defensivePower = 0;

  Monster(this.name, this.stamina, this.maxAttackingPower);

  int attackCharacter(Character character) {
    print('  ');
    print('$name의 턴');
    int damage = this.maxAttackingPower - character.defensivePower;
    if (damage < 0) {
      damage = 0;
    }
    print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.');
    return damage;
  }

  void showStatus() {
    print(
      '${this.name} - 체력 : ${this.stamina}, 공격력 : ${this.maxAttackingPower}, 방어력 : ${this.defensivePower}',
    );
  }
}
