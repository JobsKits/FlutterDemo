import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/test/dialog/test_dialog_controller.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';

class TestDialog extends BaseView<TestDialogController> {
  

  @override
  // TODO: implement controller
  TestDialogController get controller => Get.put(TestDialogController());
  
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return null;
  }

  @override
  Color scaffoldBackgroundColor() {
    // TODO: implement scaffoldBackgroundColor
    return Colors.transparent;
  }

  // @override
  // Size pageSize() {
  //   // TODO: implement pageSize
  //   return const Size(200, 200);
  // }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return GestureDetector(
      onTap: (){
        controller.showEmptyPage();
      },
      child: Center(
        child: SizedBox(
            width: 200,
            height: 200,
            child: Container(
              color: Colors.red,
            )),
      ),
    );
  }
}


Future<void> showCustomTestDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return TestDialog();
      });
}