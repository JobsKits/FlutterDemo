// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/configs/game3_config.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/utils/activity_manager.dart';
import "package:flutter_tiyu_app/constants/activity_constants.dart";

import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

/// 优惠活动的数据处理工具
class TakDataProcess {
  /// parseInt 方法
  static int parseInt(String str, [int radix = 10]) {
    // 清除开头和结尾的空格
    str = str.trim();

    // 处理基数
    if (radix < 2 || radix > 36) {
      throw ArgumentError('Radix must be between 2 and 36.');
    }

    // 检查字符串是否为空
    if (str.isEmpty) {
      return 0;
    }

    // 处理负号
    bool isNegative = false;
    if (str[0] == '-') {
      isNegative = true;
      str = str.substring(1);
    } else if (str[0] == '+') {
      str = str.substring(1);
    }

    // 解析数字
    int result = 0;
    for (int i = 0; i < str.length; i++) {
      int charCode = str.codeUnitAt(i);
      int digit;

      // 处理数字字符
      if (charCode >= 48 && charCode <= 57) {
        // '0' - '9'
        digit = charCode - 48;
      } else if (charCode >= 65 && charCode <= 90) {
        // 'A' - 'Z'
        digit = charCode - 55; // A=10, B=11, ..., Z=35
      } else if (charCode >= 97 && charCode <= 122) {
        // 'a' - 'z'
        digit = charCode - 87; // a=10, b=11, ..., z=35
      } else {
        break; // 一旦遇到非有效字符，就停止解析
      }

      // 检查基数范围
      if (digit >= radix) {
        break; // 超出基数范围，停止解析
      }

      result = result * radix + digit;
    }

    return isNegative ? -result : result;
  }

  /// 组装新的 Standara List
  static List<Map<String, dynamic>> getStandaraList(
    Map standara, {
    required String key,
    required Map<String, dynamic> itemBean,
    bool isRechargeGift = false,
  }) {
    List<Map<String, dynamic>> packList = [];
    List arr = [];
    List offset = []; // 充值金额与达标金额的差值
    final amount = int.parse((standara[key] ?? 0).toString()) / 1000;

    for (int i = 1; i <= 10; i++) {
      Map<String, dynamic> dataMap = {};
      String stan = 'standara$i';
      String standaraName = 'standara_name$i';
      String iconUrl = 'icon_url$i';
      String explains = 'explains$i';

      if (standara[stan] != '' && standara[stan] != null) {
        var listArr = standara[stan].split(':');
        var fractionAmount = double.parse(listArr[0].toString());
        dataMap['fraction'] = fractionAmount; // 达标
        dataMap['reward'] = double.parse(listArr[1].toString()); // 奖金
        dataMap['standara_name'] = standara[standaraName];
        dataMap['icon_url'] = standara[iconUrl];
        dataMap['explains'] = standara[explains];

        /// 101 活动有此逻辑
        /// 如果后台设置不能多重领取 则满足领取条件的选项走如下流程
        /// activity_standard 1非多重 0多重 recharge_type 0全部 1线下 2线上 3首充
        dataMap['activity_standard'] =
            double.parse((standara["activity_standard"] ?? '0').toString());
        dataMap['recharge_type'] =
            double.parse((standara['recharge_type'] ?? '0').toString());

        if (fractionAmount != 0) {
          arr.add(fractionAmount);
          var off = amount - fractionAmount;
          // 充值金额 - 达标金额
          if (isRechargeGift && off >= 0) {
            offset.add(off);
          }

          dataMap['isReceive'] = 0;
          dataMap['percentage'] = 0;
          dataMap['startTime'] = itemBean['eff_time'];
          dataMap['endTime'] = itemBean['exp_time'];
          dataMap[key] = standara[key];
          dataMap['index'] = i - 1;
          packList.add(dataMap);
        }
      }
    }

    for (int j = 0; j < arr.length; j++) {
      final item = arr[j];
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now < double.parse(itemBean['eff_time'].toString())) {
        packList[j]['isReceive'] = 3; // 即将开始
      } else {
        if (item <= amount) {
          packList[j]['percentage'] = 100;
          packList[j]['isReceive'] = 2; // 可领取
        } else {
          if (j == 0) {
            if (amount == 0) {
              packList[j]['percentage'] = 0;
            } else {
              final percentageData = amount / item * 100;
              packList[j]['percentage'] =
                  TakDataProcess.parseInt(percentageData.toString());
            }
          } else if (item > amount && amount > arr[j - 1]) {
            final percentageData =
                (amount - arr[j - 1]) / (item - arr[j - 1]) * 100;
            packList[j]['percentage'] =
                TakDataProcess.parseInt(percentageData.toString());
          }
        }
      }

      packList[j]['completed'] = amount < 0 ? 0 : amount;

      //  这一步没看明白，没有对应的数据看逻辑
      var receiveAmount = standara['receive_amount'];
      if (standara['receive_amount'] != null && receiveAmount is List) {
        receiveAmount.forEach((item) {
          var level = item['receive_level'] != null
              ? double.parse(item['receive_level'].toString())
              : 0;

          if (level - 1 == j) {
            packList[j]['isReceive'] = 1; // 已领取
          }
        });
      }
    }

    /// 如果后台设置不能多重领取 则满足领取条件的选项走如下流程
    /// activity_standard 1非多重 0多重 recharge_type 0全部 1线下 2线上 3首充
    if (isRechargeGift && itemBean['activity_standard'] == 1) {
      for (int i = 0; i < packList.length; i++) {
        var item = packList[i];

        // 如果是首充类型 最大领取后面的进度条设置0
        if (item['recharge_type'] == 3 && i >= offset.length) {
          item['percentage'] = 0;
        }
      }
    }

    // print('=======> ${packList[8]}');
    return packList;
  }

  /// 亏损救援金
  static List<Map<String, dynamic>> getStandaraReliefFundList(
    Map standara, {
    required String key,
    required Map<String, dynamic> itemBean,
    bool? isNew = false,
  }) {
    List<Map<String, dynamic>> packList = [];
    List arr = [];
    final amount = int.parse((standara[key] ?? 0).toString()) / 1000;
    int isMultiple = int.parse(itemBean['is_multiple'].toString());

    for (int i = 1; i <= 10; i++) {
      Map<String, dynamic> dataMap = {};
      String stan = 'standara$i';
      String standaraName = 'standara_name$i';
      String iconUrl = 'icon_url$i';
      String explains = 'explains$i';

      if (standara[stan] != '' && standara[stan] != null) {
        var listArr = standara[stan].split(':');
        var fractionAmount = double.parse(listArr[0].toString());
        dataMap['fraction'] = fractionAmount; // 达标
        dataMap['reward'] = double.parse(listArr[1].toString()); // 奖金
        dataMap['standara_name'] = standara[standaraName];
        dataMap['icon_url'] = standara[iconUrl];
        dataMap['explains'] = standara[explains];

        if (fractionAmount != 0) {
          arr.add(fractionAmount);
          dataMap['isReceive'] = 0;
          dataMap['percentage'] = 0;
          dataMap['startTime'] = itemBean['eff_time'];
          dataMap['endTime'] = itemBean['exp_time'];
          dataMap[key] = standara[key];
          dataMap['index'] = i - 1;
          packList.add(dataMap);
        }
      }
    }

    for (int j = 0; j < arr.length; j++) {
      final item = arr[j];
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now < double.parse(itemBean['eff_time'].toString())) {
        packList[j]['isReceive'] = 3; // 即将开始
      } else if (amount != 0) {
        if (item <= amount) {
          packList[j]['percentage'] = 100;
          if (isMultiple == 2) {
            packList[j]['isReceive'] = 2; // 可领取

            var logs = standara['logs'];
            if (logs is List && logs.isNotEmpty) {
              for (int m = 0; m < logs.length; m++) {
                int num = j + 1;
                if (logs[m]['receive_level'] == num) {
                  packList[j]['isReceive'] = 1;
                }
              }
            }
          } else {
            if (amount >= item) {
              packList[j]['isReceive'] = 2;
            }
          }
        } else {
          if (j == 0) {
            final percentageData = (amount / item) * 100;
            packList[j]['percentage'] =
                TakDataProcess.parseInt(percentageData.toString());
          } else if (item >= amount && amount >= arr[j - 1]) {
            final percentageData =
                ((amount - arr[j - 1]) / (item - arr[j - 1])) * 100;
            packList[j]['percentage'] =
                TakDataProcess.parseInt(percentageData.toString());

            if (isMultiple == 1) {
              packList[j]['isReceive'] =
                  int.parse(standara['count']) == 1 ? 1 : 2;
            }
          }
        }
      } else {}

      packList[j]['completed'] = amount < 0 ? 0 : amount;
    }
    if (packList.isNotEmpty) {
      var lastPackItem = packList[arr.length - 1];
      if (lastPackItem != null &&
          lastPackItem['fraction'] != null &&
          lastPackItem['fraction'] <= amount) {
        // isMultiple =1 才有领取最后一个
        if (isNew == true && isMultiple == 1) {
          packList[arr.length - 1]['isReceive'] = 2;
        }

        if (isNew == false) {
          packList[arr.length - 1]['isReceive'] = 2;
        }

        if (int.parse(standara['count'].toString()) >= 1) {
          packList[arr.length - 1]['isReceive'] = 1;
        }
      }
    }
    return packList;
  }

  ///  分享领工资
  static List<Map<String, dynamic>> getStandaraShareSalaryList(
    Map standara, {
    required String key,
    required Map<String, dynamic> itemBean,
  }) {
    List<Map<String, dynamic>> packList = [];
    List arr = [];
    final amount = int.parse((standara[key] ?? 0).toString());

    for (int i = 1; i <= 10; i++) {
      Map<String, dynamic> dataMap = {};
      String stan = 'standara$i';
      String standaraName = 'standara_name$i';
      String iconUrl = 'icon_url$i';
      String explains = 'explains$i';

      if (standara[stan] != '' && standara[stan] != null) {
        var listArr = standara[stan].split(':');
        var fractionAmount = double.parse(listArr[0].toString());
        dataMap['fraction'] = fractionAmount; // 达标
        dataMap['reward'] = double.parse(listArr[1].toString()); // 奖金
        dataMap['standara_name'] = standara[standaraName];
        dataMap['icon_url'] = standara[iconUrl];
        dataMap['explains'] = standara[explains];

        if (fractionAmount != 0) {
          arr.add(fractionAmount);
          dataMap['isReceive'] = 0;
          dataMap['percentage'] = 0;
          dataMap['startTime'] = itemBean['eff_time'];
          dataMap['endTime'] = itemBean['exp_time'];
          dataMap[key] = standara[key];
          dataMap['index'] = i - 1;
          packList.add(dataMap);
        }
      }
    }

    for (int j = 0; j < arr.length; j++) {
      final item = arr[j];

      if (item <= amount) {
        packList[j]['percentage'] = 100;
        packList[j]['isReceive'] = 2;
      }

      if (j == 0) {
        if (amount == 0) {
          packList[j]['percentage'] = 0;
        } else {
          final percentageData = amount / item * 100;
          packList[j]['percentage'] =
              TakDataProcess.parseInt(percentageData.toString());

          if (packList[j]['percentage'] > 100) {
            packList[j]['percentage'] = 100;
          }
        }
      } else if (item > amount && amount > arr[j - 1]) {
        final percentageData =
            (amount - arr[j - 1]) / (item - arr[j - 1]) * 100;
        packList[j]['percentage'] =
            TakDataProcess.parseInt(percentageData.toString());
      }

      packList[j]['completed'] = amount < 0 ? 0 : amount;

      //  这一步没看明白，没有对应的数据看逻辑
      var receiveAmount = standara['receive_amount'];
      if (standara['receive_amount'] != null && receiveAmount is List) {
        receiveAmount.forEach((item) {
          var level = item['receive_level'] != null
              ? double.parse(item['receive_level'].toString())
              : 0;

          if (level - 1 == j) {
            packList[j]['isReceive'] = 1; // 已领取
          }
        });
      }
    }

    return packList;
  }

  /// standara 数据处理中心
  static List<Map<String, dynamic>>? standaraProcess(
    Map? standara, {
    required Map<String, dynamic> itemBean,
  }) {
    int type = itemBean['type'];
    ActivityConfigurationInt activeConfiguration =
        ActivityManager.instance.activeConfiguration;

    List<Map<String, dynamic>>? resultList;

    switch (type.toInt()) {
      // 充值大礼包
      case ActivityConstants.ACTIVITY_TYPE_101:
        if (activeConfiguration['2']! > 0 && standara != null) {
          resultList = TakDataProcess.getStandaraList(
            standara,
            key: 'chargeAmount',
            itemBean: itemBean,
            isRechargeGift: true,
          );
        }
      // 天天得意金
      case ActivityConstants.ACTIVITY_TYPE_102:
        if (activeConfiguration['3']! > 0 && standara != null) {
          resultList = TakDataProcess.getStandaraList(
            standara,
            key: 'PlayAmount',
            itemBean: itemBean,
          );
        }

      // 亏损救援金
      case ActivityConstants.ACTIVITY_TYPE_103:
        if (activeConfiguration['5']! > 0 && standara != null) {
          resultList = TakDataProcess.getStandaraReliefFundList(
            standara,
            key: 'Profit',
            itemBean: itemBean,
          );
        }

      // 新增的 救援金活动
      case ActivityConstants.ACTIVITY_TYPE_203:
        if (activeConfiguration['83']! > 0 && standara != null) {
          resultList = TakDataProcess.getStandaraReliefFundList(
            standara,
            key: 'Profit',
            itemBean: itemBean,
            isNew: true,
          );
        }

      // 分享领工资
      case ActivityConstants.ACTIVITY_TYPE_106:
        if (activeConfiguration['4']! > 0 && standara != null) {
          resultList = TakDataProcess.getStandaraShareSalaryList(
            standara,
            key: 'record',
            itemBean: itemBean,
          );
        }

      // 游戏任务
      case ActivityConstants.ACTIVITY_TYPE_110:
        if (activeConfiguration['22']! > 0) {
          resultList = [];
        }

      // 虚拟币充值
      case ActivityConstants.ACTIVITY_TYPE_111:
        if (activeConfiguration['32']! > 0 && standara != null) {
          resultList = TakDataProcess.getStandaraList(
            standara,
            key: 'virtualAmount',
            itemBean: itemBean,
          );
        }

      // 会员任务
      case ActivityConstants.ACTIVITY_TYPE_112:
        if (activeConfiguration['35']! > 0) {
          resultList = [];
        }

      // 活动奖金
      case ActivityConstants.ACTIVITY_TYPE_113:
        if (activeConfiguration['50']! > 0) {
          resultList = [];
        }

      // 日常任务
      case ActivityConstants.ACTIVITY_TYPE_204:
        if (activeConfiguration['50']! > 0) {
          resultList = [];
        }
    }

    return resultList;
  }

  /// ------------------------------------------------------------
  static String getUserTaskTitle(MemberTaskItemBean item) {
    String title = '';
    var statProject = item.statProject;
    String needNumber = parseNumber((item.needNumber ?? 0) / 1000);
    String days = parseNumber(item.days);

    switch (statProject) {
      case 1:
        title = '累计充值${needNumber}';
        break;
      case 2:
        title = '累计充值${days}天';
        break;
      case 3:
        title = '连续充值${days}天';
        break;
      case 4:
        title = '首充${needNumber}';
        break;
      case 5:
        title = '单日首充${needNumber}';
        break;
      case 101:
        title = '累计打码${needNumber}';
        break;
      case 102:
        title = '累计彩票打码${needNumber}';
        break;
      case 103:
        title = '累计电子打码${needNumber}';
        break;
      case 104:
        title = '累计真人打码${needNumber}';
        break;
      case 105:
        title = '累计体育打码${needNumber}';
        break;
      case 106:
        title = '累计捕鱼打码${needNumber}';
        break;
      case 107:
        title = '累计棋牌打码${needNumber}';
        break;
      case 108: // hashgame
        title = '累计hashgame打码${needNumber}';
        break;
      case 111:
        title = '累计打码${days}天';
        break;
      case 112:
        title = '累计彩票打码${days}天';
        break;
      case 113:
        title = '累计电子打码${days}天';
        break;
      case 114:
        title = '累计真人打码${days}天';
        break;
      case 115:
        title = '累计体育打码${days}天';
        break;
      case 116:
        title = '累计捕鱼打码${days}天';
        break;
      case 117:
        title = '累计棋牌打码${days}天';
        break;
      case 118:
        title = '累计hashgame打码${days}天';
        break;
      case 121:
        title = '连续打码${days}天';
        break;
      case 122:
        title = '连续彩票打码${days}天';
        break;
      case 123:
        title = '连续电子打码${days}天';
        break;
      case 124:
        title = '连续真人打码${days}天';
        break;
      case 125:
        title = '连续体育打码${days}天';
        break;
      case 126:
        title = '连续捕鱼打码${days}天';
        break;
      case 127:
        title = '连续棋牌打码${days}天';
        break;
      case 128:
        title = '连续hashgame打码${days}天';
        break;
    }

    return title.isEmpty ? item.standara_name! : title;
    // return (item.standara_name ?? '').isEmpty ? title : item.standara_name!;
  }

  static String getUserTaskExplains(MemberTaskItemBean item) {
    String? explains = item.explains;

    String title = '';

    List<String> dateArr = (item.statDateTypeDetail ?? '').split(':');
    const weekObj = {
      '1': '一',
      '2': '二',
      '3': '三',
      '4': '四',
      '5': '五',
      '6': '六',
      '7': '日',
    };

    switch (item.statDateType) {
      case 1:
        title = '每日';
        break;
      case 2:
      case 3:
        String startTime = DateTimeUtils.formatTimestamp(int.parse(dateArr[0]),
            temp: 'yyyy/MM/dd');
        String endTime = DateTimeUtils.formatTimestamp(int.parse(dateArr[1]),
            temp: 'yyyy/MM/dd');

        title = '${startTime}-${endTime}';
        break;
      case 4:
        title = '每周${weekObj[item.statDateTypeDetail.toString()]}';
        break;
      case 5:
        title = '每月${item.statDateTypeDetail}日';
        break;
    }

    return (explains ?? '').isEmpty ? title : explains!;
  }

  static String getUserTaskScope(
    MemberTaskItemBean item,
    String explains,
    num fraction,
  ) {
    String introText = '';
    int statProject = item.statProject!;

    if ([1, 2, 3, 4, 5].contains(statProject)) {
      List<String> missionScopeArr = (item.missionScope ?? '').split('，');

      if (missionScopeArr[0].contains('线上充值')) {
        introText = '线上充值';
      }
      if (missionScopeArr[0].contains('线下充值')) {
        introText = "${introText}${introText.isNotEmpty ? ',' : ' '}线下充值";
      }
      if (missionScopeArr[0].contains('手工充值')) {
        introText = "${introText}${introText.isNotEmpty ? ',' : ' '}手工充值";
      }
    }

    String gamesArr = (item.playNames ?? '')
        .split(',')
        .where((item) => item.isNotEmpty)
        .toList()
        .join(',');

    final missionScope = {
      1: '会员须${introText}，${explains}充值，累计充值金额：${fraction}，满足要求可领取彩金奖励。',
      2: '会员须${introText}，${explains}充值，充值金额：${fraction}，累计充值天数：${item.days}，满足要求可领取彩金奖励。',
      3: '会员须${introText}，${explains}充值，单日充值金额：${fraction}，连续充值天数：${item.days}，满足要求可领取彩金奖励。',
      4: '会员须${introText}，${explains}充值，首充金额：${fraction}，满足要求可领取彩金奖励。',
      5: '会员须${introText}，${explains}充值，单日首充金额：${fraction}，满足要求可领取彩金奖励。',
      101: '会员须在${explains}投注${gamesArr}的游戏，累计打码金额：${fraction}，满足要求可领取彩金奖励。',
      102:
          '会员须在${explains}投注${gamesArr}的游戏，累计彩票打码金额：${fraction}，满足要求可领取彩金奖励（不包含已撤单的彩票投注）。',
      103: '会员须在${explains}投注${gamesArr}的游戏，累计电子打码金额：${fraction}，满足要求可领取彩金奖励。',
      104: '会员须在${explains}投注${gamesArr}的游戏，累计真人打码金额：${fraction}，满足要求可领取彩金奖励。',
      105: '会员须在${explains}投注${gamesArr}的游戏，累计体育打码金额：${fraction}，满足要求可领取彩金奖励。',
      106: '会员须在${explains}投注${gamesArr}的游戏，累计捕鱼打码金额：${fraction}，满足要求可领取彩金奖励。',
      107: '会员须在${explains}投注${gamesArr}的游戏，累计棋牌打码金额：${fraction}，满足要求可领取彩金奖励。',
      108: '会员须在${explains}投注${gamesArr}的游戏，累计原创打码金额：${fraction}，满足要求可领取彩金奖励。',
      111:
          '会员须在${explains}投注${gamesArr}的游戏，打码金额：${fraction}，打码天数${item.days}天，满足要求可领取彩金奖励。',
      112:
          '会员须在${explains}投注${gamesArr}的游戏，彩票打码金额：${fraction}，累计彩票打码天数${item.days}天，满足要求可领取彩金奖励。',
      113:
          '会员须在${explains}投注${gamesArr}的游戏，电子打码金额：${fraction}，累计电子打码天数${item.days}天，满足要求可领取彩金奖励。',
      114:
          '会员须在${explains}投注${gamesArr}的游戏，真人打码金额：${fraction}，累计真人打码天数${item.days}天，满足要求可领取彩金奖励。',
      115:
          '会员须在${explains}投注${gamesArr}的游戏，体育打码金额：${fraction}，累计体育打码天数${item.days}天，满足要求可领取彩金奖励。',
      116:
          '会员须在${explains}投注${gamesArr}的游戏，捕鱼打码金额：${fraction}，累计捕鱼打码天数${item.days}天，满足要求可领取彩金奖励。',
      117:
          '会员须在${explains}投注${gamesArr}的游戏，棋牌打码金额：${fraction}，累计棋牌打码天数${item.days}天，满足要求可领取彩金奖励。',
      118:
          '会员须在${explains}投注${gamesArr}的游戏，原创打码金额：${fraction}，累计原创打码天数${item.days}天，满足要求可领取彩金奖励。',
      121:
          '会员须在${explains}投注${gamesArr}的游戏，单日打码金额：${fraction}，连续打码天数${item.days}天，满足要求可领取彩金奖励。',
      122:
          '会员须在${explains}投注${gamesArr}的游戏，单日彩票打码金额：${fraction}，连续彩票打码天数${item.days}天，满足要求可领取彩金奖励。',
      123:
          '会员须在${explains}投注${gamesArr}的游戏，单日电子打码金额：${fraction}，连续电子打码天数${item.days}天，满足要求可领取彩金奖励。',
      124:
          '会员须在${explains}投注${gamesArr}的游戏，单日真人打码金额：${fraction}，连续真人打码天数${item.days}天，满足要求可领取彩金奖励。',
      125:
          '会员须在${explains}投注${gamesArr}的游戏，单日体育打码金额：${fraction}，连续体育打码天数${item.days}天，满足要求可领取彩金奖励。',
      126:
          '会员须在${explains}投注${gamesArr}的游戏，单日捕鱼打码金额：${fraction}，连续捕鱼打码天数${item.days}天，满足要求可领取彩金奖励。',
      127:
          '会员须在${explains}投注${gamesArr}的游戏，单日棋牌打码金额：${fraction}，连续棋牌打码天数${item.days}天，满足要求可领取彩金奖励。',
      128:
          '会员须在${explains}投注${gamesArr}的游戏，单日hashgame打码金额：${fraction}，连续hashgame打码天数${item.days}天，满足要求可领取彩金奖励。',
    };

    return missionScope[statProject] ?? '';
  }

  /// 解析会员任务的数据
  static List<StandaraListBean> parseUserTaskData(
      List<MemberTaskItemBean> taskData) {
    List<StandaraListBean> resultList = [];

    List<int> projectIdList = [1, 4, 5, 101, 102, 103, 104, 105, 106, 107, 108];
    for (int i = 0; i < taskData.length; i++) {
      MemberTaskItemBean item = taskData[i];

      num completed = projectIdList.contains(item.statProject!.toInt())
          ? (item.alreadyNumber ?? 0) / 1000
          : item.alreadyNumber!;

      num fraction = projectIdList.contains(item.statProject)
          ? (item.needNumber ?? 0) / 1000
          : item.days!;

      num percentage = (completed / fraction) * 100;

      num newFraction = (item.needNumber ?? 0) / 1000;
      String explains = getUserTaskExplains(item);

      var data = StandaraListBean(
          index: i + 1,
          amount: fraction,
          completed: completed,
          isReceive: item.status,
          autoReceive: item.autoReceive,
          startTime: item.startTime,
          endTime: item.endTime,
          icon_url: item.icon_url,
          receiveTime: item.receiveTime,
          receiveMethod: item.receiveMethod,
          standaraNumber: item.standaraNumber,
          standaraType: item.standaraType,
          alreadyNumber: item.alreadyNumber,
          custTaskId: item.custTaskId,
          standara_name: getUserTaskTitle(item),
          reward: (item.reward ?? 0) / 1000,
          fraction: newFraction,
          percentage: percentage <= 100 ? percentage : 100,
          explains: item.explains,
          scope: getUserTaskScope(item, explains, newFraction),
          taskDate: explains,
          type: item.type);

      resultList.add(data);
    }

    return resultList;
  }

  /// ------------------------------------------------------------
  /// 解析活动奖金数据
  static List<StandaraListBean> parseActiveBonusData(List<dynamic> taskData) {
    List<StandaraListBean> resultList = [];

    print('====> ${taskData}');

    for (int i = 0; i < taskData.length; i++) {
      final item = taskData[i];
      var data = StandaraListBean(
        index: i + 1,
        standara_name: item['activities_name'],
        reward: item['money'],
        isReceive: item['cust_state'],
        explains: item['explains'],
        startTime: item['startTime'],
        endTime: item['endTime'],
        receiveTime: item['eff_time'], // 领取时间
        icon_url: item['icon_url'],
        percentage: item['cust_state'] == 2 ? 100 : 0,
        desc_info: item['desc_info'],
        task_id: item['task_id'],
        id: item['id'],
        // ---以下的字段还需要确认---
        completed: item['completed'],
      );

      resultList.add(data);
    }

    return resultList;
  }

  /// ------------------------------------------------------------
  /// 解析游戏任务数据
  static Future<List<GameTaskItemBean>> parseGameTaskData(
      List<GameTaskItemBean> taskData) async {
    String imgDomain = await TenantManager.instance.getCurrentImgDomain();

    final resultList = taskData.map((item) {
      List<int> glDZGgame = Game3Config.gameArr['dz'] ?? [];
      List<int> glQPGgame = Game3Config.gameArr['qipai'] ?? [];
      String imgUrl = '';
      int cal = 0;

      int terrace_id = item.terrace_id!;
      dynamic play_id = item.play_id!;
      String play_name = item.play_name!;
      String lang = AppConfigs.lang;
      if (terrace_id.round() < 0) {
        switch (terrace_id) {
          // 彩票
          case -1:
            imgUrl = '${imgDomain}/static/taskList/caipiao.png';
            cal = 4;
            if (play_id != -1) {
              imgUrl = '${imgDomain}/static/taskList/${terrace_id}_game.png';
            }
            // imgUrl = '${imgDomain}/static/taskList/caipiao.png';
            // cal = 4;
            // if (int.parse('$play_id').round() != -1) {
            //   Map<String, dynamic>? play = GameUtils.getPlayInfo('$play_id');
            //   if (play != null) {
            //     String suffix = '';
            //     if (play_id is String || play['cat'] == 'XNB') {
            //       suffix = '_XY';
            //     }
            //     print({'=============$play'});
            //     String icon = ((play['icon'] ?? '') as String).isNotEmpty
            //         ? play['icon']
            //         : play['base'];

            //     imgUrl =
            //         "${imgDomain}/staticQ/caipiao/default/${lang}/icon_play_${icon}${suffix}.png";
            //   } else {
            //     imgUrl = '${imgDomain}/static/taskList/caipiao.png';
            //   }
            // }

            break;

          // 棋牌
          case -2:
            imgUrl = '${imgDomain}/static/taskList/qipai.png';
            cal = 1;
            if (play_id != -1) {
              imgUrl = '${imgDomain}/static/taskList/${terrace_id}_game.png';
            }
            break;

          // 电子
          case -3:
            imgUrl = '${imgDomain}/static/taskList/dianzi.png';
            cal = 2;
            if (play_id != -1) {
              imgUrl = '${imgDomain}/static/taskList/${play_id}_game.png';
            }
            break;

          // 真人
          case -4:
            imgUrl = '${imgDomain}/static/taskList/zhenren.png';
            cal = 6;
            if (play_id != -1) {
              imgUrl = '${imgDomain}/static/taskList/${play_id}_game.png';
            }
            break;

          // 捕鱼
          case -5:
            imgUrl = '${imgDomain}/static/taskList/buyu.png';
            cal = 3;
            if (play_id != -1) {
              imgUrl = '${imgDomain}/static/taskList/${play_id}_game.png';
            }
            break;

          // 体育
          case -6:
            imgUrl = '${imgDomain}/static/taskList/tiyu.png';
            cal = 5;
            if (play_id != -1) {
              imgUrl = '${imgDomain}/static/taskList/${play_id}_game.png';
            }
            break;

          // 红包
          case -7:
            // imgUrl = '/darkImages/home/HASH_LUCKY.png';
            cal = 7;
            if (play_id != -1) {
              imgUrl = '${imgDomain}/static/taskList/${play_id}_game.png';
            }
            break;
        }
      } else {
        cal = GameUtils.getGameCategory(terrace_id);
        if (play_id != -1) {
          imgUrl =
              '${imgDomain}/staticQ/qipai/${terrace_id}/${lang}/game_${play_id}.png';

          if (terrace_id == 506) {
            imgUrl =
                '${imgDomain}/staticQ/qipai/${terrace_id}/${lang}/game_${play_id}.png';
          }

          if (glQPGgame.contains(terrace_id)) {
            imgUrl =
                '${imgDomain}/staticQ/qipai/${terrace_id}/${lang}/game_${play_id}.png';
          }

          if (cal == 2) {
            var smallClass = terrace_id == 340 ? play_name : play_id;

            if (terrace_id == 571) {
              smallClass = play_id ?? item.playid! ?? item.playId;
            }

            imgUrl =
                '${imgDomain}/staticQ/dianzi/${terrace_id}/${lang}/game_${smallClass}.png';
            if (glDZGgame.contains(terrace_id)) {
              imgUrl =
                  '${imgDomain}/staticQ/dianzi/${terrace_id}/${lang}/game_${smallClass}.png';
            }
          } else if (cal == 3) {
            imgUrl =
                '${imgDomain}/staticQ/buyu/${terrace_id}/${lang}/game_${play_id}.png';
          } else if (cal == 7) {
            // 红包的
            imgUrl =
                '${imgDomain}/staticQ/hongbao/${terrace_id}/game_${play_id}.png';
          } else if (cal == 8) {
            // 第三方彩票，任务丢到彩票栏里面，顾重置cal为4
            cal = 4;
            if (terrace_id == 504) {
              imgUrl =
                  '${imgDomain}/staticQ/caipiao/${terrace_id}/${lang}/game_${play_id}.png';
            } else {
              imgUrl =
                  '${imgDomain}/staticQ/caipiao/${terrace_id}/game_${play_id}.png';
            }
          }
        } else {
          // 棋牌（无翻译图标）
          if (glDZGgame.contains(terrace_id)) {
            imgUrl =
                '${imgDomain}/staticQ/dianzi/${terrace_id}/${lang}/game_${terrace_id}.png';
          } else if (glQPGgame.contains(terrace_id)) {
            imgUrl =
                '${imgDomain}/staticQ/qipai/${terrace_id}/${lang}/game_${terrace_id}.png';
          } else {
            imgUrl =
                '${imgDomain}staticQ/caipiao/default/${lang}/icon_play_${terrace_id}.png';
          }

          cal = GameUtils.getGameCategory(terrace_id);
          // 天成或GPI大类时归属于彩票
          if (cal == 8) {
            cal = 4;
          }

          // 原创
          if (item.type_name == 108) {
            cal = 7;
            // imgUrl = '/darkImages/home/game_${terrace_name.replaceAll('game', '')}.png';
          }
        }
      }

      item.imgUrl = imgUrl;
      item.cal = cal;
      item.completed = 0;

      int effective_bet_amount = int.parse('${item.effective_bet_amount}');
      double bet_loss_amout = double.parse('${item.bet_loss_amout}');
      double win_lose_amount = double.parse('${item.win_lose_amount}');
      double bet_amout = double.parse('${item.bet_amout}');
      num is_draw = item.is_draw!;

      if (item.effective_bet_amount!.toInt() == 0) {
        if (bet_loss_amout > win_lose_amount.abs() || is_draw == 1) {
          item.percentage = 100;
          item.completed = (bet_loss_amout / 1000).round();

          if (win_lose_amount < 0) {
            if (bet_loss_amout > 0) {
              item.percentage = 0;
              item.completed = 0;
            } else {
              num percentage =
                  ((bet_loss_amout / win_lose_amount) * 100).round();
              item.percentage = percentage > 100 ? 100 : percentage;
              item.completed = (bet_loss_amout / 1000).abs();
            }
          }
        } else {
          num percentage = ((bet_loss_amout / win_lose_amount) * 100).round();
          item.percentage = percentage > 100 ? 100 : percentage;
          item.completed = (bet_loss_amout / 1000).round();
          if (win_lose_amount > 0 && bet_loss_amout < 0) {
            item.completed = 0;
          }
        }

        item.upToStandard = (win_lose_amount / 1000).round().abs();
      } else {
        if ((bet_amout > effective_bet_amount || is_draw == 1) &&
            play_id != -1) {
          item.percentage = 100;
          item.completed = (bet_amout / 1000).abs();
          item.upToStandard = (effective_bet_amount / 1000).round();
        } else {
          num percentage = ((bet_amout / effective_bet_amount) * 100).round();
          item.percentage = percentage > 100 ? 100 : percentage;
          item.completed = (bet_amout / 1000).abs();
          item.upToStandard = (effective_bet_amount / 1000).round().abs();
        }
      }

      // 修正数据
      if (item.completed! > item.upToStandard!) {
        item.completed = item.upToStandard;
      }

      if (item.completed! < 0) item.completed = 0;
      if (item.percentage! < 0) item.percentage = 0;
      if (item.percentage! > 100) item.percentage = 100;

      return item;
    }).toList();

    resultList.sort((a, b) => a.is_draw!.compareTo(b.is_draw!));
    return resultList;
  }
}
