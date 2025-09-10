import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/widget/custom_password_tip.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class PassWordView extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return _pwWidget(isAuthView: true);
  }

  Widget _pwWidget({bool isAuthView = false}) {
    return Visibility(
        visible: isAuthView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return CustomAsterisksTipsText(
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      text:
                          controller.pwTypeBean.isNotEmpty ? controller.pwTypeBean['typeName'] : "")
                  .marginOnly(top: AppValues.defaultMargin);
            }),
            const SizedBox(
              height: AppValues.margin_4,
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Obx(() {
                        return CustomMainTextField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration:
                              controller.getBoxDecoration(showErr: controller.inPwShowErr.value),

                          hintText: controller.pwTypeBean.isNotEmpty
                              ? controller.pwTypeBean['typeName']
                              : "",
                          isUpdatePsdOffset: true,
                          showError: controller.inPwShowErr.value,
                          // errorText: controller.inPwShowErrStr.value,
                          maxLength: 6,
                          isPwd: true,
                          text: controller.inPwd.value,
                          inputCallBack: (str) {
                            controller.inPwd.value = str;
                            controller.checkInputPassWord();
                          },
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: AppValues.defaultTextHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ThemeService().colorScheme.tertiaryContainer,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                  child: CustomPasswordTips(
                    onPwdTypeSelected: (selectedPwdType) {
                      controller.pwTypeBean.value = selectedPwdType;
                      controller.inPwShowErrStr.value = S.current.binding_bank_card_please_enter +
                          "${controller.pwTypeBean["title"]}";
                    },
                  ),
                )
              ],
            ),
            Obx(() =>
                controller.errView(controller.inPwShowErr.value, controller.inPwShowErrStr.value))
          ],
        ));
  }
}
