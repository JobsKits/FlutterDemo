import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/yulecheng/casino_record_model.dart';
import '../../../model/yulecheng/gamelist_model.dart';
import '../../../routes/routes.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/route_util.dart';
import '../common_helper/betting_biz_helper.dart';
import '../common_model/betting_record_api_model.dart';
import '../common_model/betting_record_prove_api_model.dart';

///娱乐城 详情 对话框中的 相关逻辑处理， 交互处理
mixin CustomCasinoDetailDialogBizMixin {

  final ScrollController scrollController = ScrollController();
  void tooltipOffset(GlobalKey key) {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    // 获取组件大小
    Size size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    log("CasinoDialog...size...$size");
    log("CasinoDialog...offset...$offset");
  }

  void onScrollViewHeight(bool isOpen) {
    if(!isOpen){
      return;
    }
    scrollController.animateTo(
      400, // Assuming each item has a height of 50.0
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutQuart,
    );
  }

  ///拷贝and提示。点击顶部的 拷贝 链接
  void onClickCopyAndTooltip(String? content) {
    BettingBizHelper.onClickCopyToast(content, showToast: false);
  }

  ///跳转到 目标游戏页面
  void onClickToGamePage(BettingRecordApiModel data) {
    // YuLeChengChangGuanModel items = YuLeChengChangGuanModel(id: data.,name: ,icon: );
    // RouteUtil.pushToView(Routes.yulechengCategoryPage,
    //     arguments: {"model": items, "fromChangguanPage": 4});

    // id: temModel.id,
    // platformId: temModel.platformId,
    // name: temModel.name,
    // gameId: temModel.gameId,
    // img: temModel.img,

    // 模拟测试一下小游戏，小游戏只需要id
    GameListModel items = GameListModel(
      id: "",
      gameId: data.gameCode ?? "",
      platformId: data.platformId ?? "",
      gameType: data.gameClass ?? "",
      img: data.icon ?? "",
      name: data.gameName ?? "",
      createdAt: 0,
      sorting: 0,
      isHot: 1,
      isNew: 2,
      isFav: 0,
    );
    //原创游戏
    //id 27061519494002
    //platformId 801
    //name Dice
    //gameType 8
    //gameId dice
    //img images/SG/%lang%/dice.webp
    //platformName Original
    //maintained 1

    RouteUtil.popView();
    RouteUtil.pushToView(Routes.yulechengDetailPage, arguments: {
      "model": items,
      "prePage": "lobbyPage",
      "platformName": data.platformName,
    });
  }

  final proveApiModelObs = BettingRecordProveApiModel().obs;

  BettingRecordProveApiModel get proveApiModel => proveApiModelObs.value;

  /// 记录对话框详情，可证明公平
  Future<void> loadRecordProve({String? id, String? uid}) async {
    await ApiService.instance.getRecordProve(
      id: id ?? "",
      uid: uid ?? "",
      success: (BettingRecordProveApiModel apiModel) {
        proveApiModelObs.value = apiModel;
      },
      fail: (bool isConnect, String? message, candy) {},
    );
  }

  double diceProcessWidth = 0;

  void getDiceProcessWidth(GlobalKey key) {
    // final RenderObject? renderBox  = key.currentContext?.findRenderObject();
    //
    // // 获取组件大小
    // if(renderBox!=null){
    //   Size size = renderBox.size;
    //   print('Size: $size');
    // }
    RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    diceProcessWidth = size.width;
  }

  ///获取偏移
  double getDiceBlockLeftOffset(
      {String? value, double? defaultValue = 50, double blockSize = 0, double margin = 12}) {
    // double realProcessWidth = Get.width - 16 * 2 - 22 * 2;
    // double realProcessWidth = ScreenUtil().screenWidth - (16 * 2).w - (22 * 2).w;
    // double realProcessWidth2 = getDiceProcessWidth(globalKeyDiceProcess);
    // log("realProcessWidth...$realProcessWidth...realProcessWidth2...$realProcessWidth2");
    var valueDouble = double.tryParse(value ?? defaultValue.toString());
    double finalOffset = diceProcessWidth * (valueDouble ?? 0) / 100;
    return finalOffset - blockSize / 2 + margin;
  }

  ///获取偏移 ,0 到 100， 千化 100,10000
  int getDiceProcessFlex({String? value, double? defaultValue = 50, bool isLeft = true}) {
    // double realProcessWidth = Get.width - 16 * 2 - 20 * 2;
    var valueDouble = double.tryParse(value ?? defaultValue.toString());
    int flex = ((valueDouble ?? 0) * 100).toInt();
    return isLeft ? flex : 10000 - flex;
  }
}
