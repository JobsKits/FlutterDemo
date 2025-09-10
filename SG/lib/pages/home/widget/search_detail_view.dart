import 'package:flutter_bet/generated/l10n.dart';
//import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/pages/home/widget/search_history_item.dart';
import 'package:flutter_bet/pages/sport/sport_detail/view.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../model/sport/search_sport_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../home_state.dart';

class SearchDetailView extends GetView<HomeLogic> {
  HomeState data;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  SearchDetailView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
          visible: data.showInfoType.value == 1,
          child: Stack(children: [
            Visibility(
                visible: data.showSearchType.value == 0 || data.showSearchType.value == 1,
                child: _buildEmptySearch(data.showSearchType.value, data.history)),
            Visibility(
                visible:
                    data.showSearchType.value == 2 && globalController.menuSelectType.value == 0,
                child: buildGridView(data.searchCasinoList)),
            Visibility(
                visible:
                    data.showSearchType.value == 2 && globalController.menuSelectType.value == 1,
                child: buildSportSearchView(data.searchSportList)),
          ]));
    });
  }

  ///0：提示至少3个字符+搜索记录 1:搜索无结果+搜索记录
  Widget _buildEmptySearch(int type, List<String> history) {
    return GestureDetector(
      onTap: () {
        controller.closeSearchView();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            GestureDetector(
              onTap: controller.unfocus,
              child: Container(
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colors.transparent,
                child: CustomText(
                  type == 0 ? S.current.random_text_337 : S.current.game_Category_no_results,
                  style: ThemeService().textTheme.labelLarge,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.unfocus,
              child: _buildSearchHistory(history),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory(List<String> history) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                S.current.game_category_recent_search,
                style: ThemeService().textTheme.labelLarge,
              ),
              Expanded(child: SizedBox()),
              InkWell(
                  onTap: () {
                    controller.cleanHistory();
                  },
                  child: CustomText(
                    '${S.current.game_category_clear_seach_results}${history.length})',
                    style: ThemeService().textTheme.labelLarge,
                  ))
            ],
          ),
          SizedBox(
            height: AppValues.margin_12,
          ),
          Wrap(
            children: [
              for (String item in history)
                SearchHistoryItem(
                  name: item,

                  ///点击自动搜索关键词
                  onTap: () {
                    controller.searchByClick(item);
                  },
                  deleteWord: (word) {
                    controller.removeWord(word);
                  },
                )
            ],
          ),
        ],
      ),
    );
  }

  ///搜索体育游戏结果列表
  Widget buildSportSearchView(List<SearchSportModelList> dataItems) {
    return controller.state.tabs.isNotEmpty
        ? GestureDetector(
            onTap: () {
              controller.closeSearchView();
            },
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ThemeService().theme.colorScheme.surface, // 设置背景色
                      borderRadius: BorderRadius.circular(4.0), // 设置圆角的半径
                    ),
                    child: CustomTabBarWithIcon(
                      tabs: controller.state.tabs,
                      tabController: controller.tabController,
                      backgroundColor: ThemeService().theme.colorScheme.tertiary,
                      radius: 4,
                      height: 50,
                      buttonMargin: const EdgeInsets.all(5),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: controller.state.listList.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        return buildSportItemView(controller.state.listList[index]);
                      }),
                )
              ],
            ),
          )
        : Container();
  }

  Widget buildSportItemView(ListList item) {
    return InkWell(
      onTap: () {
        SportDetailPage.openPage(si: controller.state.chooseSi.value, ci: item.ci!, isChampion: false);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 12,
            ),
            CustomText('${item.htn} - ${item.atn}'),
            const SizedBox(
              height: 16,
            ),
            CustomText(
              TimeUtils.timeStampToTime(item.ed!),
              style: TextStyle(color: AppThemes.textColorSecondary),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(controller.state.chooseSn.value),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/home/ic_menu_next.webp',
                  width: 14,
                  height: 14,
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  item.pgn ?? S.current.transactions_other,
                  style: TextStyle(color: AppThemes.textColorSecondary),
                ),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/home/ic_menu_next.webp',
                  width: 14,
                  height: 14,
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  item.cn ?? S.current.transactions_other,
                  style: TextStyle(color: AppThemes.textColorSecondary),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            _buildLine()
          ],
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: double.infinity,
      height: 1,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }

  // 搜索游戏结果列表
  Widget buildGridView(dataItems) {
    return GestureDetector(
      onTap: () {
        controller.closeSearchView();
      },
      child: Container(
        height: Get.height,
        margin: const EdgeInsets.all(AppValues.defaultMargin),
        child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 13,
              childAspectRatio: 115 / 150,
            ),
            itemCount: dataItems.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    controller.goToDetail(dataItems[index]);
                  },
                  child: <Widget>[
                    Stack(
                      children: <Widget>[
                        CustomNetWorkImage(
                          imageUrl: BranchService.instance.current.asset_url +
                              dataItems[index].gameImgUrl,
                          placeholder: CustomNetWorkImage(
                            imageUrl: BranchService.instance.current.asset_url +
                                dataItems[index].img.replaceAll(".webp", ".s.webp").replaceAll(
                                      "%lang%",
                                      LangUtil().getLangType(),
                                    ),
                            errorWidget: SizedBox(),
                          ),
                        ).paddingHorizontal(AppValues.smallPadding),
                      ],
                    ).expanded(),
                    // <Widget>[
                    //   // Container(
                    //   //   decoration: const BoxDecoration(
                    //   //     borderRadius: BorderRadius.all(Radius.circular(4)),
                    //   //     color: AppThemes.chatRoomOnlineGreenColor,
                    //   //   ),
                    //   // ).tight(width: 8, height: 8).paddingLeft(3),
                    //   Image.asset(
                    //     "assets/svg/green_pot.webp",
                    //     width: 30,
                    //     height: 30,
                    //   ),
                    //   CustomText(S.current.random_text_263,
                    //           style: TextStyle(fontSize: AppValues.fontBodySmallSize))
                    //       .paddingLeft(3),
                    // ].toRow().tight(height: 30).alignBottom()
                  ].toColumn());
            }),
      ),
    );
  }
}
