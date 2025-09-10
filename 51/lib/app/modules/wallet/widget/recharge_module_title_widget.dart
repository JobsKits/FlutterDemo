import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_rich_title_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_tutorials_text_widget.dart';

//充值页面里面小模块的标题组件
class RechargeModuleTitleWidget extends StatelessWidget {
  const RechargeModuleTitleWidget(
      {super.key, required this.str, required this.fontSize});
  final String str;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RechargeRichTitleWidget(str: str, fontSize: fontSize),
        RechargeTutorialsTextWidget()
      ],
    );
  }
}
