import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/bet_list/bet_list_logic.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../constant/app_values.dart';
import '../../../constant/app_themes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../betting/sport/bet_mine/sport_bet_mine_unbill_view_item.dart';

class SportMyBetActivity extends BaseView<BetListLogicTwo> {
  SportMyBetActivity({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      child: Obx(() {
        return  controller.state.activityLoading.value?(controller.state.betListActivity.isNotEmpty?ListView.builder(
            itemCount: controller.state.betListActivity.length,
            itemBuilder: (BuildContext buildContext, int index) {
              return SportBetMineUnBillItemView(bean: controller.state.betListActivity[index]);
            }):_buildNoDataView()):SizedBox(
            height: 120,
            child: CustomNetWorkImagePlaceholder(
              color: AppThemes.surfaceVariant.withOpacity(0),
              placeholderType: NetWorkImagePlaceholderType.loading,
              // borderRadius: borderRadius,
              // border: border,
            ));
      }),
    );
  }

  Widget _buildNoDataView() {
    return Container(
      height: Get.height -
          AppBar().preferredSize.height -
          AppValues.sportHeight_20 -
          AppValues.sportHeight_153,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              'assets/images/sport/sport_nodata.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            CustomText(
              S.current.random_text_241,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                color: Color(0xFFB1BAD3),
              ),
            ),
            const SizedBox(height: 5),
            // GestureDetector(onTap:(){
            //   widget.logic.state.activityLoading.value=false;
            //   widget.logic.loadActivityInfo(0);
            // },child:
            InkWell(onTap:(){
              controller.goToMain('sport');
            },child: CustomText(S.current.random_text_217)),
          ],
        ),
      ),
    );
  }

}