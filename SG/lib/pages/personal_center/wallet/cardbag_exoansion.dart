import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/expansion/custom_expansion_panel.dart';
import 'binding_tripartite.dart';
import 'custom_wallet.dart';
import 'delete_address.dart';

const pix = 1;
const bindingBank = 2;
const bindingTripartite = 3;

const bindingVirtualAddress = 4;

var id, name, contractType, bankTree;

class CardExpansionTile extends StatelessWidget {
  ///点击item回调函数
  final ParamSingleCallback<String> onExpansionTap;
  final WalletController controller;

  const CardExpansionTile({
    super.key,
    required this.onExpansionTap, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
        return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: AppValues.margin_12),
        decoration:
        const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent))),
        child: _generateExpansionTileWidget(context),
      ),
    );
  }

  Widget _generateExpansionTileWidget(BuildContext context) {
    return Obx(() {
      return CustomExpansionPanelList.radio(
        tweenEnd: 0.5,
        closeIcon: "assets/images/top_drop_down arrow.png",
        expandIcon: "assets/images/top_drop_down arrow.png",
        dividerColor: null,
        elevation: 0,
        animationDuration: const Duration(milliseconds: 400),
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
        expansionCallback: (index, isExpand) {},
        children: controller.listCardBag.map<CustomExpansionPanelRadio>((dynamic bean) {
          return CustomExpansionPanelRadio(
              expandBackgroundColor: ThemeService().colorScheme.surfaceVariant,
              backgroundColor: ThemeService().colorScheme.surfaceVariant,
              canTapOnHeader: true,
              value: "${bean['id']}",
              headerBuilder: (BuildContext context, bool isExpanded) {
                if (isExpanded) {
                  id = bean['id'];
                  name = bean['name'];
                  contractType = bean['contract_type'];
                  bankTree = bean['bank_tree'];
                }
                return SizedBox(
                  height: 44,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: AppValues.defaultMargin,
                      ),
                      CustomText("${bean['subData'].length}"),
                      const Spacer(),
                      Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            CustomNetWorkImage(
                              imageUrl: bean['coinIcon'] ?? "assets/images/home/ic_football.webp",
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            CustomText(bean['name'] ?? ""),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              body: Visibility(
                child: bean['fiatCurrency'] == true
                    ? _fiatCurrencyView(bean['subData'] ?? [],bean['id'],context)
                    : _virtualCurrencyView(bean['subData'] ?? [],bean['id'],context),
              ));
        }).toList(),
      );
    });
  }

  Widget _fiatCurrencyView(var subData,var id,BuildContext context) {
    return Container(
      color: ThemeService().theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _fiatList(subData),
          Visibility(
              visible: id == "702" ? subData.length < 1 : subData.length < 3,
              child: _addBankCard(context,bindingBank))
        ],
      ),
    );
  }

  Widget _virtualCurrencyView(var subData,var id,BuildContext context) {
    return Container(
      color: ThemeService().theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _virtualList(subData),
          Visibility(
              visible:subData.length < 3,
              child: _addBankCard(context ,bindingVirtualAddress))
        ],
      ),
    );
  }

  Widget _fiatList(var subData) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.zero,
      itemCount: subData.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemFiat(subData, index,context);
      },
    );
  }

  Widget _itemFiat(var subData, int index,BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.surface,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: AppValues.margin_12,
              ),
              CustomAssetIcon(
                size: 18,
                name: subData[index]['cur']=="702"?"assets/images/personal_center_icon/pix_ic.webp":"assets/images/personal_center_icon/bank.webp",
                color: AppThemes.widgetColorWhite.withOpacity( subData[index]['state']==2?0.5:1),
              ),
              const SizedBox(
                width: AppValues.margin_12,
              ),
              CustomText(
                "${subData[index]['bankName']} ${subData[index]['bankAccount']}",
                overflow: TextOverflow.ellipsis,
                  style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.widgetColorWhite.withOpacity( subData[index]['state']==2?0.5:1))
              ),
              Visibility(
                visible: subData[index]['state']==2?true:false, //  暂不可用 文案 请勿删除
                child: const CustomText(
                  "   ",
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  textColorStyle: CustomTextColorStyle.normal ,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child:CustomText("${subData[index]['openName']}",
                      overflow: TextOverflow.ellipsis,
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.scoreTextColor.withOpacity( subData[index]['state']==2?0.5:1)))
                ),
              ),
              const SizedBox(
                width: AppValues.defaultMargin,
              ),
              CupertinoButton(
                padding: const EdgeInsets.only(left: AppValues.defaultMargin,right: AppValues.defaultMargin),
                onPressed: () {
                  // 删除银行卡地址
                  showCustomDeleteAddressWidget(
                      context: context, subData: subData[index], fiatCurrency: true,currencyId: id);
                },
                child: const CustomAssetIcon(
                  name: "assets/images/personal_center_icon/delete.webp",
                ),
              ),
              // const SizedBox(
              //   width: AppValues.defaultMargin,
              // )
            ],
          ),
        ),
        Container(
          color: ThemeService().colorScheme.surfaceVariant,
          height: 4,
        ),
      ],
    );
  }

  Widget _virtualList(var subData) {
    return Container(
      color: ThemeService().theme.scaffoldBackgroundColor,
      alignment: Alignment.center,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: subData.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemVirtual(subData, index,context);
        },
      ),
    );
  }

  Widget _itemVirtual(var subData, int index,BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.surface,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: AppValues.margin_12,
              ),
              Opacity(
                opacity:   subData[index]['state']==2?0.5:1,
                // child: CustomNetWorkImage(imageUrl: "${subData[index]['coinIcon']}",width: 18,height: 18,),
                child: CustomAssetIcon(name:controller.getCoinIc(subData[index]['cur']),size: 18,),
              ),
              const SizedBox(
                width: AppValues.margin_12,
              ),
              Expanded(
                flex: 1,
                child: CustomText(
                  "${subData[index]['address']}",
                  overflow: TextOverflow.ellipsis,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.widgetColorWhite.withOpacity( subData[index]['state']==2?0.5:1))) ,
                ),
              const SizedBox(
                width: AppValues.margin_12,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText("${subData[index]['contract_name']}",
                    overflow: TextOverflow.ellipsis,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.scoreTextColor.withOpacity( subData[index]['state']==2?0.5:1))),
              ),
              Visibility(
                visible: subData[index]['state']==2?true:false,
                child: const CustomText(
                  "",
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  textColorStyle: CustomTextColorStyle.normal ,
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.only(left: AppValues.defaultMargin,right: AppValues.defaultMargin),
                onPressed: () {
                  // 删除虚拟币地址
                  showCustomDeleteAddressWidget(
                      context: context, subData: subData[index], fiatCurrency: false,currencyId: id);
                },
                child: const CustomAssetIcon(
                  name: "assets/images/personal_center_icon/delete.webp",
                ),
              ),
            ],
          ),
        ),
        Container(
          color: ThemeService().colorScheme.surfaceVariant,
          height: 4,
        ),
      ],
    );
  }

  Widget _addBankCard(BuildContext context,int flag) {
    return GestureDetector(
      onTap: () {
        CustomSafeDialog.dismiss(context: context, tag: kCustomWalletWidget);
        showCustomDialog(context,flag);
      },
      child: Container(
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.only(top: AppValues.margin_12, bottom: AppValues.margin_12),
        decoration: BoxDecoration(
          color: ThemeService().colorScheme.surface,
        ),
        child:
        const Center(child: CustomIcon(asset: 'assets/images/personal_center_icon/add.webp')),
      ),
    );
  }

  void showCustomDialog(BuildContext context ,int flag) {
    if (flag == bindingBank) {
      if (id == "702") {
        flag = pix;
      }
    }
    switch (flag) {
      case bindingTripartite:
        showCustomBindingTripartiteWidget(context: context);
        break;
      case bindingBank:
        // showCustomBindingBankWidget(context: context, currencyId: id, bankTree: bankTree ?? "");
      log("neco bankTree $bankTree");
        RouteUtil.pushToView(Routes.personalBankCard,arguments: {'currencyId': id,'bankTree':bankTree??""});
        break;
      case bindingVirtualAddress:
        // showCustomBindingVirtualAddressWidget(context: context, currencyId: id, contractType: contractType, currencyName: name);
        RouteUtil.pushToView(Routes.personalAddress,arguments: {'currencyId': id,'contractType':contractType,'currencyName':name});
        break;
      case pix:
        // showCustomBindingPixWidget(context: context, currencyId: id, bankTree: bankTree ?? "");
        RouteUtil.pushToView(Routes.personalPix,arguments: {'currencyId': id,'bankTree':bankTree??""});
        break;
    }
  }
}
