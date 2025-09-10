import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/dialog/dialog_utils.dart';

class CustomPasswordTips extends StatelessWidget {
  CustomPasswordTips({Key? key, required this.onPwdTypeSelected, this.style}) : super(key: key);
  final Function(dynamic selectedPwdType) onPwdTypeSelected;
  final TextStyle? style;
  final GlobalStateController _globalStateController = Get.find<GlobalStateController>();

  final GlobalKey _globalKey = GlobalKey();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation() {
    _rotatingArrowKey.currentState?.startAnimation();
  }

  final selectPwdTypeBean = {}.obs;
  final pwdTypeList = [].obs;

  @override
  Widget build(BuildContext context) {
    pwdTypeList.assignAll(_getPwdType());
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return InkWell(
      onTap: () {
        if (pwdTypeList.length == 1) {
          return;
        }
        _startAnimation();
        DialogUtils.showCustomBubbleDialog(
            context, contentView(), _globalStateController.isChinese() ? 94 : 120,
            widgetKey: _globalKey,
            backgroundColor: AppThemes.textColorWhite,
            globalKey: _rotatingArrowKey,
            bubbleArrowWidth: 12,
            bubbleArrowHeight: 8);
      },
      child: SizedBox(
        key: _globalKey,
        height: AppValues.defaultTextHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //{"status":true,"data":{"auth_secret":"","is_secret":"0","is_pay_password":"1"}}
            Obx(() {
              return CustomText(
                "${selectPwdTypeBean.value['typeName']}",
                style: style ?? const TextTheme().bodyMedium,
              );
            }),
            Visibility(
              visible: pwdTypeList.length != 1,
              child: RotatingArrow(
                key: _rotatingArrowKey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  contentView() {
    return Column(
      children: pwdTypeList.map((item) {
        return _pwdWidget(item);
      }).toList(),
    );
  }

  Widget _pwdWidget(dynamic bean) {
    return GestureDetector(
      onTap: () {
        Get.back();
        for (var item in pwdTypeList) {
          item['select'] = false;
        }
        bean['select'] = !bean['select'];
        pwdTypeList.refresh();
        selectPwdTypeBean.value = bean;
        onPwdTypeSelected(selectPwdTypeBean);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        alignment: Alignment.center,
        child: CustomText(bean['typeName'],
            textColorStyle:
                bean['select'] ? CustomTextColorStyle.primary : CustomTextColorStyle.dark,
            style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  List<dynamic> _getPwdType() {
    var type = [];
    int check = _globalStateController.getVerifyType();
    //验证方式 1:二阶段验证 2:资金密码
    String isSecret = _globalStateController.brandBase['is_secret'] ?? ''; //1:已配置 0:未配置
    //验证方式 1:二阶段验证 2:资金密码
    String isPayPassword = _globalStateController.brandBase['is_pay_password'] ?? ''; //1:已配置 0:未配置
    if (check == 3) {
      if (isSecret == '1' && isPayPassword == '1') {
        type = [
          {
            'select': true,
            'typeName': S.current.wallet_fundPassword,
            "authType": "2",
            'title': S.current.wallet_fundPasswordcopy2
          },
          {
            'select': false,
            'typeName': S.current.s_2fa_body_code_text,
            "authType": "1",
            'title': S.current.s_2fa_body_code_text1
          }
        ];
      } else if (isSecret == '1') {
        type = [
          {
            'select': true,
            'typeName': S.current.s_2fa_body_code_text,
            "authType": "1",
            'title': S.current.s_2fa_body_code_text1
          }
        ];
      } else if (isPayPassword == '1') {
        type = [
          {
            'select': true,
            'typeName': S.current.wallet_fundPassword,
            "authType": "2",
            'title': S.current.wallet_fundPasswordcopy2
          }
        ];
      }
    } else if (check == 2) {
      //后端只开启资金密码
      type = [
        {
          'select': true,
          'typeName': S.current.wallet_fundPassword,
          "authType": "2",
          'title': S.current.wallet_fundPasswordcopy2
        }
      ];
    } else if (check == 1) {
      //后端只开启双重验证
      type = [
        {
          'select': true,
          'typeName': S.current.s_2fa_body_code_text,
          "authType": "1",
          'title': S.current.s_2fa_body_code_text1
        }
      ];
    }

    for (var item in type) {
      if (item['select']) {
        selectPwdTypeBean.value = item;
        break;
      }
    }
    //确保在下一帧才会执行，从而避免了 "setState() or markNeedsBuild() called during build" 错误
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onPwdTypeSelected(selectPwdTypeBean);
    });
    return type;
  }
}
