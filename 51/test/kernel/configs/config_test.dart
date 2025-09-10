import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';

void main() {
  test('getBigClass', () {
    final list = GameUtils.getCategoryKeys('DZ');
    print('getBigClass: $list');
  });
}
