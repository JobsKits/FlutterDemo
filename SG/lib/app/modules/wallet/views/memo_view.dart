import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:flutter_bet/widget/custom_tips*_text.dart.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class MemoView extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _flagAndMemos();
    });
  }

  Widget _flagAndMemos() {
    return Visibility(
      visible: controller.getMergerSelId(controller.wdFiatCurrTabSel.value) == controller.xrp ||
          controller.getMergerSelId(controller.wdFiatCurrTabSel.value) == controller.eos,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          controller.getMergerSelId(controller.wdFiatCurrTabSel.value) == controller.xrp
              ? const CustomAsterisksTipsText(text: "标签")
              : CustomText(
                  S.current.random_text_661,
                  textColorStyle: CustomTextColorStyle.normal,
                ),
          const SizedBox(
            height: 4,
          ),
          CustomMainTextField(
            text: controller.memo.value,
            showError: controller.memoShowEr.value,
            errorText: controller.memoShowErrStr.value,
            inputCallBack: (str) {
              controller.memo.value = str;
              if (controller.getMergerSelId(controller.wdFiatCurrTabSel.value) == controller.xrp) {
                controller.checkMemo(isInput: true);
              }
            },
          ),
        ],
      ),
    );
  }
}
