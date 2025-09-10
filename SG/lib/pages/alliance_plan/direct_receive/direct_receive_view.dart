import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../alliance_plan_logic.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget/custom_alliance_condition_widget.dart';
import '../widget/custom_alliance_page_widget.dart';
import '../wmodel/alliance_condition_model.dart';
import 'direct_receive_logic.dart';
import 'direct_receive_model.dart';
import 'direct_receive_view_item.dart';
import 'direct_receive_view_title.dart';

///联盟计划-直属领取tab
class DirectReceivePage extends StatefulWidget {
  const DirectReceivePage({Key? key}) : super(key: key);

  @override
  State<DirectReceivePage> createState() => _DirectReceivePageState();
}

class _DirectReceivePageState extends State<DirectReceivePage> with AutomaticKeepAliveClientMixin {
  final logic = Get.put(DirectReceiveLogic());
  final state = Get.find<DirectReceiveLogic>().state;

  //主要是给选择下拉组件 一个挂载锚地key, 通过它可以获取组件对象， 并计算获取size 大小，width 和 height
  final GlobalKey selectWidgetGlobalKey = GlobalKey();
  final bubbleWith = 200.0; //框度，动态计算
  final double heightOfWidget = 5; //倍数
  final RxInt limitTimeTypeTemp = RxInt(1); //初始值

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<DirectReceiveLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //ConstrainedBox
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Column(
        children: [
          // const SizedBox(height: AppValues.defaultPadding),
          // CustomButton(title: '上下拉测试', onTap: () => CustomClassicPage.openPage()),
          _buildTopView(),
          _buildListView(),
          // _buildBottomView(),
        ],
      ),
    );
  }

  _buildTopView() {
    return CustomAllianceConditionWidget(
      conditionConfig: AllianceConditionConfig.directReceive(),
      startTimeDefault: logic.conditionModel.defaultStartTime,
      endTimeDefault: logic.conditionModel.defaultEndTime,
      selectCoinList: logic.fLogic.selectCoinList,
      selectCoinDefault: 0,
      onAnyOneSelectedCallback: (dataOne, dataTwo, threeData) {
        log("条件选中...dataOne=${dataOne}...dataTwo=${dataTwo}...threeData=${threeData.toString()}");
        logic.collectParams(threeData);
        logic.loadNetData(isRefresh: true, isFirst: true);
      },
    );
    // return Row(
    //   // mainAxisSize: MainAxisSize.max,
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     CustomSelectWidget(
    //       width: 210,
    //       modelList: controller.selectTimeList,
    //       initSelected: 0,
    //       hintText: "选择时间",
    //       onSelected: (index, model) {},
    //     ),
    //     CustomAllianceSearchWidget(),
    //   ],
    // );
  }

  final ScrollController vScroll = ScrollController();

  _buildListView() {
    return Expanded(
      child: CustomListViewSlideWidget(
        // itemCount: controller.modelList.length,
        // listWidthMax: logic.windowListWidthMax,
        listWidthMax: AllianceWidthConfig.directReceive().width,
        titleBuilder: (context) => DirectReceiveTitleView(),
        // itemBuilder: (BuildContext context, int index) {
        //   return DirectReceiveItemView(index: index, model: controller.modelList[index]);
        // },
        // vCtrl: vScroll,
        childBulider: (context, hCtrl, vCtrl) {
          return Obx(() {
            return CustomLoadStateLayout(
              configState: logic.pageStateObs.value,
              configRetry: (pageState) => logic.loadNetData(isRefresh: true, isFirst: true),
              configSuccess: CustomRefreshView(
                  // clipBehavior: Clip.none,
                  controller: logic.refreshController,
                  refreshOnStart: false,
                  onRefreshAction: (refreshController) {
                    logic.loadNetData(isRefresh: true);
                  },
                  onLoadMoreAction: (refreshController) {
                    logic.loadNetData(isRefresh: false);
                  },
                  // scrollController: vScroll,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      // physics: const BouncingScrollPhysics(),
                      // controller: ScrollController(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: logic.apiModelList.length,
                      itemBuilder: (context, index) {
                        // return DirectReceiveItemView(index: index, model: controller.modelList[index]);
                        return DirectReceiveItemView(
                            index: index, model: logic.apiModelList[index]);
                      })),
            );
          });
        },
      ),
    );
  }

  _buildBottomView() {
    return CustomAlliancePageWidget(currentPage: logic.currentPage);
  }
}
