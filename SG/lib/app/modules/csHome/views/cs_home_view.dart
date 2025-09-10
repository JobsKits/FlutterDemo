import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_urls_values.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../controllers/cs_home_controller.dart';
import '../controllers/cs_webview_controller.dart';

class CsHomeView extends GetView{
  CsHomeView({Key? key}) : super(key: key);
  CsHomeController csHomeCtrl = Get.put<CsHomeController>(CsHomeController());
  CsWebViewController csWebViewCtrl = Get.put<CsWebViewController>(CsWebViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        _rootView(),
        GestureDetector(
          onTap: () {
            csHomeCtrl.csEvent();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 300, left: 12, right: 12),
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          S.current.random_text_894,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppThemes.csSubtitle),
                        ),
                        CustomText(S.current.random_text_895,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppThemes.csDesc)),
                      ],
                    ),
                  ),
                  Container(
                    width:12.36,
                    height: 13.8,
                    child:const CustomAssetIcon(name: "assets/images/cs/arrow.png"),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget _rootView() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/cs/cs_bg.webp',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Column(
          children: [
            Padding(// meibo 图标 和 ❌
              padding: const EdgeInsets.only(top: 56, left: 27, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomNetWorkImage(
                    imageUrl:'https://d2utx4nptvgikt.cloudfront.net/brand/1716547703689.webp',
                    // imageUrl: '${AppUrlsValues.envConfig.asset_url}/${csHomeCtrl.globalController.brandDetailPc?['pc']?['pc_logo_white']}',
                    errorWidget: CustomAssetIcon(
                      size: 40,
                      name: 'assets/images/home/ic_sg_logo.webp',
                    ),
                    width: 81,
                    height: 30,
                    fit: BoxFit.scaleDown,
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 16,top: 10),
                    child: const CustomBackIconButton(
                      style: CustomBackIconButtonStyle.close,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 27),
              child: Container(
                height: 50,
                child: Stack(
                  children: List.generate(
                    3,
                        (index) {
                      double left = index * 35.0;
                      return Positioned(
                        left: left,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(color: const Color(0xFF2F4452), width: 3.0),
                          ),
                          child: CustomAssetIcon(
                            size: 38,
                            name: csHomeCtrl.getRandomImagePath(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 27),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  S.current.random_text_892,
                  textAlign:TextAlign.left,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppThemes.csTitle),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 27),
              child: Align(
                alignment:Alignment.centerLeft,
                child: CustomText(
                  S.current.random_text_893,
                  textAlign:TextAlign.left,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppThemes.widgetColorWhite),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
