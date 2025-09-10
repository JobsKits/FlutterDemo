import 'dart:developer';

import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../base/getx/page_state.dart';
import '../../../constant/app_themes.dart';
import '../../../services/api/api_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/future_util.dart';
import '../../../utils/num_util.dart';
import '../wmodel/alliance_common_params.dart';
import '../wmodel/alliance_game_type_api_model.dart';
import 'commission_rate_api_model.dart';
import 'commission_rate_model.dart';
import 'commission_rate_state.dart';
import 'commisson_rate_tab_model.dart';

class CommissionRateLogic extends GetxController with GetTickerProviderStateMixin {
  final CommissionRateState state = CommissionRateState();

  ///获取 实例
  static CommissionRateLogic of() {
    if (Get.isRegistered<CommissionRateLogic>()) {
      return Get.find<CommissionRateLogic>();
    } else {
      return Get.put<CommissionRateLogic>(CommissionRateLogic());
    }
  }

  ///窗口列表可是最大高度
  final double windowListHeightMax = Get.height / 10 * 4.5;
  late TabController tabController;

  final pageStateObs = PageState.SUCCESS.obs;
  final pageSuccessObs = false.obs;

  //一共有5个, tab 数据模型
  final tabModelListObs = <CommissionRateTabModel>[
    // CommissionRateTabModel(
    //     index: 0,
    //     // label: S.current.game_slots,
    //     label: "老虎机",
    //     icon: "assets/images/alliance/ic_alliance_tab_lhj.webp"),
    // CommissionRateTabModel(
    //     index: 1,
    //     label: S.current.random_text_84,
    //     icon: "assets/images/alliance/ic_alliance_tab_py.webp"),
    // CommissionRateTabModel(
    //     index: 2,
    //     label: S.current.random_text_85,
    //     icon: "assets/images/alliance/ic_alliance_tab_qp.webp"),
    // CommissionRateTabModel(
    //     index: 3,
    //     label: S.current.game_live,
    //     icon: "assets/images/alliance/ic_alliance_tab_zr.webp"),
    // CommissionRateTabModel(
    //     index: 4,
    //     label: S.current.tab_bar_sports,
    //     icon: "assets/images/alliance/ic_alliance_tab_ty.webp"),
  ].obs;

  ///预定义 map 对应的list数据列表
  final modelListMapObs = {
    CommissionRateTypeEnum.electronic: <CommissionRateModel>[],
    CommissionRateTypeEnum.fishing: <CommissionRateModel>[],
    CommissionRateTypeEnum.chessCard: <CommissionRateModel>[],
    CommissionRateTypeEnum.realPerson: <CommissionRateModel>[],
    CommissionRateTypeEnum.sport: <CommissionRateModel>[],
    // CommissionRateTypeEnum.eSportGame: <CommissionRateModel>[],
  }.obs;

  @override
  void onInit() {
    super.onInit();
    // initTabBar();
  }

  @override
  void onReady() {
    super.onReady();
    // loadNetData();
    // loadGameTypeNetData();
    loadTwoNetData();
  }

  static const double pageDefaultHeight = 250.00; //默认情况， 考虑到空数据的时候显示 暂无数据
  final pageMaxHeightObs = pageDefaultHeight.obs;

  double dealAllItemMaxHeight() {
    int maxLength = 0;
    for (var model in tabModelListObs) {
      int itemLength = model.data!.length;
      if (itemLength > maxLength) {
        maxLength = itemLength;
      }
    }
    double height = maxLength * 50 + 100;
    if (height > pageDefaultHeight) {
      pageMaxHeightObs.value = height;
    }

    return pageMaxHeightObs.value;
  }

  final tabList = <Tab>[].obs;
  final tabIndexObs = 0.obs;

  // text: model.label,
  void initTabBar() {
    tabController = TabController(length: tabModelListObs.length, initialIndex: 0, vsync: this);
    var tabModels = tabModelListObs
        .map<Tab>(
          (model) => Tab(
            // text: model.label,
            // height: 54,
            iconMargin: EdgeInsets.zero,
            // icon: Obx(() {
            //   return CustomIcon(
            //       asset: model.icon ?? "",
            //       color: model.index == tabIndexObs.value ? Colors.white : const Color(0xFFB1BAD3));
            // }),
            // icon: Icon(Icons.home,color: Colors.lightBlue),
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 6),
                  // CustomAssetIcon(
                  //   name: model.icon ?? "",
                  //   color: model.index == tabIndexObs.value
                  //       ? Colors.white
                  //       : AppThemes.textColorSecondary,
                  // ),
                  CustomNetWorkImage(
                      width: 16, height: 16, showErrorMsg: false, imageUrl: model.icon ?? ""),
                  SizedBox(height: 2),
                  CustomText(model.label,
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: model.index == tabIndexObs.value
                                ? Colors.white
                                : AppThemes.textColorSecondary,
                          )),
                  // SizedBox(height: 4),
                ],
              );
            }),
          ),
        )
        .toList();
    tabList.assignAll(tabModels);
    tabController.addListener(() {
      if (tabController.index.toDouble() == tabController.animation!.value) {
        tabIndexObs.value = tabController.index;
        log("tab选中：${tabController.index}");
      }

      // tabIndexObs.value = tabController.index;
      // log("tab选中：${tabController.index}");
      //滑动的索引
      // if (!tabController.indexIsChanging) {
      //   // widget.onPageChange!(_tabController.index);
      //   tabIndexObs.value = tabController.index;
      //   log("tab选中：${tabController.index}");
      // }
      // log("tab选中：${tabController.index}");
      // tabIndexObs.value = tabController.index;
    });
  }

  List<AllianceGameTypeApiModel>? typeApiModelList;
  List<CommissionConf>? confApiModelList;

  ///业务逻辑， 动态获取数据， 来显示tab
  void loadTwoNetData() async {
    pageStateObs.value = PageState.LOADING;
    //并行请求
    FutureUtil.executeTasksAsync([loadGameTypeNetData(), loadNetData()]).then((result) {
      if (result) {
        //处理结果
        if (confApiModelList != null && confApiModelList!.isNotEmpty) {
          var targetList = dealNetDataToTarget(typeApiModelList, confApiModelList);
          tabModelListObs.assignAll(targetList);
          dealAllItemMaxHeight();
          if (tabModelListObs.isNotEmpty) {
            initTabBar();
            pageSuccessObs.value = true;
            pageStateObs.value = PageState.SUCCESS;
            // pageStateObs.value = PageState.EMPTY;
            // pageStateObs.value = PageState.FAILED;
          } else {
            pageStateObs.value = PageState.EMPTY;
          }
        } else {
          pageStateObs.value = PageState.EMPTY;
        }
      } else {
        //异常处理
        //考虑到未登陆情况
        // pageStateObs.value = PageState.FAILED;
        pageStateObs.value = PageState.EMPTY;
      }
    });
  }

  ///获取联盟计划-游戏类型 - 下拉框
  Future<bool> loadGameTypeNetData() async {
    var taskResult = false;
    await ApiService.instance.getAllianceGameType(
      success: (List<AllianceGameTypeApiModel> dataList) {
        typeApiModelList = dataList;
        taskResult = true;
      },
      fail: (isConnect, message, candy) {
        log('游戏类型异常：$message');
        taskResult = false;
      },
    );

    // return true;
    // loadNetData();
    return taskResult;
  }

  ///加载网络数据
  Future<bool> loadNetData() async {
    // pageStateObs.value = PageState.LOADING;
    var taskResult = false;
    await ApiService.instance.getCommissionRate(
      success: (data) {
        confApiModelList = data.conf;
        taskResult = true;
      },
      fail: (isConnect, message, candy) {
        // if (isConnect) {
        //   pageStateObs.value = PageState.FAILED;
        // } else {
        //   pageStateObs.value = PageState.FAILED_SERVER;
        // }

        //todo: 0105 临时开通
        // pageStateObs.value = PageState.SUCCESS;
        taskResult = false;
      },
    );
    return taskResult;
  }

  ///model.validBet 是万单位
  String getValidBetStr(String validBetStr) {
    //todo：【0527，需求变更】联盟计划，佣金比例，有效投注要跟后台一样（后台取消了万单位）
    // double validBet = (double.tryParse(validBetStr) ?? 0.00) * 10000;
    double validBet = (double.tryParse(validBetStr) ?? 0.00);
    return NumUtil.keepDecimals(validBet, digits: 2);
  }

  ///对返回数据进行分类 装箱
  List<CommissionRateTabModel> dealNetDataToTarget(
      List<AllianceGameTypeApiModel>? typeList, List<CommissionConf>? conf) {
    // CommissionRateModel(level: index, validBet: 111.11, rebateAmount: 222.22)
    var tempList = <CommissionRateTabModel>[];
    var iconHeader = AppValues.defaultBranch.asset_url;
    //组装tab
    if (conf != null && conf.isNotEmpty) {
      int index = 0;
      for (var model in conf) {
        //接口存在  "model_ids": "4,3", 的情况
        List<String> modelIdList = model.modelIds?.split(',') ?? [];
        // String tabName = "";
        //获取第一个，以来获取图标
        // CommissionRateTypeEnum? mapKey = CommissionRateTypeEnum.getTypeEnum(modelIdList.first);
        // 有可能第一个id, 在CommissionRateTypeEnum 中没有配置
        String? modelId = modelIdList
            .firstWhereOrNull((element) => CommissionRateTypeEnum.getTypeEnum(element) != null);
        // CommissionRateTypeEnum? mapKey = CommissionRateTypeEnum.getTypeEnum(modelId);

        ///取icon
        String? icon =
            (model.ico != null && model.ico!.isNotEmpty) ? "$iconHeader${model.ico?.first}" : "";
        log("返佣比例icon...$icon");
        //遍历是否在类型中, 取第一个
        AllianceGameTypeApiModel? typeModel =
            (typeList ?? []).firstWhereOrNull((element) => model.id == element.id);
        if (typeModel != null) {
          //取名字
          String tabName = typeModel.name ?? "";
          //取图标
          // String? asset = mapKey?.asset;
          //组装列表数据
          var levelList = model.levels!
              .map((e) => CommissionRateModel(
                    level: e.level ?? 0,
                    // validBet: getValidBet(e.effectiveAmount),
                    validBet: getValidBetStr(e.effectiveAmount ?? "0.0"),
                    rebateAmount: getRebate(e.rebateRatio),
                  ))
              .toList();

          //排序处理一下。0124 需求排序：主：有效投注，次：等级
          levelList.sort((a, b) {
            //升序处理， a 在前面
            // int first = b.level.compareTo(a.level);
            // if (first == 0) {
            //   return first;
            // }
            // return (double.tryParse(b.validBet) ?? 0.00)
            //     .compareTo((double.tryParse(a.validBet) ?? 0.00));

            //有效投注 、 等级排序
            // int first = (double.tryParse(a.validBet) ?? 0.00)
            //     .compareTo((double.tryParse(b.validBet) ?? 0.00)) ;
            // if (first != 0) {
            //   return first;
            // }
            // return a.level.compareTo(b.level);

            return (double.tryParse(a.validBet) ?? 0.00)
                .compareTo((double.tryParse(b.validBet) ?? 0.00));
          });
          //组装tab模型
          var tabModel = CommissionRateTabModel(
            index: index,
            // label: "1234567890123",
            label: tabName,
            icon: icon,
            data: levelList,
          );
          tempList.add(tabModel);
          //结束
          index++;
        }
      }
      // tabModelListObs.assignAll(tempList);
    }

    return tempList;

    if (conf != null && conf.isNotEmpty) {
      for (var model in conf) {
        // model.levels
        //接口存在  "model_ids": "4,3", 的情况
        List<String> modelIdList = model.modelIds?.split(',') ?? [];
        for (var id in modelIdList) {
          CommissionRateTypeEnum? mapKey = CommissionRateTypeEnum.getTypeEnum(id);
          //在集合中有才装配
          if (mapKey != null && modelListMapObs.containsKey(mapKey)) {
            var levelList = model.levels!
                .map((e) => CommissionRateModel(
                      level: e.level ?? 0,
                      validBet: getValidBet(""),
                      rebateAmount: getRebate(e.rebateRatio),
                    ))
                .toList();
            //排序处理一下
            levelList.sort((a, b) => a.level.compareTo(b.level));
            modelListMapObs[mapKey] = levelList;
          }
        }
      }
    }
  }

  ///有效投注，金额处理，大于万的 使用万单位
  String getValidBet(String? amount) {
    double? amountD = double.tryParse(amount ?? '0');
    if (amountD != null) {
      if (amountD >= 10000) {
        return '${(amountD / 10000).toStringAsFixed(2)}${S.current.random_text_432}';
      } else {
        return amountD.toStringAsFixed(2);
      }
    } else {
      return "0.00";
    }
  }

  String getRebate(String? rebateRatio) {
    if (rebateRatio != null) {
      return '$rebateRatio%';
    } else {
      return '0.00%';
    }
  }

  ///获取返佣金额
  String getRebateAmount(String? amount, String? ratio) {
    double? amountD = double.tryParse(amount ?? '0');
    double? ratioD = double.tryParse(ratio ?? '0');
    // log('$amountD...$ratioD')
    if (amountD != null && ratioD != null) {
      return (amountD * ratioD).toStringAsFixed(2);
    } else {
      return "0.00";
    }
  }

  ///是否显示tab
  ///todo：【0527需求变更】联盟计划，佣金比例，类型为全部或后台只配置了一个类型时，不显示类型标签
  bool showTabView() {
    return tabModelListObs.length > 1;
  }
}
