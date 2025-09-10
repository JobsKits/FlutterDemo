import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_detail_view.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/app_manager.dart';
import '../../../../utils/common_color.dart';

///充值页面的带*的富文本组件
// ignore: must_be_immutable
class RechargeRichTitleWidget extends StatefulWidget {
  RechargeRichTitleWidget(
      {super.key,
      required this.fontSize,
      required this.str,
      this.required = true,
      this.child,
      this.changeStyle,
      this.changeIsShowPwd,
      this.isShowPwd,
      this.isShowChangeStyleBtn = false});
  final double fontSize;
  final String str;
  late bool? required;
  late Widget? child;
  ValueChanged<bool>? changeStyle;
  ValueChanged<bool>? changeIsShowPwd;
  final bool? isShowChangeStyleBtn;
  final bool? isShowPwd;
  @override
  State<RechargeRichTitleWidget> createState() =>
      _RechargeRichTitleWidgetState();
}

class _RechargeRichTitleWidgetState extends State<RechargeRichTitleWidget> {
  bool isOldStyle = false;
  bool isShowPwd = false;
  @override
  void initState() {
    super.initState();
    isShowPwd = widget.isShowPwd ?? false;
  }

  //新的支付密码style
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                  text: widget.required == true ? "* " : "",
                  style:
                      TextStyle(fontSize: widget.fontSize, color: Colors.red),
                  children: [
                    TextSpan(
                        text: widget.str,
                        style: TextStyle(color: context.customTheme?.titleColor))
                  ]),
            ),
            widget.child ?? const SizedBox(),
          ],
        ),
        if (widget.isShowChangeStyleBtn == true && !isOldStyle)
          InkWell(
            onTap: () {
              AppManager.instance.tapVibrate();
              setState(() {
                isShowPwd = !isShowPwd;
              });
              widget.changeIsShowPwd?.call(isShowPwd);
            },
            child: SvgPicture.asset(
              isShowPwd
                  ? Assets.theme1.images.login.iconInputEyeClose
                  : Assets.theme1.images.login.iconInputEyeOpen,
              width: 50.w,
              height: 50.h,
            ),
          )
      ],
    );
  }
}
