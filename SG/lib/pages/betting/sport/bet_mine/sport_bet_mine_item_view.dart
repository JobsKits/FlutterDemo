import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../model/sport/sport_bet_list_model.dart';
import '../../../../services/branch/branch_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/odds_util.dart';
import '../../../../utils/time/time_utils.dart';
import '../../../../widget/button/custom_icon_button.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/sport/custom_sport_mixin/custom_sport_live_window_mixin.dart';
import '../../../../widget/sport/until/custom_sport_until.dart';
import '../../../sport/common_model/custom_sport_score_model.dart';
import '../../../sport/common_widget/custom_sport_score_widget.dart';
import '../../../sport/sport_detail/view.dart';
import '../../common_helper/betting_biz_helper.dart';
import '../../common_model/betting_common_params.dart';
import '../betting_sport_state.dart';
import '../bet_detail/sport_bet_mine_detail_dialog_view.dart';

///未结算 和 已结算  公用的item view
class SportBetMineItemView extends StatefulWidget {
  const SportBetMineItemView({
    super.key,
    required this.bean,
    this.itemType = BettingOrderItemType.unBillList,
  });

  final ListElement bean;
  final BettingOrderItemType itemType; // 列表类型

  @override
  State<StatefulWidget> createState() => _SportBetMineItemViewState();
}

class _SportBetMineItemViewState extends State<SportBetMineItemView>
    with CustomSportLiveWindowMixin {
  var showDetail = false;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  @override
  Future addOverlayEntry(double left, double top, BuildContext context) {
    return super.addOverlayEntry(left, top, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // padding: EdgeInsets.only(bottom: 8),
      // color: ThemeService().colorScheme.surfaceVariant,
      // color: ThemeService().colorScheme.surface,
      child: Column(
        children: [
          ///最顶部标题
          _buildTopTitle(),
          //显示一个order 列表 子item
          _buildOrderListView(),

          ///中间，logo线
          _buildMiddleLogo(),

          ///底部投注信息
          _buildBottomBetInfo(),
          Container(
            // color: ThemeService().colorScheme.background,
            child: Image.asset('assets/images/bet_slip/ic_bet_item_wave.webp'),
          ),
          // const SizedBox(height: AppValues.defaultPadding),
        ],
      ),
    );
  }

  // ///遍历 每个订单 的所有注单， 特别是针对复式投注。
  // List<Widget> _buildItemAllView(  List<Bi> biModelList){
  //
  //   for(var model in biModelList){
  //
  //   }
  //   widget.bean.bi.map((model) => _buildTopEventInfo(model)).toList(),
  //
  // }

  Widget _buildLine() {
    return Container(
      height: 3,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }

  String getOcName() {
    if (widget.bean.oc == 1) {
      return S.current.statistics_title_win_text;
    }
    if (widget.bean.oc == 2) {
      return S.current.statistics_title_lose_text;
    }
    if (widget.bean.oc == 3) {
      return S.current.random_text_232;
    }
    if (widget.bean.oc == 4) {
      return S.current.random_text_233;
    }
    if (widget.bean.oc == 5) {
      return S.current.random_text_234;
    }
    if (widget.bean.oc == 6) {
      return S.current.random_text_235;
    }
    return '';
  }

  ///输赢结算状态
  bool getWinColor() {
    if (widget.bean.oc == 1 || widget.bean.oc == 4) {
      return true;
    } else {
      return false;
    }
  }

  ///最顶部标题
  _buildTopTitle() {
    return Container(
      // height: 40,
      // padding: EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.tertiary,
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      child: Row(
        children: [
          SizedBox(width: AppValues.defaultPadding),
          Visibility(
            visible: widget.itemType == BettingOrderItemType.billedList,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                  color:
                      getWinColor() ? AppThemes.chatRoomButtonColor : AppThemes.textColorSecondary,
                  borderRadius: BorderRadius.circular(2)),
              child: CustomText(
                getOcName(),
                style: TextStyle(color: AppThemes.textColorDark, fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
            child: CustomText(
              TimeUtils.timeStampToTime(widget.bean.bt!),
              style: ThemeService().textTheme.labelLarge,
            ),
          ),
          const Expanded(child: SizedBox()),

          /// 按钮 未结算 和 已结算 都可以查看； 详情中不可查看
          Visibility(
            visible: widget.itemType.isOrderListItem(),
            child: InkWell(
                onTap: () {
                  SportBetMineDetailDialogView.showSportDetailWidget(
                    context: context,
                    bean: widget.bean,
                    itemType: widget.itemType == BettingOrderItemType.unBillList
                        ? BettingOrderItemType.unBillDetail
                        : BettingOrderItemType.billedDetail,
                  );
                },
                child: const Padding(
                    padding: EdgeInsets.all(AppValues.defaultPadding),
                    child: CustomIcon(
                      asset: 'assets/images/bet_slip/ic_betting_order_detail.webp',
                      size: 15,
                    ))),
          )
        ],
      ),
    );
  }

  ///显示order 列表
  _buildOrderListView() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      //因为_buildSportScoreExpend 有扩展比分显示， 所以不能整体控制左右内边距，由item控制
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      color: ThemeService().colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          ///赛事情况
          // Column(
          //   children:
          //       widget.bean.bi.map<Widget>((model) => _buildTopEventInfo(model)).toList(),
          // ),
          ///注单列表
          // ...widget.bean.bi
          //     .map((model) => _buildOneOrderItemView(model, widget.bean.bi.last == model))
          //     .toList(),

          ...widget.bean.bi
              .map((model) => _OneOrderItemView(
                    biModel: model,
                    isLast: widget.bean.bi.last == model,
                    isOrderListItem: widget.itemType.isOrderListItem(),
                  ))
              .toList(),
        ],
      ),
    );
  }

  ///中间部logo
  _buildMiddleLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.halfPadding, vertical: AppValues.halfPadding),
      color: ThemeService().colorScheme.surfaceVariant,
      child: Row(
        children: [
          Expanded(child: _buildLine()),
          SizedBox(width: AppValues.defaultMargin),
          ColorFiltered(
              colorFilter: ColorFilter.mode(
                widget.itemType.isOrderListItem() ? Colors.black : Colors.white, // 你想要的颜色
                BlendMode.modulate,
              ),
              child: CustomNetWorkImage(
                imageUrl:
                    '${AppUrlsValues.envConfig.asset_url}/${Get.find<GlobalStateController>().brandDetailPc?['pc']?['pc_logo_white']}',
                errorWidget: CustomAssetIcon(
                  size: 69,
                  name:
                      'assets/images/bet_slip/${widget.itemType.isOrderListItem() ? 'ic_betting_meibo.webp' : 'ic_betting_meibo_light.webp'}',
                ),
                width: 69,
                height: 26,
                fit: BoxFit.scaleDown,
              )),
          SizedBox(width: AppValues.defaultMargin),
          Expanded(child: _buildLine()),
        ],
      ),
    );
  }

  ///订单投注信息， 倍率、投注额、支付额
  _buildBottomBetInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      color: ThemeService().colorScheme.surfaceVariant,
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                S.current.menu_odds,
                style: ThemeService().textTheme.labelLarge,
              ),
              Expanded(child: SizedBox()),
              CustomText(
                OddsUtil().covertOdds(double.parse(widget.bean.ov!)) ?? '',
                style: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: ThemeService().colorScheme.secondary),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              CustomText(
                S.current.random_text_227,
                style: ThemeService().textTheme.labelLarge,
              ),
              Expanded(child: SizedBox()),
              CustomText('${widget.bean.a}'),
              SizedBox(width: 5),
              CustomNetWorkImage(
                width: 14,
                height: 14,
                imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                errorWidget: CustomAssetIcon(
                  name: 'assets/images/bet_slip/ic_defalut.png',
                  size: 14,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              CustomText(
                widget.itemType.isOrderUnBill()
                    ? S.current.random_text_228
                    : S.current.random_text_220,
                style: ThemeService().textTheme.labelLarge,
              ),
              const Expanded(child: SizedBox()),
              CustomText('${widget.bean.mwa}'),
              const SizedBox(width: 5),
              CustomNetWorkImage(
                width: 14,
                height: 14,
                imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                errorWidget: const CustomAssetIcon(
                  name: 'assets/images/bet_slip/ic_defalut.png',
                  size: 14,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

///一个订单中， 可以有多个item， 此为一个item view
///一个订单的 投注信息表， 单式 or 复式列表
class _OneOrderItemView extends StatefulWidget {
  final Bi biModel;
  final bool isLast;
  final bool isOrderListItem;

  const _OneOrderItemView({
    required this.biModel,
    required this.isLast,
    required this.isOrderListItem,
  });

  @override
  State<_OneOrderItemView> createState() => _OneOrderItemViewState();
}

class _OneOrderItemViewState extends State<_OneOrderItemView> {
  var showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //一个item
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // SportDetailPage.openPage(si: widget.bean.bi[0].si, eid: widget.bean.bi[0].ei);
                },
                child: CustomText(
                  BettingBizHelper.getBetDetailTeamNameLabel(widget.biModel),
                  style: ThemeService().textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 5),
              CustomText(
                widget.biModel.btn ?? '',
                style: ThemeService().textTheme.labelLarge,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  CustomText(
                    widget.biModel.sn ?? '',
                    style: ThemeService().textTheme.bodyMedium,
                  ),
                  const Expanded(child: SizedBox()),
                  CustomText(
                    OddsUtil().covertOdds(double.parse(widget.biModel.ov ?? "0")) ?? "",
                    style: ThemeService().textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  CustomText(
                    '${widget.biModel.re}',
                    style: TextStyle(color: AppThemes.sportBetOddsColor),
                  ),
                  const Expanded(child: SizedBox()),
                  Visibility(
                    visible: widget.isOrderListItem,
                    child: CustomIconButton(
                      padding: 0,
                      widgetWidth: 20,
                      widgetHeight: 20,
                      iconWidth: 16,
                      iconHeight: 16,
                      iconWidget: Image.asset(
                        'assets/images/bet_slip/ic_score_detail.webp',
                        width: 16,
                        height: 16,
                      ),
                      onTap: () {
                        setState(() {
                          showDetail = !showDetail;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //对外比分
        _buildSportScoreExpend(widget.biModel),
        Offstage(
          offstage: widget.isLast,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Image.asset(
                'assets/images/bet_slip/ic_sport_bet_dots_line.webp',
              )
              // CustomCirclesDivider(type: DividerType.circle),

              ),
        ),
      ],
    );
  }

  ///赛事结果 比分
  _buildSportScoreExpend(Bi biModel) {
    // var bi = widget.bean.bi.first;
    var bi = biModel;
    var modelTarget = CustomSportScoreModel(
      si: bi.si,
      ed: bi.ed,
      atn: bi.atn,
      htn: bi.htn,
      atpic: bi.atpic,
      htpic: bi.htpic,
      hp: bi.hp,
      ap: bi.ap,
    );
    var polTarget = bi.pol;
    return Container(
      // width: 352.w,
      // height: 174.h,
      child: Stack(
        children: [
          Visibility(
            visible: showDetail,
            child: Container(
              margin: EdgeInsets.only(top: AppValues.halfMargin),
              alignment: Alignment.center,
              child: CustomSportScoreWidget(model: modelTarget, pol: polTarget),
            ),
          ),
        ],
      ),
    );
  }
}
