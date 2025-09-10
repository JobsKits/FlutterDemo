import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiyu_app/kernel/network/des.dart';

void main() {
  test('des加解密', () {
    String rk = '0779fd01';
    String vk = 'fT6phq0wkOPRlAoyToidAnkogUV7ttGo';
    int t = 1720435824887;
    String message = '$rk$t';
    String enc = des(vk, message, true, 0, '', 1);
    // print('enc: $enc');
    const latin1 = Latin1Codec();
    List<int> latin1Bytes = latin1.encode(enc);
    String enP = base64Encode(latin1Bytes);
    expect(enP, 'cUQ7+cfvEpdbziArRLr5vvLkZiUf5PWi');

    String s = latin1.decode(base64Decode(enP));
    String dnP = des(vk, s, false, 0, '', 1);
    expect(dnP, message);
  });

  test('des加解密', () {
    String rk = '841f53b6';
    String vk = 'fT6phq0wkOPRlAoyToidAnkogUV7ttGo';
    String message = 'domain_addr=http://typcblack.lg0808.com&language=0';
    String enc = des(vk, message, true, 0, '', 1);
    // print('enc: $enc');
    const latin1 = Latin1Codec();
    List<int> latin1Bytes = latin1.encode(enc);
    String enP = base64Encode(latin1Bytes);
    expect(enP, 'cUQ7+cfvEpdbziArRLr5vvLkZiUf5PWi');

    String s = latin1.decode(base64Decode(enP));
    String dnP = des(vk, s, false, 0, '', 1);
    expect(dnP, message);
  });
}
