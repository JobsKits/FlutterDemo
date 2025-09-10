import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/bottom/custom_close_button.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../main/code.dart';
import '../../main/logic.dart';
import '../common_model/betting_common_params.dart';
import '../common_widget/bet_slip_bar.dart';
import 'bet_order/bet_order_view.dart';
import 'betting_sport_logic.dart';
import 'bet_mine/betting_sport_mybet_view.dart';

///体育投注单
class BettingSportPage extends BaseView<BettingSportLogic> {
  final logic = Get.put<BettingSportLogic>(BettingSportLogic());
  final state = Get.find<BettingSportLogic>().state;

  BettingSportPage({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    state.buildData();
    return CustomAppBar(
      titleView: Obx(() {
        return Row(
          children: [
            AbsorbPointer(
              absorbing: state.loading.value,
              child: BetSlipBar(
                modelType: BetSlipBar.modelType_sprot,

                ///该参数决定当前为娱乐城还是体育的投注模块，后期放到全局公共模块
                chooseBetSlipTypeModel: controller.state.chooseType.value,

                ///暂时默认为娱乐城「我的投注」，后期由{modelType}决定
                betSlipTypeList: controller.state.sportTypeList,
                onChange: (chooseBetSlipType) {
                  controller.state.chooseType.value = chooseBetSlipType;

                  ///切换到我的投注时，判断注单列表内是否有已下完注的注单，有的话清空，并改变注单显示状态
                  if (globalController.bets.any((element) => element.showState != 0)) {
                    controller.deleteAllBetList();
                    controller.state.betStateForOrderDone.value = 0;
                  }
                },
                myBetCount: globalController.unsettlement.value,
                betSlipCount: controller.state.totalNum.value,
              ),
            ),
            Spacer(),
            CustomCloseButton(
              onTap: () {
                RouteUtil.popView();
                MainLogic.of().onMenuSelected(MenuCode.MSG);
              },
            ),
          ],
        );
      }),
      showLeading: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      return AbsorbPointer(
        absorbing: state.loading.value,
        child: Stack(
          children: [
            ///投注单
            Visibility(
              visible: controller.state.chooseType.value.type == BettingTypeEnum.betBill,
              child: SportBetOrderView(),
            ),

            ///我的投注
            Visibility(
              visible: controller.state.chooseType.value.type == BettingTypeEnum.myBet,
              child:
                  BettingSportMyBetView(fromPage: BettingFromPageType.browseMenuBettingSportType),
            ),
          ],
        ),
      );
    });
  }
}
