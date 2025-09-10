import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/api/lottery_api.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/area.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/ball.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/data.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/lottery_handicp_model.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_odds_info_model/lottery_odds_info_model.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_odds_info_model/sub_play.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_odds_nums_model.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_subplay_model/k3.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_subplay_model/lottery_subplay_model.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/views/lottery_betrecord_page.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/views/lottery_handicap_page.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/views/lottery_results_page.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/helpers/helperPlay.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/services.dart' show rootBundle;

class LotteryController extends GetxController {
  late String? title;

  RxInt catIndex1 = 0.obs;
  RxInt catIndex2 = 0.obs;
  List<String> categories1 = ['投注', '开奖结果', '投注单'];
  RxList<String> betList = [
    '00001',
    'cp21313213',
    'sunm',
    'big',
    'single',
    '00001',
    'cp21313213',
    'sunm',
    'big',
    'single'
  ].obs;
  late ScrollController betScrollController;

  GlobalKey tabBarKey = GlobalKey(); //tab的key
  GlobalKey titleKey = GlobalKey(); //标题栏的key

  RxInt currentTabIndex = 0.obs; //当前tab的index，0为首页
  int currentCategoryPage = 1; //当前分类的页数

  late TabController tabController;
  final scrollController = ScrollController();

  final menuActive = (-1).obs;
  final menuActiveDetail = ('').obs;

  final subPlay = LotterySubplayModel().obs;
  final menus = <LotteryHandicpModel>[].obs;

  final numsModel = LotteryOddsNumsModel(data: {}).obs;
  final oddsInfo = <LotteryOddsInfoModel>[].obs;

  List<LotteryHandicpModel> selectList = [];

  /// 筹码展示状态
  final chipStatus = false.obs;

  /// 筹码展示状态
  final showBetStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    reqLotteryData();
    requestOdds();
    requestOpen();
    requestod();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  requestOdds() async {
    Map playPricingPlan = {};
    int cmdId = 330951;
    int playId = 237; // 分分快三
    int roomLevel = 0;
    int tid = 3;
    var data = [playId, roomLevel, tid];
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
    );
    print('res data: ${res.data}');
    // debugPrint('res data: ${res.data}');
    // LotteryOddsNumsModel
    numsModel.value = LotteryOddsNumsModel.fromJson(res.data);
    print({' ============= ${numsModel.value.toJson()}'});
    // if (res.type == NetworkService.networkTypeSuccess) {
    //   String key = '${playId}-${roomLevel}';
    //   playPricingPlan[key] = res.data;

    //   int subPlayId = 237000;
    //   String ballCmd = '18';
    //   String priceKey = '${subPlayId}${ballCmd}';
    //   Map priceMap = playPricingPlan[key][priceKey];
    //   print('price: ${priceMap['0']}');
    // }
  }

  requestod() async {
    Map playDetails = {};
    int cmdId = 320142;
    int tid = 3;
    int playId = 237; // 分分快三
    var data = [tid, playId];
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
    );
    print('320142 data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      // oddsInfo.value = LotteryOddsInfoModel.fromJson(res.data) as List<LotteryOddsInfoModel>;

      oddsInfo.value = res.data
          .map<LotteryOddsInfoModel>(
              (item) => LotteryOddsInfoModel.fromJson(item))
          .toList();

      // if (res.data is List) {
      //   for (var info in res.data) {
      //     playDetails[info['play_id']] = info;
      //   }
      // }

      // int subPlayId = 237000; // 和值
      // Map playDetail = playDetails[subPlayId];
      // print('玩法:${playDetail['play_cname']}');
      // print('sub_play_plan_num:${playDetail['sub_play_plan_num']}');
      // print('sub_play_plan_num_win:${playDetail['sub_play_plan_num_win']}');
      // print('base_note_num:${playDetail['base_note_num']}');
      // if (playDetail['subPlay'] is List) {
      //   for (var subInfo in playDetail['subPlay']) {
      //     print('\t玩法:${subInfo['play_cname']}, ${subInfo['play_id']}');
      //     print('\tsub_play_plan_num:${subInfo['sub_play_plan_num']}');
      //     print('\tsub_play_plan_num_win:${subInfo['sub_play_plan_num_win']}');
      //     print('\tbase_note_num:${subInfo['base_note_num']}');
      //     print('\t-----');
      //   }
      // }
    }
  }

  requestOpen() async {
    int cmdId = 320539;
    var data = {
      'tid': AppConfigs.tid,
      'play_name': 'K31FCT3',
      'count': 30,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    print('320539 data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        for (var termInfo in res.data) {
          int termCode = termInfo['term_code'];
          String termStr = termCode.toString();
          if (termStr.length >= 10) {
            termStr = termStr.substring(4);
          }
          print('第$termStr期');
          print('开奖号码: ${termInfo['win_code']}');
          print('-----');
        }
      }
    }
  }

  /// 请求彩票的数据列表
  reqLotteryData() async {
    await loadSubPlay();
    await loadLotteryMenu();
  }

  loadSubPlay() async {
    String jsonString =
        await rootBundle.loadString('assets/datas/SubPlay.json');
    final jsonResponse = json.decode(jsonString);
    final res = LotterySubplayModel.fromJson(jsonResponse);
    subPlay.value = res;
  }

  loadLotteryMenu() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/datas/BallArea.json');
      final jsonResponse = json.decode(jsonString) as List;
      final menuList = jsonResponse
          .map<LotteryHandicpModel>(
              (item) => LotteryHandicpModel.fromJson(item))
          .toList();
      menus.value = menuList;
    } catch (e) {
      // Handle error
      print("Error loading lottery menu: $e");
    }
  }

  handleLeftMednuActive(int value, String item) {
    if (item == "-1") {
      return;
    }
    menuActive.value = value;
    menuActiveDetail.value = item;
    lhcSpecialWidget(item);
  }

  lhcSpecialWidget(String item) {
    if (item == "投注") {
      return LotteryHandicapPage(menus: menus);
    }

    if (item == "开奖结果") {
      return const LotteryResultsPage();
    }

    if (item == "投注单") {
      return const LotteryBetRecrodPage();
    }
  }

  // 打开筹码分布
  handleOpenChip() {
    chipStatus.value = !chipStatus.value;
  }

  // 打开筹码分布
  handleOpenBet() {
    showBetStatus.value = !showBetStatus.value;
  }

  String calculatingSumOddsEven(LotteryOddsInfoModel model, String playId) {
    // getPlayK3HeZhiBallOdds
    SubPlay? subplay =
        model.subPlay!.firstWhereOrNull((e) => e.playId.toString() == playId);
    int planNum = subplay?.subPlayPlanNum ?? 0;
    int planNumWin = subplay?.subPlayPlanNumWin ?? 0;
    int price = subplay?.oddsRatio ?? 0; // ballCmd = '19'
    int rebate = 1000; // getBaseRebate
    int slider = subplay?.oddsRatio ?? 0; // // 选号界面滑块
    int value = rebate - slider;
    int baseNoteNum = subplay?.baseNoteNum ?? 0;

    double min = getPlayK3HeZhiBallOdds(
        planNum, planNumWin, price, rebate, value, baseNoteNum);

    // planNum = model.subPlayPlanNum ?? 0;
    // planNumWin = model.subPlayPlanNumWin ?? 0;
    // price = model.oddsRatio ?? 0; // ballCmd = '19'
    // baseNoteNum = model.baseNoteNum ?? 0;
    // double max = getPlayK3HeZhiBallOdds(
    //     planNum, planNumWin, price, rebate, value, baseNoteNum);
    // print('$min');
    // return '$min-$max';
    return '$min';
  }

  String calculatingAllOddsEven(int playid, String name, int base_note_num,
      int sub_play_plan_num, int sub_play_plan_num_win) {
    // test('计算和值以外赔率', () async {
    // Method > 0
    // 数字彩res_id和ballId为0 getPlayK3SubplayOdds
    // Map playDetail = {
    //   'play_id': 237100,
    //   'play_cname': '二同号单选',
    //   'base_note_num': 1,
    //   'sub_play_plan_num': 216,
    //   'sub_play_plan_num_win': 3,
    // };
    Map playDetail = {
      'play_id': playid,
      'play_cname': name,
      'base_note_num': base_note_num,
      'sub_play_plan_num': sub_play_plan_num,
      'sub_play_plan_num_win': sub_play_plan_num_win,
    };
    int price = 900;
    int rebate = 1000;
    int rebateValue = 0;
    // computeOdds('A', )
    double ret = computeOddsA(
        price,
        rebate,
        rebateValue,
        playDetail['base_note_num'],
        playDetail['sub_play_plan_num'],
        playDetail['sub_play_plan_num_win']);
    print('ret = $ret');
    //double odd = 72;
    return '$ret';
  }
  // });
}
