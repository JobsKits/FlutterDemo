import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/sport/sport_bet_list_model.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../utils/time/time_utils.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../common_helper/betting_biz_helper.dart';
import '../../common_model/betting_common_params.dart';
import '../bet_mine/betting_sport_mybet_logic.dart';
import '../bet_mine/sport_bet_mine_item_view.dart';
import '../bet_mine/sport_bet_mine_unbill_view_item.dart';
import 'sport_bet_mine_detail_dialog_view_title.dart';

final GlobalKey _sportGlobalKey = GlobalKey();

const kSportDetailWidget = 'SportDetailWidget';

///我的投注， 未结算，已结算； item  明细
class SportBetMineDetailDialogView extends StatefulWidget {
  const SportBetMineDetailDialogView({super.key, required this.bean, required this.itemType});

  final ListElement bean;

  // final bool isBilled;//是否已结算
  final BettingOrderItemType itemType; // 列表类型

  ///打开页面，明细框
  static Future<void> showSportDetailWidget<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    BettingOrderItemType itemType = BettingOrderItemType.unBillDetail,
    required ListElement bean,
  }) async {
    log("BettingOrderItemType...$itemType");
    await CustomSafeDialog.show<T>(
        context: context,
        tag: kSportDetailWidget,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: GestureDetector(
                onTap: () {
                  // RouteUtil.popView();
                },
              )),
              SportBetMineDetailDialogView(
                key: _sportGlobalKey,
                bean: bean,
                itemType: itemType,
              ),
              Expanded(child: GestureDetector(
                onTap: () {
                  // RouteUtil.popView();
                },
              )),
            ],
          );
        });
  }

  @override
  State<StatefulWidget> createState() => _SportBetMineDetailDialogViewState();
}

class _SportBetMineDetailDialogViewState extends State<SportBetMineDetailDialogView> {
  final logic = BettingSportMyBetLogic.of();
  final double dialogMaxHeight = Get.height - 100;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: dialogMaxHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container()),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                  color: ThemeService().colorScheme.background,
                ),
                child: Column(
                  children: [
                    //对话框头部，x
                    const SportBetMineDetailDialogTitleView(),
                    //内容明细，包括基本信息 和 列表
                    _buildSportDetail(),
                    //针对未结算，允许注单，重新投注
                    _buildBottomBtn(),
                  ],
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  _buildSportDetail() {
    return ConstrainedBox(
      // alignment: Alignment.center,
      constraints: BoxConstraints.loose(Size.fromHeight(dialogMaxHeight - 120)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(S.current.tab_bar_sports),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  S.current.random_text_237,
                  style: ThemeService().textTheme.labelLarge,
                ),
                // SizedBox(width: 8),
                CustomText(
                  S.current.random_text_238,
                  style: ThemeService().textTheme.labelLarge,
                ),
              ],
            ),
            SizedBox(height: AppValues.padding_4),
            CustomText(
              TimeUtils.timeStampToTime(widget.bean.bt!),
              style: ThemeService().textTheme.labelLarge,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: ThemeService().theme.colorScheme.surface),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SportBetMineItemView(
                bean: widget.bean,
                itemType: widget.itemType,
                // isBilled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///绘制底部按钮
  _buildBottomBtn() {
    if (widget.itemType == BettingOrderItemType.billedList ||
        widget.itemType == BettingOrderItemType.billedDetail) {
      return Container();
    }
    var reBettingList = BettingBizHelper.getSupportReBettingCount(widget.bean);
    // var reBettingList = [];
    return Visibility(
      visible: reBettingList.isNotEmpty,
      child: InkWell(
        onTap: () => logic.onClickDetailReBetting(reBettingList),
        child: Container(
          // color: Colors.transparent,
          color: ThemeService().colorScheme.surface,
          padding: const EdgeInsets.only(bottom: AppValues.defaultMargin, top: AppValues.margin_8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // width: 100,
                // height: 44,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.extraLargePadding, vertical: AppValues.defaultPadding),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F4553),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomText(
                  '${S.current.random_text_555}${reBettingList.length}${S.current.random_text_556}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
