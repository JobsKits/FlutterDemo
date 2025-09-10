import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';

class CustomBettingEmptyWidget extends StatelessWidget {
  const CustomBettingEmptyWidget({super.key, this.textLabel, this.textClick, this.onClick});

  final String? textLabel;
  final String? textClick;

  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return _buildNoDataView();
  }

  Widget _buildNoDataView() {
    return Container(
      height: Get.height -
          AppBar().preferredSize.height -
          AppValues.sportHeight_20 -
          AppValues.sportHeight_153,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              'assets/images/sport/sport_nodata.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            CustomText(
              textLabel ?? S.current.random_text_221,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                    color: Color(0xFFB1BAD3),
                  ),
            ),
            const SizedBox(height: 5),
            // GestureDetector(onTap:(){
            //   widget.logic.state.activityLoading.value=false;
            //   widget.logic.loadActivityInfo(0);
            // },child:
            InkWell(
                onTap: () {
                  // controller.onChickGotoBetting();
                  if (onClick != null) {
                    onClick!.call();
                  }
                },
                child: CustomText(textClick ?? S.current.random_text_217)),
          ],
        ),
      ),
    );
  }
}
