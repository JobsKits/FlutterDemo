// ignore_for_file: constant_identifier_names

class RegexConstants {
  /// 简单移动电话的正则表达式
  static const String REGEX_MOBILE_SIMPLE = "^[0-9]{6,12}\$";

  /// 移动电话的正则表达式
  ///  <p>china mobile: 134(0-8), 135, 136, 137, 138, 139, 147, 150, 151, 152, 157, 158, 159, 165, 172, 178, 182, 183, 184, 187, 188, 195, 197, 198</p>
  ///  <p>china unicom: 130, 131, 132, 145, 155, 156, 166, 167, 175, 176, 185, 186, 196</p>
  ///  <p>china telecom: 133, 149, 153, 162, 173, 177, 180, 181, 189, 190, 191, 199</p>
  ///  <p>china broadcasting: 192</p>
  ///  <p>global star: 1349</p>
  ///  <p>virtual operator: 170, 171</p>
  static const String REGEX_MOBILE_EXACT =
      "^((13[0-9])|(14[579])|(15[0-35-9])|(16[2567])|(17[0-35-8])|(18[0-9])|(19[0-35-9]))\\d{8}\$";

  ///email正则表达式
  static const String REGEX_EMAIL =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  ///Regex of Chinese character.
  static const String REGEX_ZH = "^[\\u4e00-\\u9fa5]+\$";

  /// 校验密码 1：纯数字 2：数字+字母 3：数字+大小字母 4：数字+大小字母 +特殊字符 5: 内容随意,只限制6-16位长度
  static const String REGEX_PWD_LEVEL_1 = "^(?=.*\\d)[0-9]{6,16}\$";
  static const String REGEX_PWD_LEVEL_2 =
      "^(?=.*\\d)(?=.*[a-zA-Z])[a-zA-Z0-9]{6,16}\$";
  static const String REGEX_PWD_LEVEL_3 =
      "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9]{6,16}\$";
  static const String REGEX_PWD_LEVEL_4 =
      "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[~@//^#\\-%/.+:;=*])[a-zA-Z0-9~@//^#\\-%/.+:;=*]{6,16}\$";
  static const String REGEX_PWD_LEVEL_5 = "^.{6,16}\$";

  ///校验6位纯数字
  static const String REGEX_SIX_NUMBER = r'^\d{6}$';

  ///校验Line账号
  static const String REGEX_LINE = r'^[a-zA-Z0-9]{1,20}$';

  ///校验Zalo账号
  static const String REGEX_ZALO =
      r'^(?:\d{10}|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$';

  ///校验Telegram账号
  static const String REGEX_TELEGRAM = r'^[a-zA-Z][a-zA-Z0-9_]{4,31}$';

  ///校验WatchsApp账号
  static const String REGEX_WHATSAPP = r'^\+?[1-9]\d{1,14}$';

  ///校验Facebook账号
  static const String REGEX_FACEBOOK = r'^[a-zA-Z0-9.]{5,50}$';

  ///校验QQ账号
  static const String REGEX_QQ = r'^[1-9]\d{4,14}$';

  ///会员账号
  static const String REGEX_USERNAME = r'^[a-zA-Z][a-zA-Z0-9_]{5,11}$';
}

class RegexUtils {
  /// 判断输入字符串是否符合手机号
  static bool isMobileSimple(String input) {
    return RegExp(RegexConstants.REGEX_MOBILE_SIMPLE).hasMatch(input);
  }

  /// 返回输入是否匹配电子邮件的正则表达式。
  static bool isEmail(String input) {
    return RegExp(RegexConstants.REGEX_EMAIL).hasMatch(input);
  }

  /// 返回输入是否匹配汉字的正则表达式。
  static bool isZh(String input) {
    return RegExp(RegexConstants.REGEX_ZH).hasMatch(input);
  }

  // 返回输入是否匹配密码的正则表达式
  static bool checkPwd(String input, {required int level}) {
    switch (level) {
      case 1:
        return RegExp(RegexConstants.REGEX_PWD_LEVEL_1).hasMatch(input);
      case 2:
        return RegExp(RegexConstants.REGEX_PWD_LEVEL_2).hasMatch(input);
      case 3:
        return RegExp(RegexConstants.REGEX_PWD_LEVEL_3).hasMatch(input);
      case 4:
        return RegExp(RegexConstants.REGEX_PWD_LEVEL_4).hasMatch(input);
      case 5:
        return RegExp(RegexConstants.REGEX_PWD_LEVEL_5).hasMatch(input);
      default:
        return false;
    }
  }

  // 返回输入是否含有空格的正则表达式
  static bool isHasSpace(String input) {
    return RegExp(r'\s+').hasMatch(input);
  }

  // 6位纯数字
  static bool isSixNumber(String input) {
    return RegExp(RegexConstants.REGEX_SIX_NUMBER).hasMatch(input);
  }

  // 是否是Line账号
  static bool isLine(String input) {
    return RegExp(RegexConstants.REGEX_LINE).hasMatch(input);
  }

  // 是否是Lelegram账号
  static bool isTelegram(String input) {
    return RegExp(RegexConstants.REGEX_TELEGRAM).hasMatch(input);
  }

  // 是否是Zalo账号
  static bool isZalo(String input) {
    return RegExp(RegexConstants.REGEX_ZALO).hasMatch(input);
  }

  // 是否是WhatsApp账号
  static bool isWhatsApp(String input) {
    return RegExp(RegexConstants.REGEX_WHATSAPP).hasMatch(input);
  }

  // 是否是Facebook账号
  static bool isFacebook(String input) {
    return RegExp(RegexConstants.REGEX_FACEBOOK).hasMatch(input);
  }

  // 是否是QQ账号
  static bool isQQ(String input) {
    return RegExp(RegexConstants.REGEX_QQ).hasMatch(input);
  }

  // 是否是会员账号
  static bool isUserName(String input) {
    return RegExp(RegexConstants.REGEX_USERNAME).hasMatch(input);
  }
}
