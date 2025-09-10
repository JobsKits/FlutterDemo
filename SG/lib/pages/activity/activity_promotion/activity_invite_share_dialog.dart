import 'package:flutter_bet/widget/dialog/custom_dialog_base_view.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../widget/custom_toast.dart';
import '../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../widget/share/custom_share_widget_list.dart';
import '../a_widget/activity_copy_link_widget.dart';

///推广活动  进度条模式， 的分享弹窗
class ActivityInviteShareDialog extends CustomDialogBaseView {
  ActivityInviteShareDialog({
    super.key,
    super.dialogMaxHeight,
    this.copyFullLink,
    this.shareFullLink,

  });

  final String? copyFullLink; //复制链接
  final String? shareFullLink; //分享链接

  ///打开对话框
  static void openDialog({String? copyFullLink, String? shareFullLink}) {
    CustomDialogBaseView.showDetailDialog(
        context: Get.overlayContext!,
        dialogView: ActivityInviteShareDialog(
          // dialogMaxHeight: Get.height - 100,
          copyFullLink: copyFullLink,
          shareFullLink: shareFullLink,
        ));
  }

  // @override
  // String buildTitleAsset() {
  //   return "assets/images/activity/ic_activity_invite.webp";
  // }

  @override
  String buildTitleLabel() {
    return S.current.random_text_1177;
  }

  @override
  List<Widget> buildContentView() {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        child: CustomShareListWidget(
          shareLinkValue: shareFullLink,
          onClickShare: (model) {
            onCloseDialog();
          },
        ),
      ),
      const SizedBox(height: AppValues.defaultMargin),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        child: ActivityCopyLinkWidget(
          fullLink: copyFullLink,
          onTapCopy: () {
            Clipboard.setData(ClipboardData(text: copyFullLink));
            CustomToast.show(S.current.random_text_151, Get.overlayContext!);
          },
        ),
      ),
      const SizedBox(height: AppValues.defaultMargin),
    ];
  }
}
