import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/pages/home/widget/search_function.dart';
import 'package:flutter_bet/pages/sport/sport_event/sport_event_view.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../widget/expansion/expand_item_model.dart';
import '../../../widget/expansion/expand_list_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/expansion/custom_expansion_tile.dart';
import '../amodel/home_common_params.dart.dart';
import '../home_state.dart';
import 'nav_item_view.dart';

///体育导航
class NavSportView extends GetView<HomeLogic> {
  HomeState data;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  NavSportView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ExpandStateBean bean = data.expandSportData.sublist(7, 8)[0];
      ExpandListModel bean = data.expandCommonData[NavEnum.odds]!;
      bean.headTitle =
          '${S.current.menu_odds}：${SPUtil().getString(CacheKey.oddsString) ?? S.current.odds_decimal}';
      List<ExpandListModel> oddsBean = [bean];
      return Visibility(
          visible: globalController.menuSelectType.value == 1 &&
              controller.state.showInfoType.value == 0,
          child: navigationBuildInfoBg(children: [
            ///显示 滚球、即将开赛、我的投注
            _showRollingComingBetting(),

            ///显示 顶级体育项目
            _showTopSport(),

            ///所有电子竞技
            // navigationBuildModuleBg(children: [
            //   CustomExpansionTile(
            //     onExpansionTap: (value) {
            //       log('所有电子竞技...点击了$value');
            //     },
            //     data: data.expandSportData.sublist(5, 6),
            //   )
            // ]),

            ///显示 所有体育项目
            _showAllSport(),

            ///显示 赔率格式
            _showOddsType(oddsBean),

            ///显示 个人资料、促销活动、联盟计划、Vip俱乐部
            _showProfilePromotionsAllianceVipClub(context),

            ///显示 负责任博彩、在线支持、语言切换
            _showResponsibleOnlineSupportLanguage(context),
          ]));
    });
  }

  Widget _buildLine() {
    return Container(
      width: double.infinity,
      height: 2,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }

  ///显示 滚球、即将开赛、我的投注
  _showRollingComingBetting() {
    return navigationBuildModuleBg(
        children: List.generate(data.sportOne.length, (index) {
      return NavItemView(
        assetName: data.sportOne[index].icon!,
        title: data.sportOne[index].title.value,
        tag: data.rcb.value,
        showTag: data.sportOne[index].showTag!,
        isLogin: (index != 2 || globalController.isLogin.value) && globalController.isNormal.value,
        onTap: () {
          if (!globalController.isNormal.value) {
            return;
          }
          if (index == 0) {
            controller.goTorRoute(data.sportOne[index].route ?? '', arg: '3');
          } else if (index == 1) {
            controller.goTorRoute(data.sportOne[index].route ?? '', arg: '4');
          } else {
            if (globalController.isLogin.value) {
              controller.goTorRoute(data.sportOne[index].route ?? '');
            }
          }
        },
      );
    }));
  }

  ///显示 顶级体育项目
  _showTopSport() {
    return navigationBuildModuleBg(
        children: List.generate(data.sportTwo.length + 1, (index) {
      if (index == 0) {
        return SizedBox(
          height: 45,
          child: Column(
            children: [
              Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: CustomText(data.sportTwo[index].title.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: globalController.isNormal.value
                                    ? null
                                    : AppThemes.textColorGrey)),
                      ))),
              _buildLine(),
            ],
          ),
        );
      } else {
        ///顶级体育项目
        return CustomExpansionTile(
          data: data.topSportData,
          isNormal: globalController.isNormal.value,
          onExpansionTap: (ExpandItemModel model) {
            log('顶级体育项目...点击了$model');
            var params = model.data;
            SportEventPage.openPage(params);
          },
        );
      }
    }));
  }

  ///显示 所有体育项目
  _showAllSport() {
    return Visibility(
      visible: data.allSportData.isNotEmpty,
      child: navigationBuildModuleBg(children: [
        CustomExpansionTile(
          data: data.allSportData,
          isNormal: globalController.isNormal.value,
          onExpansionTap: (model) {
            log('所有体育项目...点击了...$model');
            // id: model.itemId, title: model.itemTitle ?? ""
            var params = model.data;
            SportEventPage.openPage(params);
          },
        )
      ]),
    );
  }

  ///显示 赔率格式
  _showOddsType(List<ExpandListModel> oddsBean) {
    return navigationBuildModuleBg(children: [
      CustomExpansionTile(
        type: 0,
        oddsChooseId: globalController.oddsType.value,
        onExpansionTap: (value) {
          log('点击了${value.itemId}');
          globalController.oddsType.value = value.itemId;
          SPUtil().setInt(CacheKey.oddsType, value.itemId);
          SPUtil().setString(CacheKey.oddsString, value.itemTitle);
        },
        data: oddsBean,
      )
    ]);
  }

  ///显示 个人资料、促销活动、联盟计划、Vip俱乐部
  _showProfilePromotionsAllianceVipClub(BuildContext context) {
    return navigationBuildModuleBg(
      children: data.sportThree.map((model) {
        var navEnum = model.navEnum;
        //个人资料
        if (navEnum == NavEnum.profile) {
          if (globalController.isLogin.value) {
            return CustomExpansionTile(
              onExpansionTap: (value) {
                print('点击了${value.itemTitle}');
                controller.onClickNavProfile(value.itemId, context);
              },
              // data.expandData.sublist(0, 2),  //表示索引开始， 不包含最后2
              data: [data.expandCommonData[NavEnum.profile]!],
              // data: [data.expandData[NavEnum.profile]!],
            );
          } else {
            return CustomExpansionTile(
              onExpansionTap: (value) {
                print('点击了${value.itemTitle}');
                controller.onClickNavProfile(value.itemId, context);
              },
              // data: data.expandData.sublist(1, 2),
              // data:[data.expandData[NavEnum.promotions]!],
              data: [],
            );
          }
        }
        //促销活动
        else if (navEnum == NavEnum.promotions) {
          return Visibility(
            visible: data.activityDataObs.isNotEmpty,
            child: CustomExpansionTile(
              onExpansionTap: (value) {
                log('点击了...促销活动...${value.toString()}');
                controller.onClickNavPromotions(value.itemId, value.data);
              },
              // data.expandData.sublist(0, 2),  //表示索引开始， 不包含最后2
              // data: [data.expandData[NavEnum.promotions]!],
              data: data.activityDataObs,
            ),
          );
        }
        //其他
        else {
          return NavItemView(
            assetName: model.icon!,
            title: model.title.value,
            onTap: () {
              controller.onNavigationClicked(model.route, context);
            },
          );
        }
      }).toList(),
    );
  }

  ///负责任博彩、在线支持、语言切换
  _showResponsibleOnlineSupportLanguage(BuildContext context) {
    return navigationBuildModuleBg(
        children: List.generate(data.sportFour.length + 2, (index) {
      if (index == 0) {
        return CustomExpansionTile(
          onExpansionTap: (value) {
            print('点击了0${value.itemTitle}');
            controller.onNavigationClicked(value.itemTitle, context);
          },
          // data: data.expandSportData.sublist(10, 11),
          // data: [data.expandData[NavEnum.sponsorships]!],
          //todo：0205。暂时隐藏
          data: [],
        );
      } else if (index == 3) {
        // ExpandStateBean bean = data.expandSportData.sublist(11, 12)[0];
        ExpandListModel bean = data.expandCommonData[NavEnum.language]!;
        bean.headTitle =
            '${S.current.language}：${SPUtil().getString(CacheKey.langString) ?? 'English'}';
        List<ExpandListModel> expandData = [bean];

        ///语种选择
        return CustomExpansionTile(
          type: 1,
          langChooseId: globalController.langType.value,
          onExpansionTap: (value) {
            print('点击了${value.itemId}');
            globalController.langType.value = value.itemId;
            SPUtil().setInt(CacheKey.langType, value.itemId);
            SPUtil().setString(CacheKey.langString, value.itemTitle);
            controller.changeLang(value.itemId);
          },
          data: expandData,
        );
      } else {
        return NavItemView(
          assetName: data.sportFour[index - 1].icon!,
          title: data.sportFour[index - 1].title.value,
          onTap: () {
            controller.onNavigationClicked(data.sportFour[index - 1].title, context);
          },
        );
      }
    }));
  }
}
