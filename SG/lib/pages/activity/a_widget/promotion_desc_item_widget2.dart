import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';

///推广界面 推广条件 说明 item
class PromotionDescItemWidget2 extends StatelessWidget {
  const PromotionDescItemWidget2({
    super.key,
    required this.title,
    required this.needReplace,
    required this.highestMoney,
    required this.coinImageUrl,
    this.titleStyle,
  });

  final String title;
  final bool needReplace; //是否需要替换
  final String highestMoney;
  final String coinImageUrl;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    List<String> result = filterCoinFlag(title, needReplace);
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.margin_12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                color: ThemeService().textTheme.labelMedium?.color,
                borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(width: AppValues.margin_10),
          Expanded(
            child: result.length <= 1
                ? CustomText(
                    result.first.trim(),
                    // "史蒂夫拉开将大幅拉升空间杜鹃花科扫黄大煞风景卡话费卡上",
                    style: titleStyle ??
                        ThemeService()
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  )
                : RichText(
                    softWrap: true,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: result.first.trim() + highestMoney,
                          style: titleStyle ??
                              ThemeService()
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: CustomNetWorkImage(
                              width: 13,
                              height: 13,
                              imageUrl: coinImageUrl,
                              showErrorMsg: false,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: result.last,
                          style: titleStyle ??
                              ThemeService()
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 提取 分割 CNY$$currency$$  替换成 货币符号
  /// 没有list 只有一个数据， 有的话 是2个数据
  List<String> filterCoinFlag(String title, bool needReplace) {
    if (needReplace) {
      //金额最高0CNY
      // List<String> tempList =  title.trim().split('CNY\$\$currency\$\$').toList();
      final re = RegExp(r'\d+\s?[A-Za-z]{1,7}\$+\$currency\$\$');
      List<String> tempList = title.trim().split(re).toList();
      return tempList;
    } else {
      return <String>[title];
    }
  }
}
