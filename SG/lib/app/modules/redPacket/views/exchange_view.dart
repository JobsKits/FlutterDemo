import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../utils/lang_util.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../../widget/share/custom_share_widget_item.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../rotary/controllers/rotary_controller.dart';
import '../controllers/exchange_controller.dart';
import '../controllers/red_packet_controller.dart';

const kCustomExchangeViewWidget = 'ExchangeView';

class ExchangeView extends StatefulWidget {
  final double amount;
  final TypeEvent typeEvent;

  const ExchangeView({super.key, required this.amount, required this.typeEvent});

  @override
  State<StatefulWidget> createState() {
    return _ExchangeState();
  }
}

class _ExchangeState extends State<ExchangeView> with SingleTickerProviderStateMixin {
  late RedPacketController controller = Get.find<RedPacketController>();
  late RotaryController rotaryController = Get.find<RotaryController>();
  final GlobalKey<RotatingArrowState> _rotatingArrowExchangeKey = GlobalKey<RotatingArrowState>();
  final GlobalKey _globalExchangeKey = GlobalKey();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  void initState() {
    Get.lazyPut(()=>RedPacketController());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.exchangeCurrFun(controller.globalController.currTypeSelected.value, widget.amount);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: ThemeService().colorScheme.background,
        ),
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomAssetIcon(
                    name: "assets/images/red_packet/bonus.png",
                    width: 16,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomText(S.current.feedback_receive_title),
                  const Spacer(),
                  InkWell(
                    onTap: () => RouteUtil.popView(),
                    child: const CustomAssetIcon(
                      name: 'assets/images/ic_closed.png',
                      color: AppThemes.textColorSecondary,
                      size: 18,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              CustomText(
                S.current.random_text_635,
                style: TextStyle(color: AppThemes.onTertiaryColor),
              ),
              const SizedBox(
                height: 2,
              ),
              _bonusWidget(),
              const SizedBox(
                height: 14,
              ),
              Row(
                children: [
                  Obx(() {
                    return CustomText("${S.current.random_text_650}${LangUtil().isPtBr()?'(${controller.exChangeCurrencyBean.value.name})':controller.exChangeCurrencyBean.value.name}",
                        style: const TextStyle(color: AppThemes.onTertiaryColor));
                  }),
                  const Spacer(),
                  CustomText(S.current.random_text_652 + " ",
                      textColorStyle: CustomTextColorStyle.normal),
                  Obx(() {
                    return CustomText(controller.formatBalance(controller.exchangeRate.value),
                        textColorStyle: CustomTextColorStyle.normal);
                  })
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              _exchangeWidget(context),
              const SizedBox(
                height: 22,
              ),
              CustomBigMainButton(
                fontWeight: FontWeight.w600,
                onTap: (btn) {
                  if(widget.typeEvent == TypeEvent.redPacket){
                    controller.redPacketExchange(context);
                    return;
                  }
                  if(widget.typeEvent == TypeEvent.luckWheel){
                    rotaryController.apply();
                    return;
                  }
                },
                colorStyle: CustomButtonColorStyle.tertiary,
                title: S.current.random_text_998,
              ),
              const SizedBox(
                height: 14,
              ),
              CustomText(
                S.current.random_text_703,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppThemes.onTertiaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bonusWidget() {
    return Stack(
      children: [
        CustomMainTextField(
          textColor: const Color(0xff919BA2),
          enabled: false,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          text: "${widget.amount}",
          inputCallBack: (str) {},
          isCursorEnd: false,
        ),
        Positioned(
            right: 0,
            child: InkWell(
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xFF283E4B),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomAssetIcon(
                      name: 'assets/images/coin_icon/ic_eth.png',
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText("USDT",
                        style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600, color: const Color(0xff919BA2))),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget _exchangeWidget(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          return CustomMainTextField(
            textColor: const Color(0xff919BA2),
            showError: false,
            errorText: "",
            enabled: false,
            text: controller.exChangeCurrencyText.value,
            controller: controller.exChangeCurrencyTextController,
            isCursorEnd: false,
          );
        }),
        Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () {
                controller.resetSearchList();
                _startAnimation(_rotatingArrowExchangeKey);
                DialogUtils.showCustomBubbleDialog(
                  context,
                  _selectCoinsType(context),
                  LangUtil().isEnIn() || LangUtil().isPtBr() ? 120 : 100,
                  widgetKey: _globalExchangeKey,
                  backgroundColor: AppThemes.textColorWhite,
                  globalKey: _rotatingArrowExchangeKey,
                  bubbleArrowWidth: 12,
                  bubbleArrowHeight: 8,
                );
              },
              child: Container(
                key: _globalExchangeKey,
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ThemeService().colorScheme.tertiaryContainer,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return CustomNetWorkImage(
                        placeholder: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                        ),
                        errorWidget: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                        ),
                        imageUrl: controller.exChangeCurrencyBean.value.coinIc ?? "",
                        width: 18,
                        height: 18,
                      );
                    }),
                    const SizedBox(
                      width: 4,
                    ),
                    Obx(() {
                      return CustomText(controller.exChangeCurrencyBean.value.name ?? "",
                          style: ThemeService()
                              .theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600));
                    }),
                    RotatingArrow(
                      key: _rotatingArrowExchangeKey,
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  _buildSearchView() {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_10),
      child: CupertinoSearchTextField(
        prefixInsets: const EdgeInsets.only(left: 10),
        prefixIcon: const CustomAssetIcon(
          name: "assets/images/top_search_ic.png",
          size: 16,
        ),
        itemColor: AppThemes.secondaryIconColor,
        placeholder: S.current.wallet_search,
        // placeholderStyle: const TextStyle(color: AppThemes.white566771, fontWeight: FontWeight.w500),
        placeholderStyle:
            const TextStyle(color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        decoration: BoxDecoration(
          color: AppThemes.widgetColorWhite,
          border: Border.all(color: AppThemes.whiteD5DCEB, width: 2.0),
          // Add a border
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // 阴影颜色
              spreadRadius: 0, // 扩散半径
              blurRadius: 2, // 模糊半径
              offset: const Offset(0, 1), // 阴影偏移量
            ),
          ],
        ),
        style: const TextStyle(
            fontSize: 14, color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        onChanged: (String value) {
          controller.updateSearchAllAmountList(value);
        },
        onSubmitted: (String value) {
          log('Submitted text: $value');
        },
      ),
    );
  }

  Widget _selectCoinsType(BuildContext context) {
    if (controller.globalController.currTypeLists.isEmpty) {
      controller.globalController.syncData();
    }
    return Column(
      children: [
        const SizedBox(height: AppValues.margin_10),
        // _buildSearchView(),
        // const SizedBox(height: AppValues.margin_12),
        Obx(() {
          return (controller.searchAllAmountList.length) > 10
              ? Container(
                  color: AppThemes.widgetColorWhite,
                  height: 200,
                  child: RawScrollbar(
                    thumbVisibility: false,
                    padding: EdgeInsets.zero,
                    minOverscrollLength: 40,
                    minThumbLength: 40,
                    thumbColor: AppThemes.textColorSecondary,
                    controller: controller.exchangeCurrscrollController,
                    radius: const Radius.circular(6),
                    child: ListView.builder(
                        controller: controller.exchangeCurrscrollController,
                        padding: EdgeInsets.zero,
                        itemCount: controller.searchAllAmountList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _coinItem(index, controller.searchAllAmountList);
                        }),
                  ),
                )
              : _selectCoinsTypeNoBar(context);
        })
      ],
    );
  }

  Widget _selectCoinsTypeNoBar(BuildContext context) {
    return Obx(() {
      return Container(
        constraints: const BoxConstraints(maxHeight: 318),
        child: RawScrollbar(
          thumbVisibility: false,
          padding: EdgeInsets.zero,
          minOverscrollLength: 40,
          minThumbLength: 40,
          thumbColor: AppThemes.textColorSecondary,
          controller: controller.exchangeCurrscrollController,
          radius: const Radius.circular(6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...controller.searchAllAmountList.asMap().entries.map((entry) {
                  int index = entry.key;
                  return _coinItem(index, controller.searchAllAmountList);
                }).toList(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _coinItem(int index, List<CurrencyBean> list) {
    bool isSelected = controller.isExchangeSelectedItem(list[index]);

    return CupertinoButton(
      minSize: 32.0,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.back();
        if (isSelected) {
          return;
        }
        CurrencyBean currencyBean = list[index];
        controller.exchangeCurrFun(currencyBean, widget.amount);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12),
              alignment: Alignment.center,
              width: 80,
              child: Row(
                children: [
                  CustomNetWorkImage(
                    imageUrl: list[index].coinIc ?? "",
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    list[index].name ?? " ",
                    style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? ThemeService().colorScheme.primary : AppThemes.black,
                        // color:AppThemes.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showCustomExchangeWidget<T>({
  required BuildContext context,
  required double amount,
  required TypeEvent typeEvent,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomExchangeViewWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            ExchangeView(
              amount: amount, typeEvent: typeEvent,
            ),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
