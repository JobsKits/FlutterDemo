import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/common_color.dart';

//帮助中心详情页面
class HelpDetailView extends StatefulWidget {
  const HelpDetailView({super.key});

  @override
  State<HelpDetailView> createState() => _HelpDetailViewState();
}

class _HelpDetailViewState extends State<HelpDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "详情",
          style: TextStyle(fontSize: 57.sp),
        ),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Divider(
              height: 1.h,
              thickness: 1.h,
              color: const Color(colorE9E9E9),
            )),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(left: 60.w, right: 60.w, top: 70.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "怎么使用数字钱包提现？",
            style: TextStyle(
                color: const Color(color2D2D2D),
                fontSize: 63.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 32.h,
          ),
          Text(
            "2023-08-18 18:36",
            style: TextStyle(fontSize: 36.sp, color: const Color(colorA6A6A6)),
          ),
          SizedBox(
            height: 45.h,
          ),
          Text(
              style:
                  TextStyle(fontSize: 45.sp, color: const Color(color4A4A4A)),
              "全网最高信誉，从演示站开始！作为国际专业的网 上博彩游戏运营商，我们承诺，为每一位客户提供 最安全、最公平的博彩娱乐，以及全方位的服务。 我们采用坚实、稳定与安全的博彩系统。所有游戏 共同的优点 — 不须耗时下载；界面简单明了；操 作功能齐全；画面精致优雅；游戏结果公平、公正 公开！由于您的信息保密度至关重要。我们将坚持 实行严格保密和隐私制度。 全网最高信誉，从演示站开始！作为国际专业的网 上博彩游戏运营商，我们承诺，为每一位客户提供 最安全、最公平的博彩娱乐，以及全方位的服务。 我们采用坚实、稳定与安全的博彩系统。所有游戏 共同的优点 — 不须耗时下载；界面简单明了；操 作功能齐全；画面精致优雅；游戏结果公平、公正 公开！由于您的信息保密度至关重要。我们将坚持 实行严格保密和隐私制度。")
        ],
      ),
    );
  }
}
