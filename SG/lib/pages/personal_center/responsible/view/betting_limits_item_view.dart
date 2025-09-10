import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../model/betting_item_state.dart';
import 'betting_limits_item_edit_view.dart';
import 'betting_limits_item_show_view.dart';

class BettingLimitsItemView extends StatelessWidget {
  BettingItemState state;

  BettingLimitsItemView({super.key, required this.state});

  final isEditShow = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Offstage(
            offstage: !isEditShow.value,
            child: BettingLimitsItemEditView(
              state: state,
              onClickCancel: () => onCancel(),
              onClickSave: (state) {
                onSave(context,state);
              },
            ),
          ),
          Offstage(
            offstage: isEditShow.value,
            child: BettingLimitsItemShowView(state: state, onClickEdit: () => onEdit()),
          ),
        ],
      );
    });
  }

  onEdit() {
    isEditShow.value = true;
  }

  onCancel() {
    isEditShow.value = false;
  }

  onSave(BuildContext context,BettingItemState newState) {
    isEditShow.value = false;
    state = newState;
    log("newState..."+newState.toString());
    log("state..."+state.toString());
    CustomSnackBar.show(
        title:S.current.random_text_373, S.current.random_text_374, context,
        preIcon: CustomSnackBarIcons.responsible);
  }
}
