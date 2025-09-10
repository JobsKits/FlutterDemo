import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_alliance_process_level_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/refresh/custom_refresh_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/getx/page_state.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../commission_rate/commission_rate_logic.dart';
import '../commission_rate/commission_rate_view.dart';
import '../widget/custom_alliance_process_detail_widget.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import '../wmodel/alliance_common_params.dart';
import 'promotion_study_logic.dart';

///联盟计划 - 推广教程
class PromotionStudyPage extends StatefulWidget {
  PromotionStudyPage({super.key});

  @override
  State<PromotionStudyPage> createState() => _PromotionStudyPageState();
}

class _PromotionStudyPageState extends State<PromotionStudyPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(PromotionStudyLogic());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PromotionStudyLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return Container(
        height: logic.refreshCtrl.getMeasureHeight(500),
        color: ThemeService().theme.colorScheme.background, // 设置背景色
        child: Obx(() {
          return CustomLoadStateLayout(
            configState: logic.loadState.value,
            configSuccess: _buildContent(),
            configRetry: (pageState) {
              log("执行 重新加载...上个状态...${pageState}");
              logic.loadState.value = PageState.LOADING;
            },
            showErrorRetry: false,
            showEmptyRetry: false,
            showNetErrorRetry: false,
          );
        }),
      );
    });
  }

  _buildContent() {
    return CustomRefreshView(
      controller: logic.refreshCtrl,
      // physics: const ClampingScrollPhysics(),
      physics: const NeverScrollableScrollPhysics(),
      refreshOnStart: false,
      isCanRefresh: false,
      isCanLoadMore: false,
      onRefreshAction: (refreshController) {
        refreshController.finishRefresh();
      },
      child: CustomMeasureSizeWidget(
        onChange: (size) {
          logic.refreshCtrl.measureHeight = size.height;
        },
        child: Column(
          children: [
            // SizedBox(height: AppValues.defaultPadding),
            _buildStudyImage(),
            // _buildStudyProcess01(),
            // _buildStudyProcess02(),
            // _buildProcess(),
            SizedBox(height: AppValues.defaultMargin),
            _buildDescription(),
            SizedBox(height: AppValues.defaultMargin),
          ],
        ),
      ),
    );
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: CustomRefreshView(
        controller: logic.refreshCtrl,
        isCanLoadMore: false,
        onRefreshAction: (refreshController) {},
        child: Column(
          children: [
            // SizedBox(height: AppValues.defaultPadding),
            _buildStudyImage(),
            // _buildStudyProcess01(),
            // _buildStudyProcess02(),
            // _buildProcess(),
            // SizedBox(height: AppValues.halfMargin),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  ///加载教程图片
  _buildStudyImage() {
    // return CustomNetWorkImage(
    //   height: 300,
    //   imageUrl:
    //       "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
    // );

    return Container(
      child: Image.asset(
        logic.studyPicAssetObs.value,
        width: Get.width,
      ),
    );
  }

  _buildStudyProcess02() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
      child: Container(
        // height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFF213743),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xFFFF9D00)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const SizedBox(width: 100),
      ),
    );
  }

  ///举例说明描述
  _buildDescription() {
    return Container(
      color: ThemeService().theme.colorScheme.background, // 设置背景色
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: ThemeService().theme.colorScheme.surface, // 设置背景色
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(
            //         child: Text(
            //           S.current.random_text_534,
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //             fontWeight: FontWeight.w600,
            //             height: 0,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       SizedBox(
            //         child: Text(
            //           // S.current.random_text_535,
            //           "",
            //           style: TextStyle(
            //             color: Color(0xFFB1BAD3),
            //             fontSize: 16,
            //             fontWeight: FontWeight.w400,
            //             height: 0,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 24),
            ///直属团队
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      S.current.random_text_177,
                      style: TextStyle(
                        color: Color(0xFFF0F0F0),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Text(
                      // S.current.random_text_536,
                      S.current.random_text_1151,
                      style: TextStyle(
                        color: Color(0xFFB1BAD3),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// 其他团队
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      S.current.random_text_179,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Text(
                      // S.current.random_text_537,
                      S.current.random_text_1152,
                      style: TextStyle(
                        color: Color(0xFFB1BAD3),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ///总结说明
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      S.current.random_text_538,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Text(
                      // S.current.random_text_539,
                      S.current.random_text_1153,
                      style: TextStyle(
                        color: Color(0xFFB1BAD3),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ///佣金比例表如下
            SizedBox(
              child: Text(
                S.current.random_text_1154,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildCommissionRate(),
          ],
        ),
      ),
    );
  }

  ///佣金比例表如下
  Widget _buildCommissionRate() {
    // return Container();
    return Obx(() {
      return Container(
        height: CommissionRateLogic.of().pageMaxHeightObs(),
        child: CommissionRatePage(
          showTypeLabel: false,
          canScroll: false,
          tabColor: ThemeService().theme.scaffoldBackgroundColor,
          titleColor: ThemeService().theme.colorScheme.surface,
          isStudy: true,
        ),
      );
    });
  }
}
