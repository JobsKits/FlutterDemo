import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:get/get.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../widget/custom_alliance_page_widget.dart';
import '../wmodel/alliance_common_params.dart';
import 'commission_rate_logic.dart';
import 'commission_rate_model.dart';
import 'commission_rate_view_item.dart';
import 'commission_rate_view_logic.dart';
import 'commission_rate_view_title.dart';

///联盟计划-拥挤比例tab-list详细页面
///不需要分页
class CommissionRateListView extends StatefulWidget {
  const CommissionRateListView(
      {super.key, required this.modelList, required this.canScroll, this.titleColor, this.isStudy});

  // final CommissionRateTypeEnum pageTypeEnum;
  final List<CommissionRateModel> modelList;
  final bool canScroll;
  final Color? titleColor;
  final bool? isStudy; //是否在我的教程中显示

  @override
  State<CommissionRateListView> createState() => _CommissionRateListViewState();
}

class _CommissionRateListViewState extends State<CommissionRateListView> {
  // final controllerBig = Get.find<CommissionRateLogic>();
  // final controller = Get.put<CommissionRateListLogic>(CommissionRateListLogic());

  final pageState = PageState.LOADING.obs;

  @override
  void dispose() {
    // Get.delete<CommissionRateListLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modelList != null && widget.modelList.isNotEmpty) {
      pageState.value = PageState.SUCCESS;
    } else {
      pageState.value = PageState.EMPTY;
    }
    return LayoutBuilder(builder: (_, constraints) {
      // log("佣金比例CommissionRateListView...constraints...$constraints");

      // return CustomListViewSlideWidget(
      //     // itemCount: controller.modelList.length,
      //     // listWidthMax: logic.windowListWidthMax,
      //     listWidthMax: LangService().isChinese ? Get.width -24: Get.width -24,
      //     titleBuilder: (context) => _buildTitle(),
      //     // itemBuilder: (BuildContext context, int index) {
      //     //   return DirectBettingItemView(index: index, model: controller.modelList[index]);
      //     // },
      //     childBulider: (context, hCtrl, vCtrl) {
      //       return SizedBox(
      //         height: constraints.maxHeight,
      //         child: Obx(() {
      //           return CustomLoadStateLayout(
      //             configState: pageState.value,
      //             showEmptyRetry: false,
      //             configSuccess: Column(
      //               children: [
      //                 // _buildTitle(),
      //                 _buildListView(),
      //                 // _buildBottomView(),
      //               ],
      //             ),
      //           );
      //         }),
      //       );
      //     });
      return SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        physics:
            widget.canScroll ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          child: Obx(() {
            return CustomLoadStateLayout(
              configState: pageState.value,
              showEmptyRetry: false,
              configSuccess: Column(
                children: [
                  _buildTitle(),
                  _buildListView(),
                  // _buildBottomView(),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  _buildTitle() {
    return CommissionRateTitleView(titleColor: widget.titleColor);
  }

  _buildListView() {
    return Expanded(
      child: LayoutBuilder(builder: (_, constraints02) {
        // log("佣金比例ListView...constraints02...$constraints02");
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.modelList.length,
          shrinkWrap: true,
          physics: widget.canScroll
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CommissionRateItemView(
              index: index,
              model: widget.modelList[index],
              //我的教程中 item 只有第一和 最后 有圆角
              borderRadius: widget.isStudy == true ? getBorderRadius(index) : null,
            );
          },
        );
      }),
    );
  }

  BorderRadius getBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4));
    } else if (index == widget.modelList.length - 1) {
      return const BorderRadius.only(
          bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4));
    } else {
      return const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0));
    }
  }

// _buildBottomView() {
//   return CustomAlliancePageWidget(currentPage: controller.currentPage);
// }
}
