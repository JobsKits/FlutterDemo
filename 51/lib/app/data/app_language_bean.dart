class AppLanguageBean {
  AppLanguageBean({
    this.languageName = "中文简体",
    this.languageType = "zh",
    this.languageIcon = "",
    this.languageCheckStatus = false,
  });

  AppLanguageBean.fromJson(dynamic json) {
    languageName = json['languageName'];
    languageType = json['languageType'];
    languageCheckStatus = json['languageCheckStatus'];
    languageIcon = json['languageIcon'];
  }

  String? languageName; //语言名称
  String? languageType; //语言类型
  String? languageIcon; //语言图标
  bool? languageCheckStatus; //语言选中状态

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['languageName'] = languageName;
    map['languageType'] = languageType;
    map['languageCheckStatus'] = languageCheckStatus;
    map['languageIcon'] = languageIcon;
    return map;
  }
}
