import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/page.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail/binding.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail_sport/bindings.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail_wallet/binding.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/transactions_api_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/refresh/custom_pull_to_refresh_controller.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:get/get.dart';

class TransactionsLogic extends BaseController with GetTickerProviderStateMixin {
  TransactionsLogic();

  late BuildContext ctx;

  final CustomPullToRefreshController pullToRefreshController =
      CustomPullToRefreshController(controlFinishRefresh: true, controlFinishLoad: true);


  ScrollController scrollController = ScrollController();

  TabController? otherTypeTabC;

  /// 交易类型列表
  List<String> typeTitleList = [
    TransactionsType.deposits.title,
    TransactionsType.withdrawals.title,
    TransactionsType.other.title,
  ];
  /// 是否在交易记录首页类型选项
  bool isTypeListHome = true;
  /// 当前选中交易类型
  int selTypeIndex = 0;

  /// 存取款状态筛选
  List<String> stateTypeTitleList = [
    TransactionsStateType.all.title,
    TransactionsStateType.success.title,
    TransactionsStateType.fail.title,
    TransactionsStateType.progress.title,
  ];
  /// 当前选中存取款状态类型
  int selStateTypeIndex = 0;


  /// 虚拟币/法币
  List<String> coinTypeTitleList = [
    TransactionsCoinType.banking.title,
    TransactionsCoinType.crypto.title,
  ];
  int selCoinTypeIndex = 0;

  /// 其它类型弹窗
  List<Map<String, dynamic>> otherTypeList = [
    {"id": "", "name": S.current.sport_all}
  ];
  List<String> otherTypeListTitles = [S.current.sport_all];
  int selOtherTypeIndex = 0;

  var cPage = 1;
  final cPageSize = 10;

  /// 原始列表数据
  List itemInfos = [];

  /// 列表数据加载 loding
  var isInitLoding = true;


  /// 返回交易记录类型选择首页
  void backTransactionsTypeHome() {
    isTypeListHome = true;
    update(['transactions_index']);
  }

  /// 交易记录类型选择
  void transactionsTypeDidSelected(int index) {
    selTypeIndex   = index;
    isTypeListHome = false;
    selCoinTypeIndex  = 0;
    selOtherTypeIndex = 0;
    selStateTypeIndex = 0;
    cPage = 1;
    itemInfos = [];
    isInitLoding = true;
    reqItemInfos();
    if (TransactionsType.allType[selTypeIndex] == TransactionsType.other && otherTypeList.length <= 1) {
      reqOtherTypeList();
    }
    update(['transactions_index']);
  }

  /// 存取款根据交易状态筛选数据
  void transactionsStateTypeDidSelected(int index) {
    selStateTypeIndex = index;
    cPage = 1;
    itemInfos = [];
    isInitLoding = true;
    reqItemInfos();
    update(['transactions_index']);
  }

  /// 虚拟币/法币切换
  void coinTypeDidSelected(int index) {
    selCoinTypeIndex = index;
    cPage = 1;
    itemInfos = [];
    isInitLoding = true;
    reqItemInfos();
    update(['transactions_index']);
  }


  /// 其他板块 类型切换
  void otherTypeDidSelected(int index) {
    selOtherTypeIndex = index;
    cPage = 1;
    itemInfos = [];
    isInitLoding = true;
    reqItemInfos();
    update(['transactions_index']);
  }

  /// 上一页
  Future<void> onLastPage() async {
    if(cPage <= 1) return;
    itemInfos = [];
    isInitLoding = true;
    cPage -= 1;
    scrollController.jumpTo(0);
    update(['transactions_index']);
    await reqItemInfos();
  }

  /// 下一页
  Future<void> onNextPage() async {
    if(itemInfos.length < cPageSize) return;
    itemInfos = [];
    isInitLoding = true;
    cPage += 1;
    scrollController.jumpTo(0);
    update(['transactions_index']);
    await reqItemInfos();
  }

  /// 记录列表点击-跳转详情
  void detailDidSelected(int detailIndex) {
    final selType = TransactionsType.allType[selTypeIndex];
    switch (selType) {
      case TransactionsType.deposits:
      case TransactionsType.withdrawals:
        showCustomTrWalletDetailsWidget(
            context: Get.context!,
            transactionsType: selType,
            coinType: TransactionsCoinType.allType[selCoinTypeIndex],
            info: itemInfos[detailIndex]);
        break;
      case TransactionsType.other:
        break;
    }
  }

  /// 请求列表数据
  Future<void> reqItemInfos() async {
    final temSelTypeIndex = selTypeIndex;
    final temSelCoinTypeIndex = selCoinTypeIndex;

    switch (TransactionsType.allType[selTypeIndex]) {
      case TransactionsType.withdrawals:
      case TransactionsType.deposits:
        ApiService.instance.trWalletList(
            trType: TransactionsType.allType[selTypeIndex],
            coinType: TransactionsCoinType.allType[selCoinTypeIndex],
            stateCode: TransactionsStateType.allType[selStateTypeIndex].apiCode,
            pageSize: cPageSize,
            page: cPage,
            success: (page) {
              parsePageInfo(temSelTypeIndex, temSelCoinTypeIndex, page);
            },
            fail: (errorMessage) {
              pullToRefreshController.finishRefresh();
              CustomSnackBar.showError(errorMessage!, ctx);
            });
        break;
      case TransactionsType.other:
        await ApiService.instance.trOtherList(
            pageSize: cPageSize,
            page: cPage,
            typeId: otherTypeList[selOtherTypeIndex]["id"],
            success: (page) {
              parsePageInfo(temSelTypeIndex, temSelCoinTypeIndex, page);
            },
            fail: (errorMessage) {
              pullToRefreshController.finishRefresh();
              CustomSnackBar.showError(errorMessage!, ctx);
            });
        break;
      default:
    }
  }

  void parsePageInfo(temSelTypeIndex, temSelCoinTypeIndex, PageModel page) {
    final milliseconds = (isInitLoding) ? 150 : 0;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      if (temSelTypeIndex == selTypeIndex && temSelCoinTypeIndex == selCoinTypeIndex) {
        // if (cPage == 1) {
        //   itemInfos = [];
        //   pullToRefreshController.finishLoad();
        // }
        //
        // if (page.curPageSize == cPageSize) {
        //   cPage += 1;
        //   pullToRefreshController.finishLoad();
        // } else {
        //   cPage += 1;
        //   pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        // }
        //
        // itemInfos.addAll(page.content);
        // isInitLoding = false;

        // page.content.length < page.total;

        // print("条目：：：：：${page.total}");
        itemInfos = [];
        itemInfos.addAll(page.content);
        isInitLoding = false;

        update(['transactions_index']);
      } else {
        update(['transactions_index']);
      }
    });
  }

  /// 请求其它-类型数据
  Future<void> reqOtherTypeList() async {
    ApiService.instance.trOtherTypeList(
        success: (list) {
          otherTypeList = [
            {"id": "", "name": S.current.sport_all}
          ];
          otherTypeListTitles = [S.current.sport_all];

          for (var element in list) {
            otherTypeList.add(element);
            otherTypeListTitles.add(element["name"]);
          }
          otherTypeTabC = TabController(length: otherTypeList.length, vsync: this);
          update(['transactions_index']);
        },
        fail: (errorMessage) {});
  }

  @override
  void onInit() {
    super.onInit();
    GlobalState.instance.index = 6;
  }

  @override
  void onReady() {
    super.onReady();
    reqItemInfos();
  }

  @override
  void onClose() {
    GlobalState.instance.index = -1;
    super.onClose();
  }
}
