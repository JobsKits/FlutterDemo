import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/select_coin_controller.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/dialog_utils.dart';

class CustomSelectCoinWidget extends GetView<SelectCoinController> {
  final GlobalKey globalKeyS;
  final GlobalKey globalKeyWidget;
  final double ratio;
  final double bubbleWidth;
  List<CurrencyBean> dataList;
  final String? hintSearchTextual;
  final Color? bgColor;
  final bool? isHeight;

  ///是否知道高度
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  final double? positionedRight;

  final double? arrowBasisOffset;

  Widget Function(BuildContext context, CurrencyBean bean) contentBuilder;
  Widget Function(BuildContext context, CurrencyBean bean) itemBuilder;

  CustomSelectCoinWidget(
      {super.key,
      required this.globalKeyS,
      required this.globalKeyWidget,
      required this.ratio,
      required this.bubbleWidth,
      required this.contentBuilder,
      required this.itemBuilder,
      required this.dataList,
      this.hintSearchTextual,
      this.arrowBasisOffset,
      this.positionedRight,
      this.bgColor,
      this.isHeight});

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  //用来保存本地初始化数据
  final currTypeInitialLists = <CurrencyBean>[];

  //选中的的item model -- 存款的
  final currTypeSelected = CurrencyBean().obs;

  final scale = 1.0.obs;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<SelectCoinController>(
      () => SelectCoinController(),
    );
    // Future.microtask(() {
    //   currTypeInitialLists.assignAll(dataList);
    //   controller.coinList.assignAll(dataList);
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currTypeInitialLists.assignAll(dataList);
      controller.coinList.assignAll(dataList);
      log("neco  得到的${controller.coinList.toJson()}  --- ${dataList.length}");
    });

    return _currencyWidget(globalKeyS, context);
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _currencyWidget(GlobalKey globalKeyS, BuildContext context) {
    double height =
        controller.coinList.length >= 10 ? 0 : 0; //https://jira.vgtech.org/browse/STAK-12644
    return InkWell(
      onTap: () async {
        _onClick(context, height);
      },
      child: Row(
        key: globalKeyWidget,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding:
                  const EdgeInsets.only(top: AppValues.padding_10, bottom: AppValues.padding_10),
              decoration: BoxDecoration(
                  color: bgColor ?? ThemeService().colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Row(
                children: [
                  Obx(() {
                    return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn, // 使用弹性曲线
                        transform: Matrix4.identity()..scale(scale.value),
                        child: contentBuilder(context, currTypeSelected.value));
                  }),
                  const SizedBox(
                    width: 6,
                  ),
                  RotatingArrow(
                    key: _rotatingArrowKey,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  _onClick(BuildContext context, double height) async {
    // 使用MediaQuery获取屏幕信息
    MediaQueryData mediaQuery = MediaQuery.of(Get.context!);
    // 获取底部的ViewInsets，如果软键盘弹起，bottom会大于0
    double bottomInset = mediaQuery.viewInsets.bottom;
    if (bottomInset > 0) {
      hideKeyboard(Get.context!);
      // await Future.delayed(const Duration(milliseconds: 300));
    }
    // scale.value = 0.9;
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   scale.value = 1.0;
    // });
    _startAnimation(_rotatingArrowKey);
    resetSearchList();
    DialogUtils.showCustomBubbleDialog(
      positionedRight: positionedRight,
      arrowBasisOffset: arrowBasisOffset ?? 0,
      context,
      _selectCoinsTypeNew(context),
      bubbleWidth,
      height: height,
      widgetKey: globalKeyWidget,
      // backgroundColor: ThemeService().colorScheme.tertiary,
      backgroundColor: AppThemes.widgetColorWhite,
      globalKey: _rotatingArrowKey,
      // onDismissCallback: () {
      //   scale.value = 0.9;
      //   Future.delayed(const Duration(milliseconds: 100), () {
      //     scale.value = 1.0;
      //   });
      // }
    );
  }

  Widget _selectCoinsType(BuildContext context) {
    return Obx(() {
      return Container(
        constraints: BoxConstraints(maxHeight: _getWalletHeight()),
        child: RawScrollbar(
          thumbVisibility: false,
          padding: EdgeInsets.zero,
          minOverscrollLength: 40,
          minThumbLength: 40,
          thumbColor: AppThemes.textColorSecondary,
          controller: _scrollController,
          radius: const Radius.circular(6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildCoinsSearchView(),
                ...controller.coinList.map((coin) {
                  return itemBuilder(context, coin);
                }).toList(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _selectCoinsTypeNew(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          _buildCoinsSearchView(),
          controller.coinList.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(bottom: AppValues.margin_12),
                  child: CustomText(
                    S.current.random_text_822,
                    textColorStyle: CustomTextColorStyle.dark,
                  ))
              : Container(
                  constraints: BoxConstraints(maxHeight: _getWalletHeight()),
                  child: RawScrollbar(
                    padding: EdgeInsets.zero,
                    minOverscrollLength: 40,
                    minThumbLength: 40,
                    thumbColor: AppThemes.textColorSecondary,
                    controller: _scrollController,
                    radius: const Radius.circular(6),
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: controller.coinList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return itemBuilder(context, controller.coinList[index]);
                        }),
                  ),
                ),
        ],
      );
    });
  }

  ///显示搜索框
  _buildCoinsSearchView() {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_10, vertical: 8),
      child: CupertinoSearchTextField(
        prefixInsets: const EdgeInsets.only(left: 10, top: 4),
        prefixIcon: const CustomAssetIcon(
          name: "assets/images/top_search_ic.png",
          size: 14,
        ),
        itemColor: AppThemes.secondaryIconColor,
        placeholder: hintSearchTextual ?? S.current.wallet_search,
        placeholderStyle:
            const TextStyle(color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        decoration: BoxDecoration(
          color: AppThemes.widgetColorWhite,
          border: Border.all(color: AppThemes.whiteD5DCEB, width: 2.0),
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
          log('The text has changed to: $value');
          updateSearchList(value);
        },
        onSubmitted: (String value) {
          log('Submitted text: $value');
        },
      ),
    );
  }

  double _getWalletHeight({double height = 280}) {
    //https://jira.vgtech.org/browse/STAK-12693
    double? totalHeight;
    // if (dataList.length < 10) {
    //   totalHeight = dataList.length * 32.0 + 38 + 12;
    //   return totalHeight;
    // }
    return height;
  }

  ///币种 选择框 内部搜索
  void updateSearchList(String value) {
    debugPrint('$value');
    if (value.isNotEmpty) {
      var tempList = currTypeInitialLists
          .where((element) => element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      controller.coinList.assignAll(tempList);
    } else {
      // _controller.text = '';
      // _filteredUsers = users;
      controller.coinList.assignAll(currTypeInitialLists);
    }
  }

  ///当关闭窗口或者 打开时，还原原来的数据源
  void resetSearchList() {
    controller.coinList.assignAll(currTypeInitialLists);
  }

  ///临时保存选中的币种
  void saveSelected(CurrencyBean bean) {
    currTypeSelected.value = bean;
  }

  ///判断是否是选中的币种 item
  bool isSelectedItem(CurrencyBean bean) {
    return bean == currTypeSelected.value;
  }
}
