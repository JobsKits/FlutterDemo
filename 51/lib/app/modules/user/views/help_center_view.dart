import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/constants/help_center_constants.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/common_color.dart';

//帮助中心
class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("帮助中心"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _buildList();
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: HelpCenterConstants.helpList.length,
      itemBuilder: (context, index) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r), color: Colors.white),
            margin: EdgeInsets.only(top: 28.h, left: 33.w, right: 33.w),
            child: ListTile(
              onTap: () {
                AppManager.instance.tapVibrate();
                if (HelpCenterConstants.helpList[index].title == "关于我们") {
                  Get.toNamed(Routes.ABOUT_US);
                } else {
                  String title = HelpCenterConstants.helpList[index].title;
                  String text = HelpCenterConstants.helpList[index].text;
                  if (title == '代理条件') {
                    String baseURL = NetworkService().baseURL;
                    text = text.replaceAllMapped(
                      RegExp(r'src="(/[^"]+)"'),
                      (match) => 'src="${baseURL}${match.group(1)}"',
                    );
                  }
                  Get.toNamed(Routes.WEB_VIEW, arguments: {
                    "url": text,
                    "title": title,
                    "isChangeHtmlFontSize": true
                  });
                }
              },
              title: Text(
                "${HelpCenterConstants.helpList[index].title}",
                style: TextStyle(fontSize: 45.sp, color: Color(color2D2D2D)),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 50.w,
                color: Color((colorCECECE)),
              ),
            ));
      },
    );
  }
}
