import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/betting/common_helper/betting_biz_helper.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/cell/custom_tooltip_cell_hide_widget.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_bubble.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/cell/custom_tooltip_widget.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/expand/custom_expansion_tile_widget.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../widget/cell/custom_tooltip_cell_widget.dart';
import '../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../common_model/betting_common_params.dart';
import '../common_model/betting_record_api_model.dart';
import '../common_model/casino_detail_item_model.dart';
import 'custom_casino_detail_dialog_biz.dart';
import 'custom_casino_detail_dialog_item_view.dart';

final GlobalKey _casinoGlobalKey = GlobalKey();

const kCasinoDetailWidget = 'CasinoDetailWidget';

class CustomCasinoDetailDialogWidget extends StatefulWidget {
  const CustomCasinoDetailDialogWidget({super.key, required this.data, required this.gameType});

  final BettingRecordApiModel data;
  final CasinoGameTypeEnum gameType;

  ///静态方法，打开方法, 显示窗口
  static Future<void> showDetailDialog<T>({
    required BuildContext context,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
    required BettingRecordApiModel recordModel,
  }) async {
    var gameTypeEnum = CasinoGameTypeEnum.adaptor(recordModel.gameCode);
    await CustomSafeDialog.show<T>(
        context: context,
        tag: kCasinoDetailWidget,
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
              CustomCasinoDetailDialogWidget(
                key: _casinoGlobalKey,
                data: recordModel,
                gameType: gameTypeEnum,
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
  State<StatefulWidget> createState() => _CustomCasinoDetailDialogWidgetState();
}

class _CustomCasinoDetailDialogWidgetState extends State<CustomCasinoDetailDialogWidget>
    with MoneyCoinListItemMixin, CustomCasinoDetailDialogBizMixin {
  // final double dialogMaxHeight = Get.height - 100;
  final double dialogMaxHeight =
      Get.height - AppValues.barBottomHeightMargin - AppValues.barTopHeightMargin;
  final GlobalKey _globalKeyCopy = GlobalKey();
  final GlobalKey _globalKeyLink = GlobalKey();
  final GlobalKey _globalKeyTip = GlobalKey();
  final GlobalKey globalKeyDiceProcess = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在widget初始化之后访问GlobalKey.currentState
      // do something
      // getWidgetOffset();
      if (widget.gameType == CasinoGameTypeEnum.game_dice) {
        getDiceProcessWidth(globalKeyDiceProcess);
      }
    });
    var id = widget.data.billNo;
    var uid = widget.data.uid;
    loadRecordProve(id: id, uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: dialogMaxHeight,
          child: LayoutBuilder(
            builder: (_, constraints) {
              log("CustomCasinoDetailDialogWidget...constraints...$constraints");
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacer(),
                  Expanded(child: Container()),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: ThemeService().colorScheme.background,
                    ),
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
          S.current.tab_bar_order_copy,
          style: ThemeService()
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Spacer(),
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
        child: Container(
          // alignment: Alignment.center,
          // height: constraints.maxHeight,
          // constraints: BoxConstraints.loose(),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            // controller: scrollController,
            child: Column(
              // shrinkWrap: true,
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //订单号、投注者基本信息
                _buildDetailHeader(widget.gameType),
                //logo分割线
                _buildLogoDividerView(),
                //投注单数量、支付额
                _buildDetailMiddle(),
                //根据不同游戏类型， 显示不同view
                _buildGameTypeView(widget.gameType),
                //跳转按钮
                _buildDetailButton(widget.gameType),
                Visibility(
                    visible: widget.gameType.isGameCommon(),
                    child: const SizedBox(height: AppValues.defaultMargin)),
                //meibo 小游戏特有
                Visibility(
                  visible: !widget.gameType.isGameCommon(),
                  child: Obx(() {
                    return _buildDetailBottomExpend(widget.gameType);
                  }),
                ),
                // Stack(
                //   alignment: Alignment.bottomCenter,
                //   children: [
                //     _buildDetailBottomExpend(widget.gameType),
                //     Container(
                //       height: 8,
                //       decoration: BoxDecoration(
                //         borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                //         color: ThemeService().colorScheme.background,
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }

  Widget _buildLogoDividerView() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.margin_24),
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          // _buildLine(),
          Expanded(child: CustomDividerWidget(height: 3)),
          // const SizedBox(width: AppValues.margin_40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppValues.padding_6),
            child:
                // Image.asset(
                //   "assets/images/bet_slip/ic_betting_meibo_light.webp",
                //   height: 45,
                // ),
                CustomAssetIcon(
              name: "assets/images/common/ic_common_logo_meibo_white.webp",
              // color: AppThemes.iconColor,
              color: Colors.white,
              height: 30,
              boxFit: BoxFit.fitHeight,
            ),
          ),
          Expanded(child: CustomDividerWidget(height: 3)),
          // _buildLine(),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(CasinoGameTypeEnum gameType) {
    return Column(
      children: [
        CustomText(
          "${gameType.isGameCommon() ? (widget.data?.gameName ?? '') : gameType.label}",
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
              maxLength: 36,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
              // content: "ID ${widget.data?.billNo ?? ''}",
              content: S.current.random_text_1194+
                  "${BettingBizHelper.getFormatComma("${widget.data.adaptorBillNoHash()}")}",
              // content: "ID ",
            ),
            // const SizedBox(width: AppValues.halfPadding),

            //复制小图标
            CustomTooltipWidget(
              padding: EdgeInsets.zero,
              verticalOffset: 10,
              decoration: const BoxDecoration(color: Colors.transparent),
              richMessage: WidgetSpan(
                // alignment: PlaceholderAlignment.bottom,
                // child: _buildTipContentView(S.current.random_text_799, _globalKeyCopy),
                child: _buildTipContentView(S.current.successfullyCopi, _globalKeyCopy),
              ),
              onTriggered: () {
                // log("复制成功：${widget.data?.billNo}");
                // tooltipOffset(_globalKeyCopy);
                onClickCopyAndTooltip(widget.data?.billNo);
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
            Visibility(
              //todo:【0527需求变更】【个人中心 - 我的投注】娱乐城：任意点击注单编号查详情，链接分享请去掉
              visible: false,
              child: CustomTooltipWidget(
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
                  onClickCopyAndTooltip(widget.data?.billNo);
                },
                child: Padding(
                    key: _globalKeyLink,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.halfPadding, vertical: AppValues.defaultPadding),
                    child: const CustomAssetIcon(
                        name: "assets/images/common/ic_common_link_gray.webp", size: 14)),
              ),
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
            // SizedBox(width: 12),
            //todo：【0528】为空显示隐藏
            widget.data.isHideUserName()
                ? CustomTooltipCellHideWidget(content: S.current.random_text_1195)
                : CustomText(
                    // 'dwwyy332',
                    widget.data.username ?? "",
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
              widget.data.betTime ?? (int.parse(widget.data.createdAt ?? "0") * 1000)),
          style: ThemeService().textTheme.labelMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          Size tipSize = tipRenderBox.size;
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

  Widget _buildDetailMiddle() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: ThemeService().theme.colorScheme.surface),
      width: double.infinity,
      margin: EdgeInsets.all(AppValues.defaultMargin),
      padding: EdgeInsets.all(AppValues.margin_20),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///投注数量
          CustomText(S.current.tab_bar_order_copy,
              style: ThemeService()
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
          // CustomText('${widget.data?.betAmount}'),
          MoneyCoinCellWidget(
            money: widget.data.betAmount,
            // money: "-1",
            coinBean: getCoinBean(widget.data.currencyId, cache: false),
            colorSwitch: true,
            color: Colors.white,
            // colorSwitchValues: const [
            //   MoneyCoinCellWidget.w,
            //   MoneyCoinCellWidget.gray,
            //   MoneyCoinCellWidget.gray
            // ],
            maxLength: 15,
            fontSize: 14,
            coinSize: 14,
          ),
          const SizedBox(height: AppValues.margin_12),

          ///乘数
          CustomText(S.current.random_text_224,
              style: ThemeService()
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
          CustomText('${BettingBizHelper.getDetailFactor(widget.data.factor)}x'),
          const SizedBox(height: AppValues.margin_12),

          ///支付额
          CustomText(S.current.random_text_220,
              style: ThemeService()
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),

          // CustomText('${widget.data?.netAmount}'),
          MoneyCoinCellWidget(
            money: widget.data.settleAmount,
            // money: "-1",
            coinBean: getCoinBean(widget.data.currencyId, cache: false),
            colorSwitch: true,
            colorSwitchValues: const [
              MoneyCoinCellWidget.green,
              MoneyCoinCellWidget.gray,
              MoneyCoinCellWidget.gray
            ],
            maxLength: 15,
            fontSize: 14,
            coinSize: 14,
          ),
        ],
      ),
    );
  }

  ///根据不同游戏类型， 显示view
  Widget _buildGameTypeView(CasinoGameTypeEnum type) {
    switch (type) {
      case CasinoGameTypeEnum.game_common:
        return Container();
      case CasinoGameTypeEnum.game_limbo:
        return _bulidView_game_limbo();

      case CasinoGameTypeEnum.game_hilo:
        return _bulidView_game_hilo();

      case CasinoGameTypeEnum.game_plinko:
        return _bulidView_game_plinko();

      case CasinoGameTypeEnum.game_blackjack:
        return _bulidView_game_blackjack();

      case CasinoGameTypeEnum.game_mines:
        return _bulidView_game_mines();

      case CasinoGameTypeEnum.game_dice:
        return _bulidView_game_dice();

      case CasinoGameTypeEnum.game_crash:
        return _bulidView_game_crash();

      default:
        return Container();
    }
  }

  _bulidView_game_limbo() {
    return Obx(() {
      return Column(
        children: [
          CustomText(S.current.random_text_801,
              style: ThemeService()
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: AppValues.margin_4),
          CustomText('${proveApiModel.proveBetDetail?.multiplierTarget ?? ""} x',
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppValues.defaultMargin),
          CustomText(S.current.random_text_802,
              style: ThemeService()
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: AppValues.margin_4),
          CustomText('${proveApiModel.proveBetDetail?.result ?? ""} x',
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // color: Color(0xffED4263),
                    color: widget.data.isLoseAmount()
                        ? const Color(0xffED4263)
                        : const Color(0xff00E700),
                  )),
          const SizedBox(height: AppValues.defaultMargin),
        ],
      );
    });
  }

  _bulidView_game_hilo() {
    return Container(
      margin: EdgeInsets.only(bottom: AppValues.defaultMargin),
      child: CustomNetWorkImage(
        height: 66,
        fit: BoxFit.fitHeight,
        imageUrl:
            "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
      ),
    );
  }

  _bulidView_game_plinko() {
    return Obx(() {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              // color: ThemeService().primaryColor,
              // color: ThemeService().colorScheme.tertiary,
              // color:  Color(0xFFFA6020),
              // color:  Color(0xfac000),
              color: Color(PlinkoGameConfigEnum.colorAdaptor(
                  row: proveApiModel.proveBetDetail?.rows,
                  index: proveApiModel.proveBetDetail?.index)),
              //阴影处理
              boxShadow: [
                BoxShadow(
                  // color: Colors.black26,
                  // color: Color(0xFFA80000),
                  color: Color(PlinkoGameConfigEnum.shadowsAdaptor(
                      row: proveApiModel.proveBetDetail?.rows,
                      index: proveApiModel.proveBetDetail?.index)),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 4.0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            child: CustomText("${proveApiModel.proveBetDetail?.result ?? ''}x",
                style: ThemeService().textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: AppValues.defaultMargin),
          CasinoDetailDialogItemView(
              model: CasinoDetailItemModel(
                  label: S.current.random_text_803,
                  content: "${proveApiModel.proveBetDetail?.getRiskLabel()}",
                  showAction: false)),
          CasinoDetailDialogItemView(
              model: CasinoDetailItemModel(
                  label: S.current.random_text_805,
                  content: "${proveApiModel.proveBetDetail?.rows ?? ''}",
                  showAction: false)),
        ],
      );
    });
  }

  _bulidView_game_blackjack() {
    return Column(
      children: [
        CustomText(S.current.random_text_806,
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
        Container(
          // height: 20,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: AppValues.padding_2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // color: ThemeService().primaryColor,
            color: ThemeService().colorScheme.tertiary,
          ),
          child: CustomText("10",
              textAlign: TextAlign.center,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w800)),
        ),
        CustomNetWorkImage(
          height: 70,
          fit: BoxFit.fitHeight,
          imageUrl:
              "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
        ),
        CustomText(S.current.random_text_807,
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
        SizedBox(height: AppValues.smallMargin),
        Container(
          // height: 20,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: AppValues.padding_2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // color: ThemeService().primaryColor,
            color: ThemeService().colorScheme.primaryContainer,
          ),
          child: CustomText("21",
              textAlign: TextAlign.center,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                  fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black.withOpacity(0.8))),
        ),
        CustomNetWorkImage(
          height: 70,
          fit: BoxFit.fitHeight,
          imageUrl:
              "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
        ),
        SizedBox(height: AppValues.defaultMargin),
      ],
    );
  }

  _bulidView_game_mines() {
    return Container(
      margin: EdgeInsets.only(bottom: AppValues.defaultMargin),
      child: CustomAssetIcon(
        name: "assets/images/bet_slip/casino/ic_casino_game_mines.webp",
        size: 240,
      ),
    );
  }

  _bulidView_game_dice() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(
          bottom: AppValues.defaultMargin,
          // left: AppValues.defaultMargin,
          // right: AppValues.defaultMargin,
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                    child: const CustomAssetIcon(
                      name: "assets/images/bet_slip/casino/ic_betting_dice_process_bg.webp",
                      width: double.infinity,
                    ),
                  ),
                  //进度条
                  Container(
                    width: double.infinity,
                    // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppValues.defaultMargin * 2,
                      vertical: 15,
                    ),
                    child: Builder(builder: (context) {
                      var left = getDiceProcessFlex(
                        value: proveApiModel.proveBetDetail?.target,
                        // value:"50",
                        defaultValue: 50,
                      );
                      var right = getDiceProcessFlex(
                          value: proveApiModel.proveBetDetail?.target,
                          // value:"50",
                          defaultValue: 50,
                          isLeft: false);
                      return Row(
                        key: globalKeyDiceProcess,
                        children: [
                          Expanded(
                              flex: left,
                              child: Container(
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xffE9103D),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: right,
                              child: Container(
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xff00E700),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                              )),
                        ],
                      );
                    }),
                  ),

                  //蓝色滑块
                  Positioned(
                    bottom: 0,
                    left: getDiceBlockLeftOffset(
                      value: proveApiModel.proveBetDetail?.target,
                      // value: "50",
                      defaultValue: 50,
                      blockSize: 34,
                      margin: AppValues.defaultMargin * 2,
                    ),
                    child: const CustomAssetIcon(
                      name: "assets/images/bet_slip/casino/ic_betting_dice_process_btn.webp",
                      size: 34,
                    ),
                  ),

                  //白色块
                  Positioned(
                    bottom: 18,
                    left: getDiceBlockLeftOffset(
                      value: proveApiModel.proveBetDetail?.result,
                      // value: "100",
                      defaultValue: 50,
                      blockSize: 50,
                      margin: AppValues.defaultMargin * 2,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        const CustomAssetIcon(
                          name: "assets/images/bet_slip/casino/ic_betting_dice_process_block.webp",
                          size: 50,
                        ),
                        CustomText(
                          "${proveApiModel.proveBetDetail?.result ?? ""}",
                          style: ThemeService().textTheme.bodyLarge?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: widget.data.isLoseAmount()
                                  ? const Color(0xffE9103D)
                                  : const Color(0xff00E700)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppValues.margin_32),
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                // color: ThemeService().primaryColor,
                // color: ThemeService().colorScheme.tertiary,
                color: Color(0xFF213743),
              ),
              child: Column(
                children: [
                  SizedBox(height: AppValues.halfMargin),
                  //乘数
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                          label: S.current.random_text_224,
                          content: "${proveApiModel.proveBetDetail?.payoutMultiplier ?? ''}",
                          actionEnum: ContentActionEnum.multiplier)),
                  //掷小于
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                          label: (proveApiModel.proveBetDetail != null &&
                                  proveApiModel.proveBetDetail!.isAbove())
                              ? S.current.random_text_1069
                              : S.current.random_text_808,
                          content: "${proveApiModel.proveBetDetail?.target ?? ''}",
                          actionEnum: ContentActionEnum.loop)),
                  //获胜机率
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                          label: S.current.random_text_809,
                          content: "${proveApiModel.proveBetDetail?.winChance ?? ''}",
                          actionEnum: ContentActionEnum.remainder)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _bulidView_game_crash() {
    return Column(
      children: [
        CustomText("2.02x",
            style: ThemeService()
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
        SizedBox(height: AppValues.margin_14),
        CasinoDetailDialogItemView(
            model: CasinoDetailItemModel(
                label: "", content: "2.00", showLabel: false, showAction: false)),
        SizedBox(height: AppValues.smallMargin),
      ],
    );
  }

  Widget _buildDetailButton(CasinoGameTypeEnum gameType) {
    return CustomButton(
      onTap: () => onClickToGamePage(widget.data),
      padding:
          EdgeInsets.symmetric(horizontal: AppValues.largePadding, vertical: AppValues.padding_10),
      // borderRadius: BorderRadius.circular(4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        // color: ThemeService().primaryColor,
        color: ThemeService().colorScheme.tertiary,
        //阴影处理
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2.0, 2.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      // title: '${S.current.random_text_225}${widget.data?.gameName}',
      backgroundColor: ThemeService().colorScheme.tertiaryContainer,
      // textColor: Colors.white,
      child: CustomText(
          '${S.current.random_text_225}${gameType.isGameCommon() ? widget.data?.gameName : gameType.label}',
          style: ThemeService()
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDetailBottomExpend(CasinoGameTypeEnum gameType) {
    return Container(
      decoration: const BoxDecoration(
        // color: Color(0xFF0F212E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
        // color: ThemeService().colorScheme.background,
        color: Color(0xFF0F212E),
      ),
      margin: const EdgeInsets.only(top: AppValues.defaultMargin),
      child: Theme(
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileTheme.of(context).copyWith(dense: true, minVerticalPadding: 10),
        ),
        child: CustomExpansionTileWidget(
          // tilePadding: EdgeInsets.symmetric(vertical: 0),
          title: CustomText(
            S.current.random_text_810,
            style: ThemeService().textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
          iconColor: Colors.white,
          // onExpansionChanged: (value) => onScrollViewHeight(value),
          // collapsedIconColor:Colors.white,
          // initiallyExpanded: false,
          // maintainState: true,
          //是否是 Crash 小游戏 ， 因为内容不一样
          children: !gameType.isGameCrash()
              ? [
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                    label: S.current.random_text_811,
                    content: S.current.random_text_812,
                    iconColor: Colors.white,
                    showAction: false,
                  )),
                  //服务器种子（散列化）
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                    label: S.current.random_text_813,
                    content: proveApiModel.serverSeedHash ?? "",
                    iconColor: Colors.white,
                  )),
                  //客户端种子
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                    label: S.current.random_text_814,
                    content: proveApiModel.clientSeed ?? "",
                    iconColor: Colors.white,
                  )),
                  //现实标志
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                    label: S.current.random_text_815,
                    content: "${proveApiModel.nonce ?? ""}",
                    iconColor: Colors.white,
                  )),
                  const SizedBox(height: AppValues.margin_2),
                  CustomText(
                    S.current.random_text_816,
                    style: ThemeService().textTheme.labelMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppValues.margin_4),
                  CustomText(
                    S.current.random_text_817,
                    style: ThemeService().textTheme.labelMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppValues.margin_12),
                ]
              : [
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                    label: S.current.random_text_818,
                    content: "${proveApiModel.serverSeedHash ?? ""}",
                    iconColor: Colors.white,
                  )),
                  CasinoDetailDialogItemView(
                      model: CasinoDetailItemModel(
                    label: S.current.random_text_819,
                    content: "${proveApiModel.clientSeed ?? ""}",
                    iconColor: Colors.white,
                  )),
                  const SizedBox(height: AppValues.margin_4),
                  CustomText(
                    S.current.random_text_820,
                    style: ThemeService().textTheme.labelMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppValues.margin_12),
                ],
        ),
      ),
    );
  }
}
