import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_common.dart';
import '../../../constant/app_values.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/cell/custom_text_coin_cell_widget.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/list/money_coin_list_item_mixin.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../a_helper/activity_biz_helper.dart';
import '../a_model/promotion_process_item_model.dart';

const double cellMaxWidth = 80; //一行 一个cell 的宽度
const int rowCellTotal = 3; //一行 有多少个cell

///推广界面 开宝箱流程 一行格子 item
class PromotionProcessRowWidget extends StatelessWidget with MoneyCoinListItemMixin {
  PromotionProcessRowWidget({
    super.key,
    required this.index,
    required this.rowModelList,
    required this.showOutsideMoney,
    this.onItemClick,
  });

  final int index; //注意该index，不是所有数据的index ,是二维数组的index , 第1、2、3行
  final List<PromotionProcessItemModel> rowModelList;
  final void Function(PromotionProcessItemModel model)? onItemClick;
  final bool showOutsideMoney; //是否外部显示金额

  ///是否是偶数行
  bool isEvenRow() {
    return index % 2 == 0;
  }

  // final double rowCellWidth = (Get.width-20*3-24)/4;

  final double rowCellSeparatorWidth =
      (Get.width - cellMaxWidth * rowCellTotal - (16 + 8) * 2) / (rowCellTotal - 1);

  // final double rowCellSeparatorWidth = 40;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: Get.width,
      height: cellMaxWidth + 16, //需要考虑到底部显示金额
      alignment: isEvenRow() ? Alignment.centerLeft : Alignment.centerRight,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: rowModelList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        reverse: isEvenRow() ? false : true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            // width: Get.width / 5,
            // width: rowCellWidth,
            width: cellMaxWidth,
            // padding: EdgeInsets.all(1),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // _buildCenterIcon(
                //     "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg"),
                // _buildCenterIcon(rowModelList[index].imgUrl),
                _buildCenterAssetIcon(rowModelList[index]),
                const SizedBox(height: AppValues.padding_2),
                //是否显示金额
                Visibility(
                  visible: !rowModelList[index].insideMoney,
                  child:
                      //     //不需要小数特殊处理
                      //     CustomMoneyCoinCellWidget(
                      //   moneyTarget: ActivityBizHelper.getRedPacketMoney(rowModelList[index].money),
                      //   coinUrl: rowModelList[index].coinUrl,
                      //   padding: EdgeInsets.zero,
                      //   style: ThemeService()
                      //       .textTheme
                      //       .labelMedium
                      //       ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                      //   marginSpace: 2,
                      //   coinSize: 13,
                      // ),
                      MoneyCoinCellWidget(
                    money: ActivityBizHelper.getRedPacketMoney(rowModelList[index].money),
                    needDecimalDeal: false,
                    marginSpace: 2,
                    coinSize: 13,
                    padding: EdgeInsets.zero,
                    style: ThemeService()
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                    // coinBean: getCoinBean(model.currencyId),
                    coinBean: rowModelList[index].coinBean,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          //如果是 showOutsideMoney 为了让 箭头 跟 红包 或者宝箱 处于居中状态 手动处理高度
          return Container(
            // height: 54,
            // width: 20,
            width: rowCellSeparatorWidth,
            alignment: Alignment.center,
            // margin: const EdgeInsets.symmetric(horizontal: 1),
            // constraints: BoxConstraints.loose(Size.fromWidth(30)),
            child: Container(
              width: 12,
              margin: EdgeInsets.only(top: showOutsideMoney ? 32.h : 0),
              alignment: showOutsideMoney ? Alignment.topCenter : Alignment.center,
              // alignment: Alignment.topCenter,
              // margin: const EdgeInsets.only(top: cellMaxWidth / 2 - 12 / 2),
              child:
                  _buildArrowIcon(isEvenRow() ? ProcessRotate.rotate_0 : ProcessRotate.rotate_180),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCenterIcon(String imgUrl) {
    return CustomNetWorkImage(
      width: 54,
      height: 54,
      showErrorMsg: false,
      imageUrl: imgUrl,
    );
  }

  Widget _buildCenterAssetIcon(PromotionProcessItemModel model) {
    return InkWell(
      onTap: () {
        if (onItemClick != null) {
          onItemClick!.call(model);
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomAssetIcon(name: model.state.asset, width: cellMaxWidth),
          //内部显示金额
          Positioned(
            bottom: model.state.isRedPacket() ? 38 : 32,
            child: Visibility(
              visible: model.insideMoney && model.state.isOpenInside(),
              child:
                  // CustomText(
                  //   model.money,
                  //   style: ThemeService().textTheme.bodyMedium?.copyWith(
                  //       fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF752D10)),
                  // ),
                  //todo:[0531]推广活动，后台配置是不显示金额，宝箱/红包审核中和已领取的，缺少币种信息
                  MoneyCoinCellWidget(
                money: ActivityBizHelper.getRedPacketMoney(model.money),
                needDecimalDeal: false,
                colorSwitch: false,
                // color:const Color(0xFF752D10),
                marginSpace: 2,
                coinSize: 12,
                padding: EdgeInsets.zero,
                style: ThemeService().textTheme.labelMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF752D10),
                      fontFamily: "Proxima Nova",
                    ),
                coinBean: model.coinBean,
              ),
            ),
          ),
          //显示人数
          Positioned(
            bottom: LangService().isChinese ? 9 : 4,
            child: Baseline(
              baselineType: TextBaseline.alphabetic,
              baseline: 0,
              child: CustomText(
                // "1人",
                "${model.content}${LangService().isChinese ? '' : '\n'}${model.contentUnit}",
                textAlign: TextAlign.center,
                style: ThemeService()
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                //, fontFamily: "Proxima Nova"
              ),
            ),
          ),
          //显示审核中
          Visibility(
            visible: model.receiveState != null && model.receiveState!.isChecking(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CustomAssetIcon(
                    name: "assets/images/activity/gift/bg_activity_gift_checking.webp",
                    width: cellMaxWidth),
                CustomText(
                  S.current.random_text_1218,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///分割线
class PromotionProcessRowDividerWidget extends StatelessWidget {
  const PromotionProcessRowDividerWidget({super.key, required this.index});

  final int index;

  ///是否是偶数行
  bool isEvenRow() {
    return index % 2 == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cellMaxWidth / 4,
      // width: 100,
      margin: const EdgeInsets.only(bottom: 4),
      alignment: !isEvenRow() ? Alignment.centerLeft : Alignment.centerRight,
      // alignment: Alignment.centerRight,
      child: Container(
        width: cellMaxWidth,
        alignment: Alignment.center,
        child: _buildArrowIcon(ProcessRotate.rotate_90),
      ),
    );
  }
}

Widget _buildArrowIcon(ProcessRotate rotate) {
  return Transform.rotate(
    //旋转90度
    angle: rotate.value,
    child: const CustomAssetIcon(
      size: 14,
      name: 'assets/images/common/ic_common_arrow_right.webp',
    ),
  );
}
