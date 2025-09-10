import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/personal_center/vip/logic.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

enum VIP_PAGE_TYPE {
  dama,
  chongzhi,
}

/// 领取奖金弹窗
///
class VipJinJiGuiZe extends GetView<VipHomeLogic> {
  final VIP_PAGE_TYPE type;
  VipJinJiGuiZe(this.type, {super.key});

  final GlobalKey globalKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  final textStyle =
      ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
  final amountColor = const Color(0xFFFF9800);

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _buildBody(context) {
    double height = 54 * (controller.coinInfos.length + 1) + 255 > Get.height * 0.7
        ? Get.height * 0.7
        : 54 * (controller.coinInfos.length + 1) + 255;
    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          const SizedBox(height: AppValues.defaultMargin).sliverToBoxAdapter(),
          _buildTitleWidget().sliverToBoxAdapter(),
          _buildTransactionsTitle().sliverToBoxAdapter(),
          const SizedBox(height: AppValues.defaultMargin).sliverToBoxAdapter(),
          buildDetails(),
        ],
      )
          .paddingHorizontal(AppValues.defaultPadding)
          .paddingBottom(AppValues.defaultPadding)
          .backgroundColor(ThemeService().theme.scaffoldBackgroundColor)
          .height(height),
    );
  }

  ///构建title 行
  Widget _buildTitleWidget() {
    return <Widget>[
      SvgPicture.asset(type == VIP_PAGE_TYPE.dama
              ? "assets/svg/vip_dama.svg"
              : "assets/svg/vip_chongzhi.svg")
          .tightSize(15),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(type == VIP_PAGE_TYPE.dama ? S.current.random_text_976 : S.current.random_text_975,
          style: ThemeService().theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      const Spacer(),
      const CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_20)
          .marginOnly(left: AppValues.defaultMargin)
          .center()
          .onTap(() {
        RouteUtil.popView();
      })
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center);
  }

  /// 构建title
  Widget _buildTransactionsTitle() {
    List<String> desList = [];
    if (type == VIP_PAGE_TYPE.dama) {
      desList = [S.current.random_text_980, S.current.random_text_981, S.current.random_text_982];
    } else {
      desList = [S.current.random_text_983, S.current.random_text_984];
    }
    return <Widget>[
      CustomText(type == VIP_PAGE_TYPE.dama ? S.current.random_text_985 : S.current.random_text_986,
              style:
                  ThemeService().theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500))
          .paddingTop(AppValues.defaultPadding),
      for (int i = 0; i < desList.length; i++)
        CustomText(
          desList[i],
          style: ThemeService()
              .theme
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600, color: Color(0xffb1bad3)),
        ).paddingTop(AppValues.defaultPadding),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget buildDetails() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppValues.defaultPadding,
        crossAxisSpacing: AppValues.defaultPadding,
        childAspectRatio: 148 / 65,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                color: Color(0xff213743), borderRadius: BorderRadius.all(Radius.circular(4))),
            alignment: Alignment.centerLeft,
            child: <Widget>[
              CustomText(
                "${controller.coinInfos[index].name!} / USDT",
                style: ThemeService()
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Color(0xFFB1BAD3), fontWeight: FontWeight.w600),
              ),
              CustomText(controller.getRate(controller.coinInfos[index], 1),
                  style: ThemeService().textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700)),
            ]
                .toColumn(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start)
                .paddingAll(AppValues.defaultPadding),
          );
        },
        childCount: controller.coinInfos.length,
      ),
    );
  }

  Widget buildDetails1() {
    List<List<String>> itemsContent = [
      [
        S.current.random_text_630,
        S.current.random_text_631,
        S.current.random_text_632,
        S.current.random_text_633,
        S.current.random_text_634
      ],
    ];
    for (var element in controller.coinInfos) {
      itemsContent.add([
        "1.00",
        controller.getRate(element, controller.getMultipleWithGameType(4)) +
            " " +
            S.current.random_text_619,
        controller.getRate(element, controller.getMultipleWithGameType(1)) +
            " " +
            S.current.random_text_619,
        controller.getRate(element, controller.getMultipleWithGameType(3)) +
            " " +
            S.current.random_text_619,
        controller.getRate(element, controller.getMultipleWithGameType(2)) +
            " " +
            S.current.random_text_619,
        element.cur!,
      ]);
    }
    // double itemWidth = LangUtil().isZhCn() ? Get.width / 3 : Get.width / 2.5;
    final textWidthStyle = ThemeService()
        .theme
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.w500, color: Color(0xffb1bad3));
    // 文本最长宽度宽度
    List<double> itemMaxWidths = [];

    for (int textIndex = 0; textIndex < itemsContent.first.length; textIndex++) {
      double maxTextWidth = 0;
      for (var texts in itemsContent) {
        if (textIndex < texts.length) {
          final textWidth = StringUtil.textWidth(texts[textIndex], textWidthStyle);
          if (textWidth > maxTextWidth) {
            maxTextWidth = textWidth + 30;
          }
        }
      }
      itemMaxWidths.add(maxTextWidth);
    }

    // SingleChildScrollView 宽度
    var scrollWidth = 0.0;
    for (var itemWidth in itemMaxWidths) {
      scrollWidth += itemWidth;
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: AppValues.defaultPadding),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemsContent.length,
          itemBuilder: (context, index) {
            List<String> detials = itemsContent[index];
            final bgColor = index % 2 == 0
                ? ThemeService().theme.colorScheme.surfaceVariant
                : ThemeService().theme.scaffoldBackgroundColor;
            return Container(
              decoration: ShapeDecoration(
                  color: bgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
              child: <Widget>[
                <Widget>[
                  CustomText(
                    detials[0],
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500, color: Color(0xffb1bad3)),
                    textAlign: TextAlign.center,
                    maxLines: index == 0 ? 3 : 1,
                  ),
                  if (index != 0)
                    CustomNetWorkImage(
                      imageUrl: "${AppValues.defaultBranch.asset_url}/currency/${detials[5]}.webp",
                      width: AppValues.iconSmallSize,
                      height: AppValues.iconSmallSize,
                    ).paddingLeft(AppValues.halfPadding),
                ].toRow(mainAxisAlignment: MainAxisAlignment.center).tight(width: itemMaxWidths[0]),
                CustomText(detials[1],
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w500, color: Color(0xffb1bad3)),
                        textAlign: TextAlign.center)
                    .tight(width: itemMaxWidths[1]),
                CustomText(detials[2],
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w500, color: Color(0xffb1bad3)),
                        textAlign: TextAlign.center)
                    .tight(width: itemMaxWidths[2]),
                CustomText(detials[3],
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w500, color: Color(0xffb1bad3)),
                        textAlign: TextAlign.center)
                    .tight(width: itemMaxWidths[3]),
                CustomText(detials[4],
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w500, color: Color(0xffb1bad3)),
                        textAlign: TextAlign.center)
                    .tight(width: itemMaxWidths[4]),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceEvenly).tight(
                    height: 54,
                  ),
            );
          },
        ).tight(width: scrollWidth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VipHomeLogic>(
        init: VipHomeLogic(),
        id: "vip_lingqu_record",
        builder: (_) {
          return _buildBody(context).clipRRect(all: 5);
        });
  }
}
