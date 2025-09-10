import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/webview/widget/common_dialog.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/custom.webview.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/CommonRipple.dart';

class LotteryWebPage extends StatefulWidget {
  final String? webUrl;
  const LotteryWebPage({super.key, this.webUrl});

  @override
  State<LotteryWebPage> createState() => _lotteryWebPageState();
}

class _lotteryWebPageState extends State<LotteryWebPage> {
  final loginInfo = LoginManager.instance.loginInfo;

  late String title;
  late int play_cat;
  late String play_name;
  late int sub_play_id;
  late int play_id;

  @override
  void initState() {
    super.initState();
    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;
    title = arguments['title'] ?? '';
    play_cat = arguments['play_cat'] ?? 0;
    play_name = arguments['play_name'] ?? '';
    sub_play_id = arguments['sub_play_id'] ?? 0;
    play_id = arguments['play_id'] ?? 0;
  }

  // URL 拼接逻辑封装到一个函数中
  String? buildWebUri() {
    NetworkService ns = NetworkService();
    String url =
        '${ns.baseURL}/#/jumph5?play_cat=$play_cat&play_name=$play_name'
        '&sub_play_id=$sub_play_id&play_id=$play_id&cust_id=${loginInfo?.custId ?? ''}'
        '&token=${loginInfo?.accessToken ?? ''}';
    return widget.webUrl == '' || widget.webUrl == null ? url : widget.webUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF5F5F5),
      body: SafeArea(
          child: Stack(
        children: [
          CustomWebview(
            webUri: buildWebUri(),
          ),
          Visibility(
              visible: true,
              child: Positioned(
                  top: 68.h,
                  left: 40.w,
                  child: CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      Get.dialog(CommonDialog(
                        title: "退出${title}",
                        clickOk: () {
                          AppManager.instance.tapVibrate();
                          Get.back(); //先关闭弹窗
                          Get.back(); //再退出页面
                        },
                      ));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          Assets.theme1.images.home.iconGameBack.path,
                          width: 164.w,
                          height: 164.h,
                        )
                      ],
                    ),
                  )))
        ],
      )),
    );
  }
}
