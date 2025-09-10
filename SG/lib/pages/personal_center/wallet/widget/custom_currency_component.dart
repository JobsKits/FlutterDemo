import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../services/theme/theme_service.dart';

class CustomCurrencyComponent extends StatelessWidget {

  CustomCurrencyComponent({super.key,
    required this.dataList,
    required this.itemBuilder,
  });

  List<CurrencyBean> dataList;
  Widget Function(BuildContext context, CurrencyBean bean) itemBuilder;

  final showAllCoin = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(
        left: AppValues.defaultMargin, right: AppValues.defaultMargin),
        child: _body(context)
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultMargin,),
        Row(
          children:  [
            CustomText(S.current.random_text_664),
            const Spacer(),
            CustomText(S.current.random_text_665, textColorStyle: CustomTextColorStyle.normal,),
            CustomText("${dataList[0].amount}\$", style: const TextStyle(color: CupertinoColors.activeGreen),)
          ],
        ),
        const SizedBox(height: AppValues.margin_8,),
        Container(
            decoration: BoxDecoration(
              color: ThemeService().colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: _selectCoinsType(context)),
      ],
    );
  }

  Widget _selectCoinsType(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 61.0),
        itemCount: !showAllCoin.value ? (dataList.length > 4) ? 8 : (dataList.length) : dataList.length,
        itemBuilder: (context, index) {
            if (index == (dataList.length > 4 ? (!showAllCoin.value? 8 - 1: dataList.length - 1) : dataList.length - 1) && dataList.length > 4){
              return _moreView();
          } else {
            return itemBuilder(context, dataList[index]);
          }
        },
      );
    });
  }

  Widget _moreView() {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 8, right: 8),
      onPressed: () {
        showAllCoin.value = !showAllCoin.value;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomAssetIcon(name: "assets/images/coin_icon/more_ic.png",
            size: 18,
          ),
          const SizedBox(
            height: 4,
          ),
          Obx(() {
            return CustomText(
              showAllCoin.value == false ? S.current.random_text_153 : S.current.random_text_666,
              style:
              ThemeService().theme.textTheme.bodyMedium?.copyWith(),
            );
          }),
        ],
      ),
    );
  }

}