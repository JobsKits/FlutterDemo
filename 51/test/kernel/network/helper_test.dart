import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';

void main() {
  test('getNormalHeaders', () {
    int cmdId = 370433;
    Map<String, dynamic> ret = getNormalHeaders(cmdId);
    // print('ret: $ret');
    expect(ret['Cmdid'], 370433);
    expect(ret['Signature'], 'e92fa5f514dbaedc3e13b282c66db264');
  });

  test('enP', () {
    const rk = 'a2e2ca48';
    const vk = 'fT6phq0wkOPRlAoyToidAnkogUV7ttGo';
    int t = 1720693238669;
    String ret = enP(rk, vk, t);
    expect(ret, '4zcQv+PXJS1rbqo57c/XEMK8UTH9KxBK');
  });

  test('dnP', () {
    const vk = 'fT6phq0wkOPRlAoyToidAnkogUV7ttGo';
    const str = '9B2XI62/MUVrbqo57c/XEMeZOgG3YufU';
    String ret = dnP(vk, str);
    expect(ret, 'ms0ey2vr1720693239409');
  });

  test('enD', () {
    String rk = 'a2e2ca48';
    String str = '7';
    String ret = enD(rk, str);
    expect(ret, '82KP5XTJ68g=');

    rk = 'a2e2ca48';
    str = '1720693238669';
    ret = enD(rk, str);
    expect(ret, 'deDB0HOXobHmRrp8xVjf0w==');
  });

  test('enD2', () {
    String rk = 'cc8ce394';
    String str = 'domain_addr=http://typcblack.lg0808.com&language=0';
    String ret = enD(rk, str);
    expect(ret,
        'x+Ko18kOlf1wWw43PzhTCPJn9ntzDqEfz6QaMUXRZb3mPHJ3JxQUuH++/lsOCUcBdwKnDhBOVcM=');
  });

  test('enD3', () {
    String rk = 'f1b27c3f';
    String str =
        '{"tid":3,"aseq":{"aseq":"7"},"version_type":{"version_type":3},"news":{"page_start":1,"num_per_page":999,"chan_con":8,"state":1,"message_id":10,"sort_flag":1,"vip_level":0,"proxy":0,"apply":8,"language":1},"game_news":{"page_start":1,"num_per_page":9999,"state":1,"message_id":17,"sort_flag":1,"tid":3,"proxy":0,"chan_con":0,"apply":8,"ma_id":10,"vip_level":0,"type":"MWEB","language":0},"banners":{"page_start":1,"num_per_page":999,"chan_con":8,"state":1,"message_id":12,"sort_flag":1,"proxy":0,"apply":8,"language":1},"homeHotGames":{"cust_id":"0"},"proxyConfig":{"proxy":0},"hotGames":{"size":12}}';
    String ret = enD(rk, str);
    expect(ret,
        'f66of2gSPtVPSd7ET73qCL1stvh1zzjxkNEWmQ3aYDzhFPcPzzUusW4KKZM6hAva4RT3D881LrFYB2ixPjxryZPkpgvZDkFX5xPa/EYai8J11w0W1IYb2Jbt9Fle0nnYU4NPct7kv0Lj88xEDMA10pJd501m61FoKR2nic0PNlWTkbeq6oiwT97wTgSDt9IOsH1uJM3RwFKQ+Kxykw/0yR0ByUgYTn9ysjVO0CBkPRUr2vCqc4mUP4mBlMp0+eidM5QsSz3FkeyusAvM0G1VPX4BxcgEyD1aiMQ6KDPqtu5QtpTbH2HfW6dEDHWkOMmgR9k7OQTGi/RtrxeGBfhIHCkdp4nNDzZVk5G3quqIsE80eiPTEOifMLB9biTN0cBS5h20LwmTUnYSUYxoDk8aZzMTSUcIrIFNdIjaDmX3jCyZca4hOXmkQDt9PCy5+whKdro27VjhtvoOCoSCUsVofuj2QKLKr94eSoXl8p00KonPMVCrb7Hh1LmQfxkMVs4BI2g9OrqX6Zv/xnfidvGfmucT2vxGGovCddcNFtSGG9iW7fRZXtJ52FODT3Le5L9C4/PMRAzANdKSXedNZutRaCkdp4nNDzZVk5G3quqIsE89fSz+kPvQSbB9biTN0cBSaT4xa2ial7UzE0lHCKyBTcLdRV54fgTK3D3l8Bq8hNEd+mJxVeb7hMdwRtcVWqEltvywtFaLBUQNNkdYQIRxlQ2bHg35fnnPLZPvql9xdyqaV9WMRzzEiMZwe4k7KasLFlPI2mm1yckwszkNM1Qg22vFnVkNdhLNz2b1k7ydJKI=');
  });

  test('dnD', () {
    const rk = 'ms0ey2vr';
    const str =
        'TZnCpXKQLsDrVs+I1ED925wBjAJERyTog3yRRaAllP10Oj8tjRaDhdonOJujVEef8d5qnEJ46LD9+XSlVGUGTI2rBBm4MGPIfdQNsNyB5LZAPrdDRJmLD17f0uWx4wYSM1VlQCyCshc1giegzDHh1BRC++UOOXDqoEnaIQekPBXR7Rh3a+GiULyCxKVI/wKnuonwR9yi7rlUPEGUZ454Oh3V98KoK76X1T47/OXSk/AFWAh7pnUp68CZ/6qvjXRVcArKgsMfjs/eUhoYAJ12sP5qBhv1qFuiyn+SnQmT5eVnosGa7rvcYTP4EzqRMPNMo/n8ZtbCRzKD3tssnoQyAUSDYUxpltj3ltimBIHgyc7eTNqKBG2//w5gzDt9etvo0KiXBKNRSKB1aDgkDTjDJGz2gRJEljTaO9CKr5bG2dgAwe0H7L8cK7Z65nndN9HG1PWNUlzZBxG8gsSlSP8Cp7qJ8Efcou65z8lioxNNLhz9+6QfvcGP7x6ZFIshnN4L4DrKuBnqwpHejnFEydT1IPRWKsJHqGwcfLF5/EeajAbTGyzaJmYhvyZsSKTU5tVa+ppyQ4HCDGB0lP4OYI3BAVaVx8xiUn1l+ppyQ4HCDGB0lP4OYI3BAVSfimdv3aEUuUZgczEVNdEWUEbP45FXyo+G60r9OpgYH2ejjd5Vkcmy0G1Hn9H/hT0NoF9bhQJu7saasUabhT5Rn+pYbLcD3I3urKfK0lGbbx5hsUT5eWkwLtOzOoIjBW2gkk0TlruKwJE2mWRXyPDpfF48E5bh5R7t2ljA4MQ3u0dIX/r+mv/VEZBAxpx5WUUZzh3QfDygv1faTW15LyN7yq0O2Igj5dh8nQ9VO9cehaYpoYMUkUGM5DZBUfKXRR5bx4T6mhG2uLLwWvxLAwY=';
    String ret = dnD(rk, str);
    Map<String, dynamic> retObj = jsonDecode(ret);
    expect(retObj['version_digest'], 'MWEB 客户端1.0版本');
  });

  test('enC', () {
    const rk = 'a2e2ca48';
    const vk = 'fT6phq0wkOPRlAoyToidAnkogUV7ttGo';
    const m = 'deDB0HOXobHmRrp8xVjf0w==';
    String ret = enC(rk, vk, m);
    expect(ret, '3wAFle8MemOI336SeFvI0g==');
  });

  test('formatSendData', () {
    final data0 = {
      'domain_addr': 'http://typcblack.lg0808.com',
      'language': '0'
    };
    final res0 = formatSendData(data0, 0);
    expect(res0, 'domain_addr=http://typcblack.lg0808.com&language=0');

    final data1 = {
      'tid': 3,
      'aseq': {
        'aseq': 7,
      },
      'version_type': {
        'version_type': 3,
      },
      'hotGames': {
        'size': 12,
      },
    };
    final res1 = formatSendData(data1, 1);
    expect(res1,
        '{"tid":3,"aseq":{"aseq":7},"version_type":{"version_type":3},"hotGames":{"size":12}}');

    final data2 = ['7', '8', '9'];
    final res2 = formatSendData(data2, 2);
    expect(res2, '7/8/9');
  });

  test('getP', () {
    String ret = getP('123456');
    expect(ret, 'b0984e74afb20720b9387400c193f2b8');
  });
}
