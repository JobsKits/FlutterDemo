import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/model/yulecheng/big_wins_model.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_race_api_model.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// TODO： 竞赛排行榜
class CompetitionList extends StatelessWidget {

  final List<BettingRaceApiModel> infos;
  final bool isLoading;
  final bool firstTransparent;
  final Function callBack;

  CompetitionList({
      super.key,
      required this.infos,
      this.isLoading = false,
      this.firstTransparent = true,
      required this.callBack
  });

  @override
  Widget build(BuildContext context) {
    if(infos.isEmpty && !isLoading) {
      return const CustomEmptyWidget().paddingTop(AppValues.largePadding * 5);
    }
    return SizedBox();
  }

}
