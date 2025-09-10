import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/login_log.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/cell/custom_tooltip_widget.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import 'logic.dart';

class LoginLogPage extends StatelessWidget {
  LoginLogPage({Key? key}) : super(key: key);
  final controller = Get.put(LoginLogLogic());

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loading.value ?  SizedBox(
      height: 150,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
      )) : _buildListWidget());
  }

  Widget _buildEmpty() {
    return const SizedBox(
        width: double.infinity,
        height: 250,
        child: Center(
            child: CustomEmptyWidget(
          width: 180,
          height: 180,
        )));
  }

  Widget _buildListWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 38),
      padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ThemeService().colorScheme.surface,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: AppValues.defaultMargin,
            ),
            Scrollbar(
              // thumbVisibility: true,
              // trackVisibility: true,
              // thickness: 5,
              // interactive: true,
              child: SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                // physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    _buildTopBar(),
                    // ...buildCardList(controller.dataArray),
                    Obx(() =>  Column(
                      children: controller.dataArray.asMap().keys.map((index) => LoginLogCard(model: controller.dataArray[index], position: index)).toList(),
                    ))
                  ],
                ),
              ),
            ),
            Obx(() => controller.showEmpty.value ? _buildEmpty() : Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => CustomButton(
                  textColor: controller.memPage.value <= 1
                      ? const Color(0xff5b687a)
                      : AppThemes.widgetColorWhite,
                  title: S.current.yulecheng_prepage,
                  onTap: () => controller.onLastPage(),
                )),
                const SizedBox(
                  width: AppValues.defaultPadding,
                ),
                Obx(() => CustomButton(
                  textColor: !controller.ifNextPage()
                      ? const Color(0xff5b687a)
                      : AppThemes.widgetColorWhite,
                  title: S.current.yulecheng_nextpage,
                  onTap: () => controller.onNextPage(),
                )),
              ],
            ),
            const SizedBox(
              height: AppValues.halfMargin,
            ),
          ],
        ),
      )
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Center(
              child: CustomText(S.current.random_text_482,
                  textColorStyle: CustomTextColorStyle.normal),
            ),
          ),
          SizedBox(
            width: 100,
            child: Center(
              child: CustomText(S.current.random_text_483,
                  textColorStyle: CustomTextColorStyle.normal),
            ),
          ),
          SizedBox(
            width: 100,
            child: Center(
              child: CustomText(S.current.random_text_781, textColorStyle: CustomTextColorStyle.normal),
            ),
          ),
          SizedBox(
            width: LangService().isChinese?80:140,
            child: Center(
              child: CustomText(S.current.random_text_481,
                  textColorStyle: CustomTextColorStyle.normal),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
    );
  }

  List<Widget> buildCardList(List<LoginLogModel> list) {
    final List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      widgets.add(LoginLogCard(
        model: list[i],
        position: i,
      ));
    }
    // for (LoginLogModel model in list) {
    //   widgets.add(LoginLogCard(
    //     model: model,
    //   ));
    // }
    return widgets;
  }
}

class LoginLogCard extends StatelessWidget {
  final LoginLogModel model;
  final int position;

  const LoginLogCard({super.key, required this.model, required this.position});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: position % 2 == 0 ? ThemeService().colorScheme.surfaceVariant : Colors.transparent,
      ),
      height: 54,
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: CustomTooltipWidget(
              message: model.browser,
              isShow: model.browser != null && model.browser!.length > 18,
              child: Center(
                child: CustomText(
                  dealTooLongLabel(model.browser, 18),
                  // '012345678901234567890123456',
                  // 'model.browser1234567',
                  textColorStyle: CustomTextColorStyle.normal,
                  maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
              width: 100,
              child: CustomTooltipWidget(
                message: model.getIpAddress,
                isShow: model.getIpAddress != null && model.getIpAddress!.length > 10,
                child: Center(
                  child: CustomText(
                    dealTooLongLabel(model.getIpAddress, 10),
                    textColorStyle: CustomTextColorStyle.normal,
                    maxLines: 1,
                  ),
                ),
              )),
          SizedBox(
            width: 100,
            child: CustomTooltipWidget(
              message: model.loginip,
              isShow: model.loginip != null && model.loginip!.length > 12,
              child: Center(
                child: CustomText(
                  dealTooLongLabel(model.loginip, 12),
                  textColorStyle: CustomTextColorStyle.normal,
                  maxLines: 1,
                ),
              ),
            ),
          ),

          // SizedBox(
          //   width: 100,
          //   child: Center(
          //     child: CustomText(model.getRecentTime ?? '',
          //         textColorStyle: CustomTextColorStyle.normal,
          //         maxLines: 1,
          //         overflow: TextOverflow.ellipsis),
          //   ),
          // ),
          SizedBox(
            // width: 100,
            width: LangService().isChinese?80:140,
            child: CustomTooltipWidget(
              message: model.getRecentTime,
              isShow: model.getRecentTime != null && model.getRecentTime!.length > 12,
              child: Center(
                child: CustomText(
                  dealTooLongLabel(model.getRecentTime, 12),
                  textColorStyle: CustomTextColorStyle.normal,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  ///超过20个字符的，手指触碰省略字段，小浮窗显示全部内容
  String dealTooLongLabel(String? browser, int length) {
    if (browser == null) {
      return "";
    } else if (browser.length <= length) {
      return browser;
    } else {
      return "${browser.substring(0, length)}...";
    }
  }
}
