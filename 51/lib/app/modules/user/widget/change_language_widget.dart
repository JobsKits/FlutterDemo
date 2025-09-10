import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/data/app_language_bean.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/language_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';

//切换语言的组件
class ChangeLanguageWidget extends StatefulWidget {
  const ChangeLanguageWidget({super.key});

  @override
  State<ChangeLanguageWidget> createState() => _ChangeLanguageWidgetState();
}

class _ChangeLanguageWidgetState extends State<ChangeLanguageWidget> {
  late String defaultLanguageType;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshListStatus(); //刷新列表状态
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void refreshListStatus() async {
    defaultLanguageType = await SpUtil.getString("currentLanguageType") ?? "zh";
    for (var item in languageList) {
      if (item.languageType == defaultLanguageType) {
        setState(() {
          item.languageCheckStatus = true;
        });
      }
    }
  }

  List<AppLanguageBean> languageList = [
    // AppLanguageBean(
    //     languageName: "English",
    //     languageType: "en",
    //     languageIcon: Assets.theme1.images.language.iconEn.path),
    AppLanguageBean(
        languageName: "中文简体",
        languageType: "zh",
        languageIcon: Assets.theme1.images.language.iconCn.path),
    // AppLanguageBean(
    //     languageName: "हिंदी",
    //     languageType: "hi",
    //     languageIcon: Assets.theme1.images.language.iconHi.path),
    // AppLanguageBean(
    //     languageName: "عربي",
    //     languageType: "ar",
    //     languageIcon: Assets.theme1.images.language.iconAr.path),
    // AppLanguageBean(
    //     languageName: "español",
    //     languageType: "es",
    //     languageIcon: Assets.theme1.images.language.iconEs.path),
    // AppLanguageBean(
    //     languageName: "Indonesian",
    //     languageType: "id",
    //     languageIcon: Assets.theme1.images.language.iconId.path),
    // AppLanguageBean(
    //     languageName: "Português",
    //     languageType: "pt",
    //     languageIcon: Assets.theme1.images.language.iconPt.path),
    // AppLanguageBean(
    //     languageName: "แบบไทย",
    //     languageType: "th",
    //     languageIcon: Assets.theme1.images.language.iconTh.path),
    // AppLanguageBean(
    //     languageName: "Türkiye",
    //     languageType: "tr",
    //     languageIcon: Assets.theme1.images.language.iconTr.path),
    // AppLanguageBean(
    //     languageName: "Tiếng Việt",
    //     languageType: "vi",
    //     languageIcon: Assets.theme1.images.language.iconVi.path),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.7.sh,
      width: double.infinity,
      decoration: BoxDecoration(
          color: context.customTheme?.dialogBgColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 48.h),
                Text(
                  "语言",
                  style: TextStyle(
                      fontSize: 51.sp, color: context.customTheme?.titleColor),
                ),
                SizedBox(height: 43.h),
                Divider(
                  height: 1.h,
                  color: context.customTheme?.lineColor,
                ),
                Expanded(child: _buildList())
              ],
            ),
          ),
          Positioned(
              top: 46.h,
              right: 54.w,
              child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                },
                child:
                    Icon(Icons.close, color: context.customTheme?.dialogXColor),
              )),
          Visibility(
              visible: isLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ))
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: languageList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildItem(index);
        });
  }

  Timer? _timer;
  void changeLanguage(index) {
    for (var item in languageList) {
      item.languageCheckStatus = false;
    }
    setState(() {
      languageList[index].languageCheckStatus = true;
    });
    LanguageUtil.changeLanguage(languageList[index].languageType!);
    // Get.updateLocale(Locale(languageList[index].languageType!));
    isLoading = true;
    _timer = Timer(const Duration(seconds: 2), () {
      isLoading = false;
      Get.back();
      Get.snackbar("切换成功!", "");
    });
  }

  Widget _buildItem(int index) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        changeLanguage(index);
      },
      child: Container(
        height: 192.h,
        padding: EdgeInsets.symmetric(horizontal: 42.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.w,
              backgroundImage: AssetImage(languageList[index].languageIcon!),
            ),
            SizedBox(
              width: 46.w,
            ),
            Expanded(
                child: Text("${languageList[index].languageName}",
                    style: TextStyle(color: context.customTheme?.titleColor))),
            SizedBox(
              width: 52.w, // 设置宽度
              height: 52.h, // 设置高度
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // 圆形
                ),
                value: languageList[index].languageCheckStatus,
                onChanged: (value) {
                  changeLanguage(index);
                },
                activeColor: context.theme.primaryColor, // 选中颜色
                checkColor: Colors.white, // 选中时的勾选颜色
                side: const BorderSide(color: Colors.grey), // 未选中时的边框颜色
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
