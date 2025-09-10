import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:flutter_bet/utils/odds_util.dart';

import '../../../../constant/app_themes.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/sport/custom_sport_odd/custom_sport_odd_change_animation.dart';
import '../../../sport/sport_detail/view.dart';
import '../../common_helper/betting_biz_helper.dart';
import '../betting_sport_state.dart';

class SportDuplexBetItem extends StatefulWidget {
  const SportDuplexBetItem({super.key, required this.deleteBet, required this.bean});

  final M bean;
  final VoidCallback deleteBet;

  @override
  State<StatefulWidget> createState() => _SportDuplexBetItemState();
}

class _SportDuplexBetItemState extends State<SportDuplexBetItem> with TickerProviderStateMixin {
  bool isIconVisible = false; // 控制图标的可见性
  bool isOddsUp = false; //赔率上升还是下降

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(BettingBizHelper.isUnSupportDuplexBet(widget.bean)){
    //   log("复式投注item信息...${JsonUtil.encodeObj(widget.bean)}");
    // }
    // log("复式投注item信息...ov:${widget.bean.ov}...os:${widget.bean.os}...osDuplex:${widget.bean.osDuplex}");
    return Opacity(
      opacity: widget.bean.es == 2 || widget.bean.os == 0 ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildTitleView(),
            _buildContentView(),
            Image.asset('assets/images/bet_slip/ic_bet_item_wave.webp'),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleView() {
    return Container(
      height: 30,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: BettingBizHelper.isUnSupportDuplexBet(widget.bean)
              ? AppThemes.noBettingAllowedColor
              : ThemeService().colorScheme.tertiary,
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      child: Row(
        children: [
          _buildTitleState(),
          // Visibility(
          //   ///滚球 1:早盘 2:今日 3:滚球
          //   visible: widget.bean.m==3,
          //   child: Container(
          //     margin: const EdgeInsets.only(left: 12),
          //     padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          //     decoration: BoxDecoration(
          //         color: AppThemes.reverseStateColor,
          //         borderRadius: BorderRadius.circular(2)),
          //     child: CustomText(
          //       S.current.bet_live,
          //       style: ThemeService().textTheme.bodySmall,
          //     ),
          //   ),
          // ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: InkWell(
                onTap: () {
                  // SportDetailPage.openPage(si: widget.bean.si, eid: widget.bean.ei);
                },
                child: CustomText(
                  ///赛事名称
                  // '${widget.bean.htn} - ${widget.bean.atn}',
                  BettingBizHelper.getBetInfoTeamNameLabel(widget.bean),
                  style: ThemeService().textTheme.labelLarge,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {
                widget.deleteBet.call();
              },
              child: CustomAssetIcon(
                name: 'assets/images/bet_slip/ic_close_bet.webp',
                size: 18,
              )),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  Widget _buildContentView() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: ThemeService().colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          CustomText(
            widget.bean.btn ?? '',
            style: ThemeService().textTheme.labelLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              CustomText(
                widget.bean.htn ?? '',
                style: ThemeService().textTheme.bodyMedium,
              ),
              Expanded(child: SizedBox()),
              Stack(
                children: [
                  Visibility(
                      // visible: widget.bean.es == 1 && widget.bean.os != 0 && widget.bean.rbts != 3,
                      visible: BettingBizHelper.isBetOpening(widget.bean),
                      child: Row(
                        children: [
                          // CustomSportOddChangeAnimation(widget.bean,isOddsUp: isOddsUp, isIconVisible: isIconVisible,),
                          // Image.asset('assets/images/bet_slip/ic_odds_up.webp'),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(OddsUtil().covertOdds(double.parse(widget.bean.ov!)) ?? '',
                              style: ThemeService()
                                  .theme
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: ThemeService().colorScheme.secondary)),
                        ],
                      )),
                  Visibility(
                      // visible: widget.bean.rbts == 3 || widget.bean.es == 2 || widget.bean.os == 0,
                      visible: BettingBizHelper.isBetClosed(widget.bean),
                      child: CustomText(
                        widget.bean.rbts == 3 ? S.current.bet_stop : S.current.bet_settled,
                        style: const TextStyle(color: AppThemes.reverseStateColor),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleState() {
    if (widget.bean.showState == 0) {
      return Visibility(
        ///滚球 1:早盘 2:今日 3:滚球
        visible: widget.bean.m == 3,
        child: Container(
          margin: const EdgeInsets.only(left: 12),
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          decoration: BoxDecoration(
              color: AppThemes.reverseStateColor, borderRadius: BorderRadius.circular(2)),
          child: CustomText(
            S.current.bet_live,
            style: ThemeService().textTheme.bodySmall,
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 12),
        child: CustomAssetIcon(
            name: widget.bean.showState == 1
                ? 'assets/images/bet_slip/ic_bet_done.png'
                : 'assets/images/bet_slip/ic_bet_wrong.webp'),
      );
    }
  }
}
