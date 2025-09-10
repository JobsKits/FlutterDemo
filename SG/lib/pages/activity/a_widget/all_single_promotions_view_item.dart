import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/activity/a_helper/activity_biz_helper.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/lang_util.dart';
import '../../../widget/custom_text.dart';
import '../a_model/activity_common_params.dart';
import '../all_promotions/all_promotions_api_model.dart';

///所有活动列表、单独娱乐城、体育博彩列表 公用item
class AllSinglePromotionsItemView extends StatelessWidget {
  const AllSinglePromotionsItemView({
    super.key,
    required this.index,
    required this.model,
    this.onItemClick,
    this.typeEnum = ActivityListTypeEnum.all,
    this.activityTypeEnum,
  });

  final int index;
  final AllPromotionsApiModel model;
  final ActivityListTypeEnum typeEnum; //默认 是 all  列表
  final ActivityTypeEnum? activityTypeEnum; //活动类型

  /// 按钮点击的回调
  final void Function(AllPromotionsApiModel model)? onItemClick;

  @override
  Widget build(BuildContext context) {
    // log("图片地址： ${AppValues.defaultBranch.asset_url}${model.shortcutDetail}");
    // log("图片地址： ${AppUrlsValues.envConfig.asset_url}${model.shortcutDetail}");
    //"images": "{\"back_ground\": \"promos/zh-CN/1708525833598.webp\"}",
    // var images = model.images?.replaceAll("\\", "")??"";
    // var backGround = json.decode(images)["back_ground"];
    // log("图片地址：images...$images,,,backGround...$backGround");
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: CustomButton(
        padding: EdgeInsets.zero,
        onTap: () {
          if (onItemClick != null) {
            onItemClick!(model);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ThemeService().theme.colorScheme.surfaceVariant, // 设置背景色
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  // bottomLeft:  Radius.circular(2),
                  // bottomRight: Radius.circular(2),
                ),
              ),
              child: CustomNetWorkImage(
                  width: 150,
                  height: 150,
                  fit: BoxFit.fitHeight,
                  // imageUrl:"${AppUrlsValues.envConfig.asset_url}${model.shortcutDetail}"
                  imageUrl: "${AppUrlsValues.envConfig.asset_url}/${model.images}"
                  // imageUrl:
                  //     "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
                  // errorWidget: const CustomAssetIcon(
                  //   name: 'assets/images/bet_slip/ic_defalut_coin.png',
                  //   size: 14,
                  // )
                  ),
            ),
            // const SizedBox(height: AppValues.halfMargin),
            Container(
              color: ThemeService().theme.colorScheme.surface, // 设置背景色
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.padding_6,
                vertical: AppValues.padding_8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          // LangUtil().isHiIN()
                          //     ? "${ActivityBizHelper.getIntTimeFormat2(model.displayEndAt)} ${S.current.random_text_828}"
                          //     : "${S.current.random_text_828}${ActivityBizHelper.getIntTimeFormat2(model.displayEndAt)}",
                        isShowTimeAndStatus()? (LangUtil().isHiIN()
                            ? "${model.endAtTz} ${S.current.random_text_828}"
                            : "${S.current.random_text_828}${model.endAtTz}"):"",
                          style: ThemeService()
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: AppValues.smallMargin),
                        CustomText(
                          model.name ?? "",
                          // "开始江东父老家啊就是浪费阿拉山口大家福利卡交罚款",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeService()
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppValues.halfMargin),
                  Visibility(
                    visible: isShowTimeAndStatus(),
                    child: Container(
                      // CustomButton
                      // title: "进行中",
                      // title: model.getBtnState().getLabel(),
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: AppValues.padding_16,
                      //   vertical: AppValues.halfPadding,
                      // ),
                      // borderRadius: const BorderRadius.all(Radius.circular(2)),
                      // textStyle: ThemeService().textTheme.labelMedium?.copyWith(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w600,
                      //       color: model.getBtnState().fontColor,
                      //     ),
                      // backgroundColor: model.getBtnState().bgColor ??
                      //     ThemeService().theme.colorScheme.tertiary, // 设置背景色,

                      padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.padding_16,
                        vertical: AppValues.halfPadding,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        color: model.getBtnState().bgColor ??
                            ThemeService().theme.colorScheme.tertiary, // 设置背景色,
                      ),
                      child: CustomText(
                        model.getBtnState().getLabel(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeService().textTheme.labelMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: model.getBtnState().fontColor,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Offstage(
            //     offstage: typeEnum == ActivityListTypeEnum.all,
            //     child: Container(
            //       margin: EdgeInsets.only(top: 8),
            //       child: CustomText(
            //         model.name ?? "",
            //         style: ThemeService()
            //             .textTheme
            //             .labelMedium
            //             ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            //       ),
            //     )),
            const SizedBox(height: AppValues.halfMargin),
          ],
        ),
      ),
    );
  }

  ///todo:[0610新需求] 自定义活动 不显示时间 和 活动状态按钮
  bool isShowTimeAndStatus() {
    return activityTypeEnum != ActivityTypeEnum.custom;
  }
}
