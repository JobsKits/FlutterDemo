import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../model/sport/sport_bet_list_model.dart';
import '../../../../services/branch/branch_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/odds_util.dart';
import '../../../../widget/button/custom_icon_button.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/sport/custom_sport_mixin/custom_sport_live_window_mixin.dart';
import '../../../../widget/sport/until/custom_sport_until.dart';
import '../../../sport/sport_detail/view.dart';
import '../../common_helper/betting_biz_helper.dart';
import '../betting_sport_state.dart';

///未结算 item
@Deprecated("重复使用， 可以废弃掉")
class SportBetMineUnBillItemView extends StatefulWidget {
  const SportBetMineUnBillItemView({super.key, required this.bean});

  final ListElement bean;

  @override
  State<StatefulWidget> createState() => _SportBetMineUnBillItemViewState();
}

class _SportBetMineUnBillItemViewState extends State<SportBetMineUnBillItemView>
    with CustomSportLiveWindowMixin {
  var showDetail = false;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  @override
  Future addOverlayEntry(double left, double top, BuildContext context) {
    return super.addOverlayEntry(left, top, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.tertiary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            child: Row(
              children: [
                CustomText(
                  TimeUtils.timeStampToTime(widget.bean.bt!),
                  style: ThemeService().textTheme.labelLarge,
                ),
                const Expanded(child: SizedBox()),
                CustomIcon(asset: 'assets/images/bet_slip/ic_casino_bet_order.webp')
              ],
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
            color: ThemeService().colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          // SportDetailPage.openPage(si: widget.bean.bi[0].si, eid: widget.bean.bi[0].ei);
                        },
                        child: CustomText(
                          // '${widget.bean.bi[0].htn} - ${widget.bean.bi[0].atn}',
                          BettingBizHelper.getBetDetailTeamNameLabel(widget.bean.bi[0]),
                          style: ThemeService().textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomText(
                        widget.bean.bi[0].btn ?? '',
                        style: ThemeService().textTheme.labelLarge,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          CustomText(
                            widget.bean.bi[0].sn ?? '',
                            style: ThemeService().textTheme.bodyMedium,
                          ),
                          const Expanded(child: SizedBox()),
                          CustomText(
                            OddsUtil().covertOdds(double.parse(widget.bean.bi[0].ov!)),
                            style: ThemeService().textTheme.bodyMedium,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Visibility(
                            ///是否为滚球
                            visible: false,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(
                                  color: AppThemes.reverseStateColor,
                                  borderRadius: BorderRadius.circular(2)),
                              child: CustomText(
                                S.current.bet_live,
                                style: ThemeService().textTheme.bodySmall,
                              ),
                            ),
                          ),
                          // CustomText(
                          //   '第二盘',
                          //   style: ThemeService().textTheme.labelLarge,
                          // ),
                          // const SizedBox(
                          //   width: AppValues.margin_6,
                          // ),
                          // CustomText(
                          //   '0-2',
                          //   style: ThemeService().textTheme.labelLarge,
                          // ),
                          // const SizedBox(
                          //   width: AppValues.margin_6,
                          // ),
                          CustomText(
                            '${TimeUtils.timeStampToDate((widget.bean.bi[0].ed ?? 0).toInt()).replaceAll('/', '${DateUtil.getWeekday(DateTime.fromMillisecondsSinceEpoch((widget.bean.bi[0].ed ?? 0).toInt() * 1000), short: true, languageCode: 'zh')} ')}',
                            style: ThemeService().textTheme.labelLarge,
                          ),
                          Expanded(child: SizedBox()),
                          CustomIconButton(
                            padding: 0,
                            widgetWidth: 20,
                            widgetHeight: 20,
                            iconWidth: 16,
                            iconHeight: 16,
                            iconWidget: Image.asset(
                              'assets/images/bet_slip/ic_score_detail.webp',
                              width: 16,
                              height: 16,
                            ),
                            onTap: () {
                              setState(() {
                                showDetail = !showDetail;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Visibility(
                      visible: showDetail,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: Container(
                                width: double.infinity,
                                height: 96.h + 0.5,
                                child: IntrinsicWidth(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 32.h,
                                        color: ThemeService().theme.colorScheme.surface,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 8.w),
                                            CustomText(
                                              TimeUtils.timeStampToTime(widget.bean.bt!),
                                              style: ThemeService().textTheme.labelLarge,
                                            ),
                                            Expanded(child: SizedBox()),
                                            Image.asset(
                                              SportUntil().tabImage(true, widget.bean.bi[0].si ?? 999),
                                              width: 14.w,
                                              height: 14.h,
                                            ),
                                            SizedBox(width: 8.w),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 32.h,
                                        color: ThemeService().theme.colorScheme.surfaceVariant,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 8.w),
                                            CustomNetWorkImage(
                                              width: 14.h,
                                              height: 14.h,
                                              imageUrl: BranchService.instance.current.asset_url +
                                                  (widget.bean.bi[0].htpic ?? ''),
                                              placeholder: Image.asset(
                                                SportUntil().tabImage(true, widget.bean.bi[0].si ?? 999),
                                                width: 14.w,
                                                height: 14.h,
                                              ),
                                              errorWidget: Image.asset(
                                                SportUntil().tabImage(true, widget.bean.bi[0].si ?? 999),
                                                width: 14.w,
                                                height: 14.h,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            CustomText(widget.bean.bi[0].htn.toString()),
                                            Expanded(child: SizedBox()),
                                            Container(
                                              width: 32.w,
                                              height: 32.h,
                                              color: ThemeService().theme.colorScheme.surfaceVariant,
                                              child: Center(
                                                child: CustomText(widget.bean.bi[0].re!.split(':')[0],
                                                    style: ThemeService()
                                                        .theme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: const Color(0xFFFF9D00),
                                                            fontSize: AppValues.fontBodyMediumSize,
                                                            fontWeight: FontWeight.w700)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white.withOpacity(0.2),
                                        height: 0.5,
                                      ),
                                      Container(
                                        height: 32.h,
                                        color: ThemeService().theme.colorScheme.surfaceVariant,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 8.w),
                                            CustomNetWorkImage(
                                              width: 14.h,
                                              height: 14.h,
                                              imageUrl: BranchService.instance.current.asset_url +
                                                  (widget.bean.bi[0].atpic ?? ''),
                                              placeholder: Image.asset(
                                                SportUntil().tabImage(true, widget.bean.bi[0].si ?? 999),
                                                width: 14.w,
                                                height: 14.h,
                                              ),
                                              errorWidget: Image.asset(
                                                SportUntil().tabImage(true, widget.bean.bi[0].si ?? 999),
                                                width: 14.w,
                                                height: 14.h,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            CustomText(widget.bean.bi[0].atn.toString()),
                                            Expanded(child: SizedBox()),
                                            Container(
                                              width: 32.w,
                                              height: 32.h,
                                              color: ThemeService().theme.colorScheme.surfaceVariant,
                                              child: Center(
                                                child: CustomText(widget.bean.bi[0].re!.split(':')[0],
                                                    style: ThemeService()
                                                        .theme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: const Color(0xFFFF9D00),
                                                            fontSize: AppValues.fontBodyMediumSize,
                                                            fontWeight: FontWeight.w700)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildLine()),
                          SizedBox(
                            width: AppValues.defaultMargin,
                          ),
                          CustomNetWorkImage(
                            imageUrl:
                                '${AppUrlsValues.envConfig.asset_url}/${Get.find<GlobalStateController>().brandDetailPc?['pc']?['pc_logo_white']}',
                            errorWidget: const CustomAssetIcon(
                              size: 69,
                              name: 'assets/images/bet_slip/ic_betting_meibo.webp',
                            ),
                            width: 69,
                            height: 26,
                            fit: BoxFit.scaleDown,
                          ),
                          SizedBox(
                            width: AppValues.defaultMargin,
                          ),
                          Expanded(child: _buildLine()),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          CustomText(
                            S.current.menu_odds,
                            style: ThemeService().textTheme.labelLarge,
                          ),
                          Expanded(child: SizedBox()),
                          CustomText(
                            OddsUtil().covertOdds(double.parse(widget.bean.ov!)),
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ThemeService().colorScheme.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          CustomText(
                            S.current.random_text_227,
                            style: ThemeService().textTheme.labelLarge,
                          ),
                          Expanded(child: SizedBox()),
                          CustomText('${widget.bean.a}'),
                          SizedBox(
                            width: 5,
                          ),
                          CustomNetWorkImage(
                            width: 14,
                            height: 14,
                            imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                            errorWidget: CustomAssetIcon(
                              name: 'assets/images/bet_slip/ic_defalut.png',
                              size: 14,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          CustomText(
                            S.current.random_text_228,
                            style: ThemeService().textTheme.labelLarge,
                          ),
                          Expanded(child: SizedBox()),
                          CustomText('${widget.bean.mwa}'),
                          SizedBox(
                            width: 5,
                          ),
                          CustomNetWorkImage(
                            width: 14,
                            height: 14,
                            imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                            errorWidget: CustomAssetIcon(
                              name: 'assets/images/bet_slip/ic_defalut.png',
                              size: 14,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: AppValues.defaultMargin,
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: ThemeService().theme.colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                S.current.random_text_229,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              CustomText('1.0300001'),
                              SizedBox(
                                width: 5,
                              ),
                              CustomNetWorkImage(
                                width: 14,
                                height: 14,
                                imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                                errorWidget: CustomAssetIcon(
                                  name: 'assets/images/bet_slip/ic_defalut.png',
                                  size: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppValues.defaultPadding,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/bet_slip/ic_bet_item_wave.webp')
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      height: 3,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }
}
