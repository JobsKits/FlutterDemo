import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../routes/routes.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../alliance_plan_logic.dart';
import '../widget/custom_select_widget.dart';
import 'commission_receive_logic.dart';
import 'commission_receive_view_item.dart';

///联盟计划-领取佣金
class CommissionReceivePage extends BaseView<CommissionReceiveLogic> {
  CommissionReceivePage({Key? key}) : super(key: key);

  final controllerFather = Get.find<AlliancePlanLogic>();
  final logic = Get.find<CommissionReceiveLogic>();
  final state = Get.find<CommissionReceiveLogic>().state;

  ///打开页面
  static openPage() {
    RouteUtil.pushToView(Routes.personalCommissionReceive);
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleView: Text(S.current.random_text_97),
      showLeading: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppValues.defaultMargin),
      color: ThemeService().colorScheme.surface, // 设置背景色
      child: Column(
        children: [
          _buildTopViewUp(),
          SizedBox(height: AppValues.defaultMargin),
          _buildTopViewDown(),
          _buildListTitle(),
          _buildListView(),
          _buildBottomView(),
          SizedBox(height: AppValues.defaultMargin),
        ],
      ),
    );
  }

  _buildTopViewUp() {
    return Container(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: S.current.random_text_98,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            TextSpan(
              text: '999999.00USDT，',
              style: TextStyle(
                color: Color(0xFFFF9800),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            TextSpan(
              text: S.current.random_text_99,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTopViewDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomSelectWidget(
          width: 100,
          modelList: controllerFather.selectTypeListObs,
          initSelected: null,
          hintText: S.current.random_text_100,
          onSelected: (index, model) {},
        ),
        Spacer(),
        SizedBox(width: AppValues.defaultMargin),
        Container(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: S.current.random_text_101,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: '999,999,00',
                  style: TextStyle(
                    color: Color(0xFFFF9800),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppValues.margin_2),
        CustomAssetIcon(
          name: "assets/images/coin_icon/eth_ic.png",
          size: 15,
        )
      ],
    );
  }

  _buildListTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        vertical: AppValues.largePadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            S.current.random_text_102,
            style: ThemeService().textTheme.bodyMedium,
          ),
          const SizedBox(width: 40),
          CustomText(
            S.current.random_text_103,
            style: ThemeService().textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  _buildListView() {
    return Expanded(
      child: Container(
        color: ThemeService().colorScheme.surface, // 设置背景色
        child: Obx(() {
          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: logic.modelList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return CommissionReceiveItemView(index: index, model: logic.modelList[index]);
            },
          );
        }),
      ),
    );
  }

  _buildBottomView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
      child: Obx(() {
        return CustomBigMainButton(
          title: S.current.feedback_confirm_receive,
          isEnable: logic.isHaveReceive.value,
          onTap: (btnController) {
            logic.onClickReceive();
          },
        );
      }),
    );
  }
}
