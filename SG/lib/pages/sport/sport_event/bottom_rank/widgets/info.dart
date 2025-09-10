import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/betting/common_helper/betting_biz_helper.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_themes.dart';
import '../../../../../constant/app_urls_values.dart';
import '../../../../../constant/app_values.dart';
import '../../../../../controllers/global_state_controller.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../model/sport/sport_bet_list_model.dart';
import '../../../../../model/yulecheng/big_wins_model.dart';
import '../../../../../services/branch/branch_service.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../utils/odds_util.dart';
import '../../../../../utils/route_util.dart';
import '../../../../../utils/time/time_utils.dart';
import '../../../../../widget/custom_asset_icon.dart';
import '../../../../../widget/custom_bubble.dart';
import '../../../../../widget/custom_icon.dart';
import '../../../../../widget/custom_text.dart';
import '../../../../../widget/cell/custom_tooltip_widget.dart';
import '../../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../../../../betting/casino_detail/custom_casino_detail_dialog_biz.dart';
import '../../../../betting/common_model/betting_record_api_model.dart';

final GlobalKey _casinoGlobalKey = GlobalKey();

class CustomSportDetailDialogWidget extends StatefulWidget {
  const CustomSportDetailDialogWidget({super.key, required this.model});

  final BigWinsModel model;

  ///静态方法，打开方法, 显示窗口
  static Future<void> showDetailDialog<T>({
    required BuildContext context,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
    required BigWinsModel model,
  }) async {
    await CustomSafeDialog.show<T>(
        context: context,
        tag: 'kSportsDetailWidget',
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: GestureDetector(
                onTap: () {
                  // RouteUtil.popView();
                },
              )),
              // game_common(type: "0",label: "common"), //普通游戏
              // game_limbo(type: "1",label: "Limbo"),
              // game_hilo(type: "2",label: "Hilo"),
              // game_plinko(type: "3",label: "Plinko"),
              // game_blackjack(type: "4",label: "Blackjack"),
              // game_mines(type: "5",label: "Mines"),
              // game_dice(type: "6",label: "Dice"),
              // game_crash(type: "7",label: "Crash");
              CustomSportDetailDialogWidget(
                key: _casinoGlobalKey,
                model: model,
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
  State<StatefulWidget> createState() => _CustomSportDetailDialogWidgetState();
}

class _CustomSportDetailDialogWidgetState extends State<CustomSportDetailDialogWidget>
    with MoneyCoinListItemMixin, CustomCasinoDetailDialogBizMixin {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final double dialogMaxHeight = Get.height - 100;
  final GlobalKey _globalKeyCopy = GlobalKey();
  final GlobalKey _globalKeyLink = GlobalKey();
  final GlobalKey _globalKeyTip = GlobalKey();

  late BettingRecordApiModel data;
  late ListElement bean;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在widget初始化之后访问GlobalKey.currentState
      // do something
      // getWidgetOffset();
    });

    var dic = widget.model.toJson();
    data = BettingRecordApiModel.fromJson(dic);
    var detail = json.decode(widget.model.detail!);
    detail['bi'] = [detail['bi']];
    bean = ListElement.fromJson(detail);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: dialogMaxHeight,
          child: LayoutBuilder(
            builder: (_, constraints) {
              // log("CustomCasinoDetailDialogWidget...constraints...$constraints");
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacer(),
                  Expanded(child: Container()),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      color: ThemeService().colorScheme.background,
                      child: Column(
                        children: [
                          const SizedBox(height: AppValues.margin_2),
                          //表头
                          _buildTopTitleView(),
                          //正文
                          _buildContentDetailView(),
                        ],
                      ),
                    ),
                  ),

                  // Expanded(child: _buildCasinoDetailView())
                  // Center(child: _buildCasinoDetailView()),
                  // const SizedBox(height: AppValues.defaultMargin),
                  Expanded(child: Container()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _buildTopTitleView() {
    return Row(
      children: [
        const SizedBox(width: 12),
        const CustomIcon(
          color: AppThemes.iconColor,
          asset: "assets/images/bet_slip/ic_casino_bet_order.webp",
          size: 18,
        ),
        const SizedBox(width: 4),
        CustomText(
          S.current.tab_bar_order,
          style: ThemeService()
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            RouteUtil.popView();
          },
          child: const Padding(
            padding: EdgeInsets.all(AppValues.defaultPadding),
            child: CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png',
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  _buildContentDetailView() {
    return ConstrainedBox(
        constraints: BoxConstraints.loose(Size.fromHeight(dialogMaxHeight - 50)),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            // shrinkWrap: true,
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //订单号、投注者基本信息
              _buildDetailHeader(),
              mainView(),
            ],
          ),
        ));
  }

  Widget mainView() {
    return Container(
      // height: 300,
      color: ThemeService().colorScheme.surface,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding,vertical: 24),
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
            Image.asset('assets/images/bet_slip/ic_bet_item_wave.webp')
          ],
        ),
      ),
    );
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
          const SizedBox(width: AppValues.defaultPadding),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
            child: CustomText(
              TimeUtils.timeStampToTime(int.parse(data.createdAt!)),
              style: ThemeService().textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  ///显示order 列表
  _buildOrderListView() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      //因为_buildSportScoreExpend 有扩展比分显示， 所以不能整体控制左右内边距，由item控制
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      color: ThemeService().colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              // 游戏类型icon
              CustomNetWorkImage(
                imageUrl: BranchService.instance.current.asset_url + data.icon!,
                width: 14,
                height: 14,
                errorWidget: const CustomAssetIcon(name: 'assets/images/network_image/777.png'),
              ),
              const SizedBox(width: AppValues.defaultPadding,),
              Expanded(child: CustomText('${bean.bi.first.htn!} - ${bean.bi.first.atn!}',style: const TextStyle(fontWeight: FontWeight.w600),),)
            ],
          ),
          // const SizedBox(height: 8),
          CustomText('${bean.bi.first.btn}',textColorStyle: CustomTextColorStyle.normal,),
          // const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('${bean.bi.first.pgn}',style: const TextStyle(fontWeight: FontWeight.w600),),
              CustomText(OddsUtil().covertOdds(double.parse(bean.ov!)))
            ],
          ),
          // const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(TimeUtils.timeStampToTime(int.parse(data.createdAt!)),style: ThemeService().textTheme.labelLarge,),
              const CustomIcon(
                asset: 'assets/images/personal_center_icon/count_data.webp',
                size: 16,
              ),
            ],
          )
        ],
      ),
    );
  }

  ///中间部logo
  _buildMiddleLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppValues.halfPadding),
      color: ThemeService().colorScheme.surfaceVariant,
      child: Row(
        children: [
          Expanded(child: _buildLine()),
          const SizedBox(width: AppValues.defaultMargin),
          ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white, // 你想要的颜色
                BlendMode.modulate,
              ),
              child: CustomNetWorkImage(
                imageUrl:
                    '${AppUrlsValues.envConfig.asset_url}/${Get.find<GlobalStateController>().brandDetailPc?['pc']?['pc_logo_white']}',
                errorWidget: const CustomAssetIcon(
                  size: 69,
                  name:
                      'assets/images/bet_slip/ic_betting_meibo_light.webp',
                ),
                width: 69,
                height: 26,
                fit: BoxFit.scaleDown,
              )),
          const SizedBox(width: AppValues.defaultMargin),
          Expanded(child: _buildLine()),
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      height: 3,
      color: ThemeService().theme.colorScheme.tertiary,
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
              const Expanded(child: SizedBox()),
              CustomText(
                OddsUtil().covertOdds(double.parse(bean.ov!)),//ov
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
              const Expanded(child: SizedBox()),
              CustomText('${data.betAmount}'),
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
          const SizedBox(height: 5),
          Row(
            children: [
              CustomText(S.current.random_text_228,
                style: ThemeService().textTheme.labelLarge,
              ),
              const Expanded(child: SizedBox()),
              CustomText('${data.payAmount}'),
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


  ///--------------------------------
  Widget _buildDetailHeader() {
    return Column(
      children: [
        CustomText(
          S.current.tab_bar_sports,
          style: ThemeService().textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
        // const SizedBox(height: AppValues.margin_4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CustomText(
            //   "ID ${widget.data?.billNo ?? ''}",
            //   style: ThemeService().textTheme.bodyMedium?.copyWith(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //       ),
            // ),
            //【0312】【需求变更】投注详情 ID 显示没有千分号
            CustomTooltipCellWidget(
              maxLength: 30,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
              // content: "ID ${widget.data?.billNo ?? ''}",
              content: "ID ${BettingBizHelper.getFormatComma(data.billNo)}",
              // content: "ID ",
            ),
            const SizedBox(width: AppValues.halfPadding),

            //复制小图标
            CustomTooltipWidget(
              padding: EdgeInsets.zero,
              verticalOffset: 10,
              decoration: const BoxDecoration(color: Colors.transparent),
              richMessage: WidgetSpan(
                // alignment: PlaceholderAlignment.bottom,
                child: _buildTipContentView(S.current.random_text_799, _globalKeyCopy),
              ),
              onTriggered: () {
                // log("复制成功：${widget.data?.billNo}");
                // tooltipOffset(_globalKeyCopy);
                onClickCopyAndTooltip(data.billNo);
              },
              child: Padding(
                key: _globalKeyCopy,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.halfPadding, vertical: AppValues.defaultPadding),
                child: const CustomAssetIcon(
                  name: "assets/images/common/ic_common_copy_gray.webp",
                  size: 14,
                  // color: Color(0xFFB1BAD3),
                ),
              ),
            ),

            //链接小图标
            CustomTooltipWidget(
              padding: EdgeInsets.zero,
              verticalOffset: 10,
              decoration: const BoxDecoration(color: Colors.transparent),
              richMessage: WidgetSpan(
                // alignment: PlaceholderAlignment.bottom,
                child: _buildTipContentView(S.current.random_text_800, _globalKeyLink),
              ),
              onTriggered: () {
                // log("复制成功：${widget.data?.billNo}");
                // tooltipOffset(_globalKeyLink);
                onClickCopyAndTooltip(data.billNo);
              },
              child: Padding(
                  key: _globalKeyLink,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.halfPadding, vertical: AppValues.defaultPadding),
                  child: const CustomAssetIcon(
                      name: "assets/images/common/ic_common_link_gray.webp", size: 14)),
            ),
          ],
        ),
        const SizedBox(height: AppValues.margin_12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              S.current.random_text_237,
              style: ThemeService().textTheme.labelMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            // const SizedBox(width: 4),
            Visibility(
              visible: data.username!.isEmpty,
              child:
                  const CustomIcon(asset: 'assets/images/bet_slip/ic_yingshen.webp', size: 14)),
            const SizedBox(width: 4),
            CustomText(
              data.username!.isNotEmpty ? data.username! : S.current.random_text_238,
              style: ThemeService().textTheme.labelMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.padding_4),
        CustomText(
          // '${S.current.random_text_223}${TimeUtils.timeStampToTime(widget.data.betTime ?? 0)}',
          BettingBizHelper.getDialogCasinoDetailBetTime(
              data.betTime ?? (int.parse(data.createdAt ?? "0") * 1000)),
          style: ThemeService().textTheme.labelMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppValues.padding_16,)
      ],
    );
  }

  _buildTipContentView(String? content, GlobalKey iconKey) {
    // final RenderBox renderBox = _globalKeyCopy.currentContext!.findRenderObject() as RenderBox;
    // Offset offset = renderBox.localToGlobal(Offset.zero);
    // log("_buildTipContentView...offset...$offset");
    return UnconstrainedBox(
      key: _globalKeyTip,
      child: BubbleView(
        direction: ArrowDirection.bottom,
        arrowWidth: 8,
        arrowHeight: 4,
        borderRadius: const Radius.circular(4.0),
        arrowBasisOffset: 0,
        //偏移修改
        arrowPeakOffset: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: CustomText(
          content ?? '',
          style: ThemeService().textTheme.labelMedium?.copyWith(
                color: const Color(0xFF13212D),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        offsetCallback: (size, offset) {
          // 获取组件 icon大小和偏移
          final RenderBox iconRenderBox = iconKey.currentContext?.findRenderObject() as RenderBox;
          Size iconSize = iconRenderBox.size;
          final iconOffset = iconRenderBox.localToGlobal(Offset.zero);
          // log("offsetCallback...iconSize=$iconSize...iconOffset=$iconOffset");
          // 获取组件 tooltip大小和偏移
          final RenderBox tipRenderBox =
              _globalKeyTip.currentContext?.findRenderObject() as RenderBox;

          final tipOffset = tipRenderBox.localToGlobal(Offset.zero);
          // log("offsetCallback...tipSize=$tipSize...tipOffset=$tipOffset");
          return iconOffset.dx - tipOffset.dx + iconSize.width / 2;
        },
      ),
    );
  }

  final copyOffsetXObs = 0.0.obs;

  double getWidgetOffset() {
    // final RenderObject? renderObject = _globalKeyLink.currentContext!.findRenderObject();
    //_globalKeyLink
    if (_globalKeyCopy.currentContext != null) {
      _globalKeyCopy.currentContext!;
      final RenderBox renderBox = _globalKeyCopy.currentContext!.findRenderObject() as RenderBox;

      Offset offset = renderBox.localToGlobal(Offset.zero);
      log("offset...$offset");
      log("size...${renderBox.size}");
      log("Get.width...${Get.width}");
      //offset...Offset(276.5, 122.5)
      //offset...Offset(300.5, 122.5)
      //Get.width...390.0
      // [log] offset...Offset(326.5, 122.5)
      // [log] Get.width...390.
      //28

      //【copy】【Offset.zero】：16 合理
      // [log] offset...Offset(276.5, 122.5)
      // [log] size...Size(26.0, 38.0)
      // [log] Get.width...390.0

      //【linK】【Offset.zero】：28 合理
      // [log] offset...Offset(302.5, 122.5)
      // [log] size...Size(26.0, 38.0)
      // [log] Get.width...390.0
      copyOffsetXObs.value = renderBox.size.width;
      return 0.0;
    } else {
      return 0.0;
    }
  }

}
