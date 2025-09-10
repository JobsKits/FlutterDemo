import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

class BubbleCoinList extends StatelessWidget {
  BubbleCoinList(
      {super.key,
      required this.coinList,
      this.callback,
      this.textColor = Colors.white,
      this.fontWeight = FontWeight.w400});

  final List<CurrencyBean> coinList;
  final Function(int)? callback;
  Color textColor;
  FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return _viewBubbleChild();
  }

  // 弹窗出来的币种选择
  _viewBubbleChild() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: coinList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.back();
                callback?.call(index);
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  CustomNetWorkImage(
                    imageUrl:
                        "${AppValues.defaultBranch.asset_url}/currency/${coinList[index].cur}.webp",
                    width: AppValues.iconSmallSize,
                    height: AppValues.iconSmallSize,
                  ),
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  CustomText(coinList[index].name ?? "",
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: fontWeight, color: textColor)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
