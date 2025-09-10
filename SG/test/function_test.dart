import 'package:lpinyin/lpinyin.dart';

main() {
  // sortTest();
  mapTest();
}

void sortTest() {
  // List<String> list = <String>['ccc', 'aaa', 'bbb', '欧洲', 'ddd', '比利'];
  List<String> list = <String>['西班牙', '欧洲', '澳大利亚', '比利'];
  // list.sort((a, b) => a.substring(0,1).compareTo(b.substring(0,1)));
  // list.sort();
  // list.sort((a, b) => a.compareTo(b));
  list.sort((a, b) => PinyinHelper.getShortPinyin(a).compareTo(PinyinHelper.getShortPinyin(b)));
  print('排序测试...$list');
}

void mapTest() {
  var result = toJson().entries.firstWhere((element) => element.value.contains("111"));
  print("result: $result");
  print("result: ${result.toString()}");
  print("result: ${result.key}");
  print("result: ${result.value}");
}

Map<String, String> toJson() => {
      "join_time": "111",
      "count_time": "222",
      "test": "333",
    };
