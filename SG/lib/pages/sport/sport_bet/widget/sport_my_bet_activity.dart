import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../widget/custom_text.dart';
import '../../../betting/sport/bet_mine/sport_bet_mine_unbill_view_item.dart';
import '../logic.dart';
import 'sport_my_bet_params.dart';

class SportMyBetActivity extends StatefulWidget {
  SportMyBetActivity({super.key,this.fromPage});
  final SportMyBetFromPage? fromPage;

  @override
  State<SportMyBetActivity> createState() => _SportMyBetActivityState();
}

class _SportMyBetActivityState extends State<SportMyBetActivity> {
  final controller = Get.find<SportBetLogic>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      // log("我的投注界面...未结算...boxConstraints...$boxConstraints");
      return Container(
        child: Obx(() {
          return Stack(
            children: [
              Visibility(
                // visible: controller.state.betListActivity.isNotEmpty,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.state.betListActivity.length,
                    itemBuilder: (BuildContext buildContext, int index) {
                      return SportBetMineUnBillItemView(bean: controller.state.betListActivity[index]);
                    }),
              ),
              Visibility(
                visible: controller.state.betListActivity.isEmpty,
                child: _buildNoDataView(),
              )
            ],
          );
        }),
      );
    });
  }

  Widget _buildNoDataView() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              'assets/images/sport/sport_nodata.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_8),
            CustomText(S.current.random_text_681, style: ThemeService().textTheme.labelLarge),
            CustomButton(
              //"立即开始下注!"
              title: S.current.sport_betting_begin_bet,
              alignment: Alignment.center,
              textStyle: ThemeService().textTheme.bodyMedium,
              onTap: () => controller.onClickGotoBetting(widget.fromPage),
            ),
            // const SizedBox(height: AppValues.sportHeight_16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(S.current.yulecheng_prepage,textColorStyle: CustomTextColorStyle.secondary,),
                const SizedBox(width: AppValues.sportHeight_16),
                CustomText(S.current.yulecheng_nextpage,textColorStyle: CustomTextColorStyle.secondary,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
