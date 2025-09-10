import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/pages/home/home_state.dart';
import 'package:flutter_bet/pages/home/widget/search_function.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:get/get.dart';

import '../../../constant/app_cache_key.dart';
import '../../../generated/l10n.dart';
import '../../../widget/expansion/expand_list_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/sp_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/expansion/custom_expansion_tile.dart';
import '../amodel/home_common_params.dart.dart';
import 'nav_item_view.dart';

///娱乐城导航
class NavCasinoView extends GetView<HomeLogic> {
  HomeState data;

  NavCasinoView({super.key, required this.data});

  final GlobalStateController globalController = Get.find<GlobalStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
          visible: globalController.menuSelectType.value == 0 && data.showInfoType.value == 0,
          child: navigationBuildInfoBg(children: [
            ///显示 娱乐城 和 体育 按钮
            _showCasinoSportButton(),

            ///收藏夹和近期游戏，未登陆时隐藏、我的投注
            _showCollectRecordBetting(),

            ///游戏列表
            _showAllCasinoGame(),

            ///游戏提供商
            _showGameSupplier(context),

            ///个人资料、促销活动、联盟计划、vip俱乐部
            _showProfilePromotionsAllianceVipClub(context),

            ///负责任博彩、在线支持、语言切换
            _showResponsibleOnlineSupportLanguage(context),
          ]));
    });
  }

  ///显示 娱乐城 和 体育 按钮
  Widget _showCasinoSportButton() {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth = Get.width;
    return Visibility(
        visible: globalController.showMenuImage.value,
        // visible: true,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  controller.onArticleCollect('casino');
                },
                child: Stack(children: [
                  Image.asset(
                    'assets/images/home/ic_casino_button.webp',
                    width: (screenWidth - 36) / 2,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: Center(child: CustomText(S.current.tab_bar_ent)),
                    top: 0,
                    bottom: 0,
                    right: 50,
                  )
                ]),
              )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  controller.onArticleCollect('sport');
                },
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/home/ic_sport_button.webp',
                      width: (screenWidth - 36) / 2,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      child: Center(child: CustomText(S.current.tab_bar_sports)),
                      top: 0,
                      bottom: 0,
                      right: 50,
                    )
                  ],
                ),
              )),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        ));
  }

  ///收藏夹和近期游戏，未登陆时隐藏、我的投注
  _showCollectRecordBetting() {
    return Visibility(
      visible: !globalController.showMenuImage.value,
      child: navigationBuildModuleBg(
        children: List.generate(data.casinoOne.length, (index) {
          return NavItemView(
            assetName: data.casinoOne[index].icon!,
            title: data.casinoOne[index].title.value,
            isLogin: globalController.isLogin.value,
            onTap: () {
              data.selectIndex.value = -1;
              if (globalController.isLogin.value == false) {
                // showCustomLoginWidget(context: context);
                // RouteUtil.pushToView(Routes.loginPage);
                return;
              }
              controller.onNavigationListoneClicked(index);
              print('点击了${data.casinoOne[index].title}');
            },
          );
        }),
      ),
    );
  }

  ///游戏列表
  _showAllCasinoGame() {
    return Visibility(
      visible: !globalController.showMenuImage.value,
      child: navigationBuildModuleBg(
          children: List.generate(data.casinoTwo.length, (index) {
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
                          child: CustomText(
                            data.casinoTwo[index].title.value,
                            textAlign: TextAlign.center,
                          ),
                        ))),
                _buildLine(),
              ],
            ),
          );
        } else {
          // var iconUrl = BranchService.instance.current.asset_url + data.casinoTwo[index].icon!;
          // log("游戏菜单,index:$index, iconUrl:$iconUrl");
          // 游戏菜单,index:13, iconUrl:https://d2utx4nptvgikt.cloudfront.net/images/CATE/poker.webp
          return NavItemView(
            assetName: BranchService.instance.current.asset_url + data.casinoTwo[index].icon!,
            assetLocalName: "assets/images/nav/ic_nav_global_gray_3x.webp",
            title: data.casinoTwo[index].title.value,
            showBg: data.selectIndex.value == index,
            onTap: () {
              var itemInfo = data.casinoTwo[index];
              //排除掉标题
              if (itemInfo.data != null) {
                controller.onNavgationlistTwoClicked(index, itemInfo);
              }
              data.selectIndex.value = index;
              log('点击了${itemInfo.toString()}');
            },
          );
        }
      })),
    );
  }

  ///游戏提供商
  _showGameSupplier(BuildContext context) {
    return Visibility(
      visible: !globalController.showMenuImage.value,
      child: navigationBuildModuleBg(children: [
        NavItemView(
          assetName: 'assets/images/home/ic_game_provider_1.webp',
          title: S.current.game_supplier,
          onTap: () {
            controller.onNavigationClicked(S.current.game_supplier, context);
          },
        ),
      ]),
    );
  }

  ///个人资料、促销活动、联盟计划、vip俱乐部
  _showProfilePromotionsAllianceVipClub(BuildContext context) {
    return navigationBuildModuleBg(
      children: data.casinoThree.map((model) {
        var navEnum = model.navEnum;
        //个人资料
        if (navEnum == NavEnum.profile) {
          if (globalController.isLogin.value) {
            return CustomExpansionTile(
              onExpansionTap: (value) {
                print('点击了${value.itemTitle}');
                data.selectIndex.value = -1;
                controller.onClickNavProfile(value.itemId, context);
              },
              // data.expandData.sublist(0, 2),  //表示索引开始， 不包含最后2
              data: [data.expandCommonData[NavEnum.profile]!],
              // data: [data.expandData[NavEnum.profile]!],
            );
          } else {
            return CustomExpansionTile(
              onExpansionTap: (value) {
                log('点击了${value.itemTitle}');
                data.selectIndex.value = -1;
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
              // isNormal: globalController.isNormal.value,
              onExpansionTap: (value) {
                log('点击了...促销活动...${value.toString()}');
                data.selectIndex.value = -1;
                controller.onClickNavPromotions(value.itemId, value.data);
              },
              // data.expandData.sublist(0, 2),  //表示索引开始， 不包含最后2
              // data: [data.expandData[NavEnum.promotions]!],
              // data: [controller.state.activityExpendBeanObs.value!],
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
              data.selectIndex.value = -1;
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
        children: List.generate(data.casinoFour.length + 2, (index) {
      if (index == 0) {
        return CustomExpansionTile(
          onExpansionTap: (value) {
            print('点击了0${value.itemTitle}');
            data.selectIndex.value = -1;
            controller.onNavigationClicked(value.itemTitle, context);
          },
          // data: data.expandData.sublist(2, 3),
          // data:[data.expandData[NavEnum.sponsorships]!],
          data: [],
        );
      } else if (index == 3) {
        // ExpandStateBean bean = data.expandSportData.sublist(11, 12)[0];
        ExpandListModel bean = data.expandCommonData[NavEnum.language]!;
        bean.headTitle =
            '${S.current.language}：${SPUtil().getString(CacheKey.langString) ?? 'English'}';
        List<ExpandListModel> expandData = [bean];
        return CustomExpansionTile(
          type: 1,
          langChooseId: globalController.langType.value,
          onExpansionTap: (value) {
            print('点击了${value.itemTitle}');
            data.selectIndex.value = -1;
            globalController.langType.value = value.itemId;
            SPUtil().setInt(CacheKey.langType, value.itemId);
            SPUtil().setString(CacheKey.langString, value.itemTitle);
            controller.changeLang(value.itemId);
          },
          data: expandData,
        );
      } else {
        return NavItemView(
          assetName: data.casinoFour[index - 1].icon!,
          title: data.casinoFour[index - 1].title.value,
          onTap: () {
            data.selectIndex.value = -1;
            controller.onNavigationClicked(data.casinoFour[index - 1].title, context);
          },
        );
      }
    }));
  }

  ///分割线
  Widget _buildLine() {
    return Container(
      width: double.infinity,
      height: 2,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }
}
