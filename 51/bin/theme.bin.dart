// ignore_for_file: no_wildcard_variable_uses, avoid_print

/*
 * @Author: 
 * @Date: 
 * @LastEditors: 
 * @LastEditTime: 
 * @FilePath: 
 * @Description: json 生成主题配置
 */
import 'dart:io' as io;
import 'dart:convert' as convert;


String packageName = """import 'dart:ui';
import 'string.ext.dart';
""";
String writePath = './lib/theme/base.theme.dart';
void main() async {
  io.File file = io.File('./assets/json/theme.json');
  String _this = await file.readAsString();
  final themeJson = convert.jsonDecode(_this) as Map<String, dynamic>;
  String list = '''
$packageName
class BaseTheme {
''';

  // ignore: avoid_function_literals_in_foreach_calls
  themeJson.entries.forEach((e) {
    // print("${e.key}: ${e.value}");
    final k = e.key;
    final v = e.value as Map<String, dynamic>;
    
    // ignore: avoid_function_literals_in_foreach_calls
    v.entries.forEach((e) {
      if (e.key == "///") {
        list += "/// ${v['///']}\n";
      }else if (e.key == "name"){

      }else {
        list += "static Color get $k${capitalize(e.key)} => '${e.value}'.color();\n";
      }
    });
  });
  list += '}';
  writeFile(writePath, list, type: '📌theme ');
  createCustomTheme(themeJson);
}

createCustomTheme(Map<String, dynamic> themeJson) {
  String customWriteText = ''' 
      import 'package:flutter/material.dart';
      import 'base.theme.dart';
      class CustomTheme extends ThemeExtension<CustomTheme> {
  ''';
  themeJson.forEach((key, value) { 
    customWriteText += '''
      /// ${value['///']}
      Color? ${value['name']};
    ''';
  });
  
  customWriteText += " CustomTheme({";
  themeJson.forEach((key, value) { 
    customWriteText += '''
      /// ${value['///']}
      this.${value['name']},
    ''';
  });
  customWriteText += "});";
  
  customWriteText += ''' 
    @override
    ThemeExtension<CustomTheme> copyWith({
  ''';
  themeJson.forEach((key, value) { 
    customWriteText += "Color? ${value['name']},";
  });
  customWriteText += '''
    }) {
      return CustomTheme(
  ''';
  themeJson.forEach((key, value) { 
    customWriteText += ''' 
      ${value['name']}: ${value["name"]} ?? this.${value["name"]},
    ''';
  });
  customWriteText += ''');}''';


  customWriteText += ''' 
    @override
    ThemeExtension<CustomTheme> lerp(ThemeExtension<CustomTheme>? other, double t) {
    return CustomTheme();
    }
  ''';
  /// 拿到第对象对一个，组合颜色CustomTheme
  final first =themeJson.entries.toList();
  // print("element___${first.first.value} ${first.first.key}");
  final values = (first.first.value ) as Map<String, dynamic>;
  for (var element in values.entries) {
    if ( ["///", "name"].contains(element.key)) {
      continue;
    }else {
      customWriteText += ''' 
    static CustomTheme get ${element.key} => CustomTheme(
    ''';
    themeJson.forEach((key, value) { 
      customWriteText+= '''
        ${value['name']}: BaseTheme.$key${capitalize(element.key)},
      ''';
    });
    customWriteText += ''' );''';
  
    }
  }
  

  // customWriteText += ''' 
  //   static CustomTheme get light => CustomTheme(
  // ''';
  // themeJson.forEach((key, value) { 
  //   customWriteText+= '''
  //     ${value['name']}: BaseTheme.${key}Light,
  //   ''';
  // });
  // customWriteText += ''' );''';
  
  

  // customWriteText += ''' 
  //   static  CustomTheme get dark => CustomTheme(
  // ''';
  // themeJson.forEach((key, value) { 
  //   customWriteText+= '''
  //     ${value['name']}: BaseTheme.${key}Dark,
  //   ''';
  // });
  // customWriteText += '''  ); ''';

  customWriteText += "}";
  writeFile('./lib/theme/theme.custom.dart', customWriteText, type: "自定义颜色");
}

writeFile(String path, String v, {String type = ''}) async {
  final file = io.File(path);
  // 文件存在就删除
  if (await file.exists()) {
    final _ = file.create();
  }
  try {
    await file.writeAsString(v);
    print('✅ $type 写入成功');
  } catch (e) {
    print('🙅 写入失败$e');
  }
}


String capitalize(String s) {
  if (s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}