import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../common_model/betting_common_params.dart';
import 'betting_sport_mybet_logic.dart';
import 'sport_bet_mine_item_view.dart';
import 'sport_bet_mine_unbill_view_item.dart';

///我的投注-tab下的-未结算
class SportBetMineUnBillView extends StatefulWidget {
  SportBetMineUnBillView({super.key, required this.fromPage, this.isShowTab = true});

  final BettingFromPageType fromPage;
  final bool isShowTab;
  final logic = Get.put(BettingSportMyBetLogic());

  @override
  State<StatefulWidget> createState() => _SportBetMineUnBillViewState();
}

class _SportBetMineUnBillViewState extends State<SportBetMineUnBillView>
    with WidgetsBindingObserver {
  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 添加WidgetsBindingObserver
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Obx(() {
        return widget.logic.state.activityLoading.value
            ? (widget.logic.state.betUnBillListObs.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.logic.state.betUnBillListObs.length,
                    itemBuilder: (BuildContext buildContext, int index) {
                      return SportBetMineItemView(
                        bean: widget.logic.state.betUnBillListObs[index],
                        itemType: BettingOrderItemType.unBillList,
                      );
                    })
                : _buildNoDataView())
            : SizedBox(
                height: 180,
                child: CustomNetWorkImagePlaceholder(
                  color: AppThemes.surfaceVariant.withOpacity(0),
                  placeholderType: NetWorkImagePlaceholderType.loading,
                  // borderRadius: borderRadius,
                  // border: border,
                ));
      }),
    );
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
              height: AppValues.sportIconNoData,
              width: AppValues.sportIconNoData,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            CustomText(
              widget.isShowTab ? S.current.random_text_241 : S.current.random_text_681,
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
                widget.logic.onClickEmptyBettingToHome(widget.fromPage);
              },
              child: CustomText(S.current.random_text_217),
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  S.current.yulecheng_prepage,
                  textColorStyle: CustomTextColorStyle.secondary,
                ),
                const SizedBox(width: AppValues.sportHeight_16),
                CustomText(
                  S.current.yulecheng_nextpage,
                  textColorStyle: CustomTextColorStyle.secondary,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });

    if (state == AppLifecycleState.resumed) {
      // 页面可见
      print('Page is now visible');
    } else {
      // 页面不可见
      print('Page is now not visible');
    }
  }

  @override
  void didChangeDependencies() {
    if (_appLifecycleState != AppLifecycleState.resumed) {
      widget.logic.state.activityLoading.value = false;
    }
    widget.logic.loadActivityInfo(0);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    // widget.logic.dispose();
  }
}
