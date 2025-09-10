import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/alliance_program/activity/view.dart';
import 'package:flutter_bet/pages/alliance_program/capital/view.dart';
import 'package:flutter_bet/pages/alliance_program/plan/view.dart';
import 'package:flutter_bet/pages/alliance_program/recommendation/view.dart';
import 'package:flutter_bet/pages/alliance_program/summary/view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import '../../services/theme/theme_service.dart';
import '../../widget/dialog/custom_safe_dialog.dart';
import 'commission/view.dart';
import 'logic.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/setup/widgets/setup_tab_bar_widget.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';


const kCustomAllianceWidget = 'AllianceProgramWidget';

class AllianceProgramWidget extends StatefulWidget {
  const AllianceProgramWidget({Key? key}) : super(key: key);

  @override
  State<AllianceProgramWidget> createState() => _AllianceProgramWidgetState();
}

class _AllianceProgramWidgetState extends State<AllianceProgramWidget> {
  final logic = Get.lazyPut(()=>AllianceProgramLogic());
  final state = Get.find<AllianceProgramLogic>().state;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () => RouteUtil.popView(),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.defaultPadding),
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppValues.defaultPadding),
                  decoration: BoxDecoration(
                    color: ThemeService().theme.scaffoldBackgroundColor,
                    borderRadius:
                    BorderRadius.circular(AppValues.defaultRadius),
                  ),
                  child: Column(
                    children: [
                      _buildTop(),
                      _buildBody()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTop() {
  return Column(
    children: [
      const SizedBox(
        height: AppValues.largePadding,
      ),
      SizedBox(
        height: AppValues.allianceHeight_25.h,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  CustomIcon(
                    asset: 'assets/images/alliance/alliance_header_icon.webp',
                    size: AppValues.allianceHeight_20.w,
                  ),
                  const SizedBox(
                    width: AppValues.smallPadding,
                  ),
                  CustomText(
                    S.current.alliance_program,
                    style: ThemeService()
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  GestureDetector(
                    onTap: () {
                      RouteUtil.popView();
                    },
                    child: const CustomIcon(
                      asset: 'assets/images/normal/ic_normal_close.webp',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: AppValues.defaultPadding,
      ),
    ],
  );
}

Widget _buildBody() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SetupTabBarWidget(
        tabs: [
          Tab(
            child:
            Text(S.current.alliance_summary, style: ThemeService().theme.textTheme.bodyMedium),
          ),
          Tab(
            child:
            Text(S.current.alliance_plan, style: ThemeService().theme.textTheme.bodyMedium),
          ),
          Tab(
            child:
            Text(S.current.alliance_commission, style: ThemeService().theme.textTheme.bodyMedium),
          ),
          Tab(
            child:
            Text(S.current.alliance_capital, style: ThemeService().theme.textTheme.bodyMedium),
          ),
          Tab(
            child:
            Text(S.current.alliance_recommendation, style: ThemeService().theme.textTheme.bodyMedium),
          ),
          Tab(
            child:
            Text(S.current.alliance_activity, style: ThemeService().theme.textTheme.bodyMedium),
          ),
        ],
        children: [
          SummaryWidget(),
          PlanWidget(),
          CommissionWidget(),
          CapitalWidget(),
          RecommendationWidget(),
          ActivityWidget(),
        ],
      ),
    ],
  );
}


Future<void> showCustomAllianceWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {

  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomAllianceWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return const AllianceProgramWidget();
      });
}
