import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/viplevel/vip_fanshui_detail_list.dart';
import 'package:flutter_bet/model/viplevel/vip_fanshui_sum.dart';
import 'package:flutter_bet/model/viplevel/viplevel_lingqu_model.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/pages/personal_center/vip/widgets/vip_FanshuiListDetails_view.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/vip_api_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

const kCustomVipFanshuiDetailWidget = 'kCustomVipFanshuiDetailWidget';

class VipLingQuFanshuiLogic extends BaseController {
  List<VipFanshuiSumModel> sumDataList = [];

  List<VipFanshuiDetailListModel> detailsList = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFanshuiSum();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  // 获取返水列表
  getFanshuiSum() {
    ApiService.instance.getVipRebateSum(success: (data) {
      sumDataList.clear();
      sumDataList.addAll(data);
      update(["vip_fanshui_sum"]);
    }, fail: (fail) {
      print(fail);
    });
  }

  // 获取返水类型
  String getCategory(key) {
    Map titel = {
      "3": S.current.yulecheng_slot,
      "2": S.current.random_text_84,
      // S.current.random_text_85,
      "1": S.current.game_live,
      "4": S.current.tab_bar_sports,
      "8": S.current.random_text_891
    };
    return titel[key];
  }

  // 获取返水列表
  getFanshuiDetailsList(context, VipFanshuiSumModel model) {
    ApiService.instance.getVipRebateDetailsList(
        gameType: model.gameType,
        cur: model.currencyId,
        success: (success) {
          detailsList.clear();
          detailsList.addAll(success.content);
          showCustomVipFanshuiDetailViewWidget(context: context, detailsList: detailsList);
        },
        fail: (fail) {});
  }

// 获取返水列表
  receiveFanshui(context) {
    ApiService.instance.receiveFanshui(success: (success) {
      CustomSnackBar.show(
        success,
        context,
        title: S.current.random_text_977,
        preIcon: CustomSnackBarIcons.commissionSuccess,
      );
    }, fail: (fail) {
      CustomSnackBar.show(S.current.random_text_978, context,
          title: S.current.random_text_695, preIcon: CustomSnackBarIcons.error);
    });
  }

// 弹窗显示返水详情
  Future<void> showCustomVipFanshuiDetailViewWidget({
    required BuildContext context,
    required List<VipFanshuiDetailListModel> detailsList,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
    if (detailsList.isEmpty) {
      CustomSnackBar.show(S.current.random_text_978, context,
          title: S.current.random_text_695, preIcon: CustomSnackBarIcons.error);
      return;
    }
    await CustomSafeDialog.show(
        context: context,
        tag: kCustomVipFanshuiDetailWidget,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
            child: Stack(children: [
              VipFanshuiListDetail(
                  detailsList: detailsList,
                  callBack: () {
                    RouteUtil.popView();
                  }).onTap(() {
                RouteUtil.popView();
              }).positioned(left: 1, top: 204, right: 1)
            ]),
          ).onTap(() {
            RouteUtil.popView();
          });
        });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
