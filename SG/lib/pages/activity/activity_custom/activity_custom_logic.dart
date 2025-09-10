import 'dart:convert';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:get/get.dart';
import '../../../constant/app_values.dart';
import '../../../services/api/api_service.dart';
import '../../../widget/sport/custom_sport_banner.dart';
import '../a_helper/activity_biz_mixin.dart';
import '../a_model/activity_cash_back.dart';
import '../a_model/activity_custom.dart';

class ActivityCustomLogic extends BaseController with ActivityBizMixin {

  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  String pid = "";
  final model = CustomActivityModel().obs;
  final buttonText = ''.obs;
  final loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      pid = Get.arguments["pid"];
    }
    loadData();
  }

  void loadData() async {
    await ApiService.instance.activityConfig(
      pid: pid,
      success: (data) {
        model.value = CustomActivityModel.fromJson(data);
        buttonText.value = getButtonStr();
        loading.value = false;
      },
      fail: (message) {
        loading.value = false;
      },
    );
  }

  getButtonStr() {
    var data = json.decode(model.value.buttonText!);
    Content mdl = Content.fromJson(data);
    if (globalController.langType.value == 1) {
      return mdl.contentZhCn ?? '';
    } else if (globalController.langType.value == 2) {
      return mdl.enUs ?? '';
    } else if (globalController.langType.value == 3) {
      return mdl.ptBr ?? '';
    } else if (globalController.langType.value == 4) {
      return mdl.viVn ?? '';
    } else if (globalController.langType.value == 5) {
      return mdl.thTh ?? '';
    } else if (globalController.langType.value == 6) {
      return mdl.hiIn ?? '';
    } else {
      return mdl.contentZhCn ?? '';
    }
  }

  onTap() {
    CustomSportBannerState().customSportBanner_onTap(model.value.buttonType!, model.value.buttonRedirect!,true);
  }
}
