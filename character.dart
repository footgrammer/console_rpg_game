import 'monster.dart';
import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int stamina;
  int attackingPower;
  int defensivePower;

  Character(this.name, this.stamina, this.attackingPower, this.defensivePower);

  // 몬스터에게 공격을 가하여 피해를 입힙니다.
  // 몬스터에게 입힌 데미지를 반환합니다.
  // 몬스터라는 매개 변수로는 인스턴스 본체의 데이터에 영향을 미칠 수 없기 때문에 데미지 값을 반환해줌
  int attackMonster(Monster monster) {
    int damage = this.attackingPower - monster.defensivePower;
    print('${monster.name}에게 $damage의 데미지를 입혔습니다.');
    if (damage < 0) {
      damage = 0;
    }
    return damage;
  }

  //방어 시 0~100 중 랜덤값으로 체력이 충전됩니다.
  int defend() {
    int healedStamina = Random().nextInt(100);
    print('$name이(가) 방어 태세를 취하여 $healedStamina 체력을 얻었습니다.');
    return healedStamina;
  }

  // 캐릭터의 현 체력, 공격력, 방어력을 출력합니다.
  void showStatus() {
    print(
      '$name - 체력 : $stamina, 공격력 : $attackingPower, 방어력 : $defensivePower',
    );
  }
}
