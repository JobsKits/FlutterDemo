import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_button.dart';
import '../../../../widget/custom_text.dart';
import '../../../betting/sport/bet_mine/sport_bet_mine_item_view.dart';
import '../logic.dart';
import 'sport_my_bet_params.dart';

class SportMyBetDone extends GetView<SportBetLogic> {
  SportMyBetDone({super.key,this.fromPage});
  final SportMyBetFromPage? fromPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return Column(
          children: [
            Visibility(visible: controller.state.betListDone.isNotEmpty,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.state.betListDone.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return SportBetMineItemView(bean: controller.state.betListDone[index]);
                  }),
            ),
            Visibility(visible:controller.state.betListDone.isEmpty,child: _buildNoDataView())
          ],
        );
      }),
    );
  }
  Widget _buildNoDataView() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              'assets/images/sport/sport_nodata.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_8),
            CustomText(S.current.random_text_794, style: ThemeService().textTheme.labelLarge),
            CustomButton(
              //"立即开始下注!"
              title: S.current.sport_betting_begin_bet,
              alignment: Alignment.center,
              textStyle: ThemeService().textTheme.bodyMedium,
              onTap: () => controller.onClickGotoBetting(fromPage),
            ),
          ],
        ),
      ),
    );
  }

}