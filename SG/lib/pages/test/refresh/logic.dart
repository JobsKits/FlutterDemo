import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/widget/refresh/custom_pull_to_refresh.dart';
import 'package:flutter_bet/widget/refresh/custom_pull_to_refresh_controller.dart';
import 'package:get/get.dart';

class TestRefreshLogic extends BaseController {

  final listSize = 30.obs;

  final CustomPullToRefreshController pullToRefreshController =
      CustomPullToRefreshController(controlFinishRefresh: true,controlFinishLoad: true);

}
