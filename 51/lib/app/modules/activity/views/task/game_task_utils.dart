// 游戏任务工具
// ignore_for_file: non_constant_identifier_names

import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/constants/game_constants.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_tiyu_app/app/data/tenant_bean.dart';

import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import '../../../home/controllers/new_home_controller.dart';
import '../../controllers/controller_task_page.dart';
import 'package:get/get.dart';
// import 'package:flutter_tiyu_app/kernel/configs/elot_type.dart';

class GameTaskUtils {
  // 电子路径
  static String upgImageDeal(GameTaskItemBean itemData,
      {required String imgDomain}) {
    String lang = AppConfigs.lang == 'cn' ? 'cn' : 'en';
    return '${imgDomain}/staticQ/dianzi/${itemData.terrace_id}/${lang}/game_${itemData.play_id}.png';
  }

  static String logoUrl() {
    String url = '';
    List<LogoManage> logoManage =
        TenantManager.instance.tenantBean?.logoManage ?? [];

    List<LogoManage> tmp = logoManage
        .where((ele) => ele.messageId == 28 && (ele.picAddr ?? '').isNotEmpty)
        .toList();

    if (tmp.isNotEmpty) {
      url = tmp[0].picAddr!;
    }

    return url;
  }

  static String lotteryImg(GameTaskItemBean itemData) {
    var play_id = itemData.play_id;
    var playid = itemData.playid;
    var playId = itemData.playId;

    List<AllLotteryDataItemBean> allLotteryData =
        TenantManager.instance.allLotteryData;

    final id = play_id ?? (playid ?? playId);
    // Map<String, dynamic>? play = GameUtils.getPlayInfo('$id');
    // final isXY = play != null ? playIsXY(play: play) : false;

    List<AllLotteryDataItemBean> findList = allLotteryData
        .where((ele) => int.parse('${ele.play_id}') == int.parse('${id}'))
        .toList();

    return findList.isNotEmpty ? (findList[0].img_url ?? '').trim() : '';
  }

  // 构建游戏任务icon
  static String buildIconUrl(GameTaskItemBean itemData,
      {required String imgDomain}) {
    String iconUrl = itemData.icon_url ?? '';
    String? imgUrl = itemData.imgUrl;
    if (itemData.terrace_id == 593) {
      return iconUrl.isEmpty
          ? upgImageDeal(
              itemData,
              imgDomain: imgDomain,
            )
          : iconUrl;
    }

    if (itemData.terrace_id == 921) {
      return logoUrl();
    }

    String curLotteryImg = lotteryImg(itemData);

    return iconUrl.isEmpty
        ? (curLotteryImg.isEmpty ? imgUrl! : curLotteryImg)
        : iconUrl;
  }

  // ---------------------------------------------------------
  // 处理IM体育在不同代理盘下的名称显示
  // 主盘取租户名字，tenant_name
  // 代理盘1取  tenant_des
  // 代理盘2取 xmpp
  static formatIMSport(String name) {
    int? proxy = TenantManager.instance.tenantBean!.proxy;
    String reName = name;

    if (name == 'IM体育') {
      if (proxy == 0) {
        reName = TenantManager.instance.tenantBean?.tenant?.tenantName ?? '';
      } else if (proxy == 1) {
        reName = TenantManager.instance.tenantBean?.tenant?.tenantDes ?? '';
      } else if (proxy == 2) {
        reName = TenantManager.instance.tenantBean?.tenant?.xmpp ?? '';
      }
    }

    return reName;
  }

  // 构建标题
  static String buildTitle(GameTaskItemBean itemData) {
    String standara_name = itemData.standara_name ?? '';

    return standara_name.isEmpty
        ? formatIMSport(itemData.headName!)
        : standara_name;
  }

  // 构建描述
  static String buildDesc(GameTaskItemBean itemData) {
    String explains = itemData.explains ?? '';
    String? describe = itemData.describe;

    String prefix = explains.isEmpty ? describe! : explains;

    return '${prefix} ${parseNumber(itemData.completed)}/${parseNumber(itemData.upToStandard)}';
  }
  // -----------------------------------------------------

  /// 跳转到首页
  static jumpToHomeGame(String pageKey) {
    TabsController tabController = Get.find();
    NewHomeController homeController = Get.find();

    tabController.jumpToPage(0);
    homeController.clickAll(pageKey);
  }

  // 打开游戏
  static gameJump(GameTaskItemBean item) async {
    NewHomeController homeController = Get.find();
    ControllerTaskPage taskController = Get.find();

    if (taskController.isClickJump.value) {
      return;
    }

    try {
      taskController.setIsClickJump(true);
      await homeController.openGame(
        item,
        playId: int.parse('${item.play_id}'),
        playName: '${item.play_name}',
        playCName: '${item.play_cname}',
        gameType: item.play_id,
        originState: item.state!,
        upperPlayId: null,
        gtype: item.gtype,
      );
    } finally {
      taskController.setIsClickJump(false);
    }
  }

  // 页面跳转
  static linkJump(GameTaskItemBean item) {
    int terrace_id = item.terrace_id!;
    int play_id = item.play_id!;
    String terrace_name = item.terrace_name ?? '';
    String play_cname = item.play_cname ?? '';
    String headName = item.headName ?? '';

    // print('======> ${terrace_id}');
    // 负数
    if (terrace_id.round() < 0) {
      if (play_id == -1) {
        if (terrace_id == -1) {
          // 彩票
          jumpToHomeGame(GameTypeConstants.lottery);
          // terrace_name.contains('彩票')
          return;
        }

        if (terrace_id == -2) {
          // 棋牌
          jumpToHomeGame(GameTypeConstants.chess);
        } else if (terrace_id == -3) {
          // 电子
          jumpToHomeGame(GameTypeConstants.electronic);
        } else if (terrace_id == -4) {
          // 真人
          jumpToHomeGame(GameTypeConstants.live);
        } else if (terrace_id == -5) {
          // 捕鱼
          jumpToHomeGame(GameTypeConstants.fishing);
        } else if (terrace_id == -6) {
          // 体育
          jumpToHomeGame(GameTypeConstants.sports);
        }
      } else {
        // 匹配默认选中的哪个，和chomeelot.js中的 gamesType 中的死值的数组的下标对应起来
        int index = 0;
        if (play_cname.contains('蛋蛋')) {
          index = 1;
        } else if (play_cname.contains('赛车')) {
          index = 2;
        } else if (play_cname.contains('时时彩')) {
          index = 3;
        } else if (play_cname.contains('11选5')) {
          index = 4;
        } else if (play_cname.contains('六合彩')) {
          index = 5;
        } else if (play_cname.contains('快3')) {
          index = 6;
        } else if (play_cname.contains('飞艇')) {
          index = 7;
        } else if (play_cname.contains('澳洲') || play_cname.contains('台湾')) {
          index = 8;
        }

        // if (index > 0) {
        //   gameStore.changeSelectedType(index);
        // }

        if (headName.contains('彩票') || terrace_name.contains('彩票')) {
          Map<String, dynamic>? play = GameUtils.getPlayInfo('$play_id');

          // 检测彩票是否可玩
          //  testCanPlay(play);
        } else if (terrace_name.contains('棋牌')) {
          jumpToHomeGame(GameTypeConstants.chess);
        }
      }
    } else {
      if (play_id == -1) {
        String tab = GameTypeConstants.lottery;
        if (terrace_name.contains('棋牌')) {
          tab = GameTypeConstants.chess;
        } else if (terrace_name.contains('电子')) {
          tab = GameTypeConstants.electronic;
        } else if (terrace_name.contains('捕鱼')) {
          tab = GameTypeConstants.fishing;
        } else if (terrace_name.contains('体育') ||
            terrace_name.contains('赛马') ||
            terrace_name.contains('球')) {
          tab = GameTypeConstants.sports;
        } else if (terrace_name.contains('真人') || terrace_name.contains('视讯')) {
          tab = GameTypeConstants.live;
        }

        // 具体tab 那一层未接入 terrace_id ？？？
        jumpToHomeGame(tab);
      } else {
        gameJump(item);
      }
    }
  }
}
