import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/widget/custom_keyboard_actions_widget.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'logic.dart';

class TestKeyboardPage extends BaseView<TestKeyboardLogic> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focus2Node = FocusNode();

  TestKeyboardPage({super.key});
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return null;
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return CustomKeyBoardActionsWidget(
      focusNodes: [_focusNode,_focus2Node],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomMainTextField(focusNode: _focusNode,),
          const SizedBox(height: AppValues.defaultPadding,),
          CustomMainTextField(focusNode: _focus2Node),
          const SizedBox(height: 100,),
        ],
      ),
    );
  }

}
