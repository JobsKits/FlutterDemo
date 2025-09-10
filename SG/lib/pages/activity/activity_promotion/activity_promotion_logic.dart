import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/pages/activity/a_model/activity_common_params.dart';
import 'package:flutter_bet/pages/alliance_plan/widget_cell/money_coin_cell_widget.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:get/get.dart';

import '../../../constant/app_urls_values.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../model/language/lang_config_api_model.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/api/api_service.dart';
import '../../../services/lang_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/date_util.dart';
import '../../../utils/iterable_util.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_toast.dart';
import '../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../alliance_plan/alliance_plan_view.dart';
import '../../alliance_plan/wmodel/alliance_common_params.dart';
import '../a_helper/activity_biz_helper.dart';
import '../a_helper/activity_biz_mixin.dart';
import '../a_helper/activity_biz_promotion_mixin.dart';
import '../a_helper/activity_snackbar_hepler.dart';
import '../a_model/activity_people_api_model.dart';
import '../a_model/activity_receive_api_model.dart';
import '../a_model/promotion_cond_item_model.dart';
import '../a_model/promotion_process_item_model.dart';
import '../a_widget/promotion_process_row_widget.dart';
import '../all_promotions/all_promotions_view.dart';
import 'activity_invite_detail_dialog.dart';
import 'activity_promotion_api_model.dart';

///推广活动页面 logic
///todo:逻辑：
///【0529】如果后台 没有配置该语言活动， 不可以切换该币种，比如印度币
class ActivityPromotionLogic extends BaseController
    with ActivityBizMixin, ActivityBizPromotionMixin {
  // 单前选中的币种，不能直接使用这个， 有可能配置 不支持该货币 活动领取
  // CurrencyBean get currentCoin => GlobalStateController.of().currTypeSelected.value;

  //【0529】初始化直接获取
  // CurrencyBean currentCoin = GlobalStateController.of().currTypeSelected.value;
  late CurrencyBean currentCoin;

  // String get currentCoinId => currentCoin.cur ?? "";
  String get currentCoinId => apiCurrentIdObs.value;

  //页面多状态管理
  final pageLoadingObs = true.obs;

  //页面数据
  final apiModelObs = ActivityPromotionApiModel().obs;
  final apiInviteModelObs = ActivityPeopleApiModel().obs;
  final apiReceiveRecordObs = <ReceiveRecord>[].obs; //领取记录
  final apiCurrentIdObs = "".obs; //领取之后的固定币种
  final apiCurrentUrlObs = "".obs; //领取之后的固定币种url, 领取之后 刷新接口 需要重新赋值
  late ActivityTimeState activityStateObs; //活动状态

  // final apiInviteModelObs = ActivityPeopleApiModel().obs;

  //推广人数
  final promotionPeopleObs = 0.obs;

  ActivityPromotionApiModel get apiModel => apiModelObs.value;

  ActivityPeopleApiModel get apiInviteModel => apiInviteModelObs.value;

  //一键领取 状态 是否可用
  final receiveBtnEnableObs = false.obs;

  final promotionCondListObs = <PromotionCondItemModel>[].obs;

  ///开宝箱流程
  ///原始数据
  List<PromotionProcessItemModel> processListData = <PromotionProcessItemModel>[];

  ///对原始数据 进行切割，分组
  final processRowListObs = <List<PromotionProcessItemModel>>[].obs;

  ///是否是 进度条领取 和 邀请
  final bool pbInvite = false;

  // final String pid = "40039904499718196"; //推广活动id
  String pid = ""; //推广活动id
  late Worker coinGetxListen;
  late Worker receiveGetxListen;

  @override
  void onInit() {
    super.onInit();
    pid = Get.arguments["pid"];
    activityStateObs = Get.arguments["activityState"];
    pageLoadingObs.value = true;
    initCoinData();
    initPageData();
    loadAllNetData();
    //监听货币变化
    coinGetxListen = ever(GlobalStateController.of().currTypeSelected, (coinBean) {
      // CurrencyBean? supportCoinBean = isSupportCoinBean(coinBean, getAllSupportLang(), false);
      // if (supportCoinBean != null) {
      //   currentCoin = supportCoinBean;
      //   loadPageNetData();
      //   loadInvitePeopleData();
      // } else {
      //   CustomSnackBar.show(
      //       title: ActivityReceiveState.warn.getTipTitle(),
      //       "当前选择的货币不支持此活动",
      //       Get.overlayContext!,
      //       preIcon: Image.asset(ActivityReceiveState.warn.msgIcon));
      // }
      //todo:[0530]不需要弹窗提示，接口返回错误提示， 本执行本地语言币种
      // currentCoin = coinBean;
      var supportCoin = isSupportCoinBean(
        coinBean: coinBean,
        langLabelList: getAllSupportLang(),
        inputCoin: false,
      );
      if (supportCoin != null) {
        currentCoin = supportCoin;
        //todo: 不支持的币种 ，不刷型
        loadAllNetData();
      }
    });
    //监听状态通知监听
    receiveGetxListen = ever(GlobalStateController.of().mqttActivityReceiveState, (state) {
      loadAllNetData();
    });
  }

  ///初始化货币信息， 必须在页面初始化，并在加载数据之前调用
  void initCoinData() {
    currentCoin = getInitCoinBean(GlobalStateController.of().currTypeSelected.value.cur);
    // currentCoin = isSupportCoinBean(GlobalStateController.of().currTypeSelected.value, [], true);
    apiCurrentIdObs.value = currentCoin.cur ?? "";
    apiCurrentUrlObs.value = currentCoin.coinImgUrl;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    coinGetxListen.dispose(); //销毁
    receiveGetxListen.dispose(); //销毁
    super.onClose();
  }

  void initPageData() {
    var condItemModelList = <PromotionCondItemModel>[
      PromotionCondItemModel(
        // title: S.current.random_text_966,
        title: S.current.random_text_1219,
        content: S.current.random_text_921,
        moneyOrTime: "0",
        currencyId: currentCoinId,
      ),
      PromotionCondItemModel(
          title: S.current.random_text_920,
          content: S.current.random_text_921,
          moneyOrTime: "0",
          currencyId: currentCoinId),
      PromotionCondItemModel(
          title: S.current.random_text_922,
          content: S.current.random_text_921,
          moneyOrTime: "0",
          currencyId: currentCoinId),
      PromotionCondItemModel(
          title: S.current.random_text_923,
          moneyOrTime: "0",
          unit: S.current.random_text_120_copy,
          content: S.current.random_text_921),
      PromotionCondItemModel(
          title: S.current.random_text_925,
          moneyOrTime: "0",
          unit: S.current.random_text_967_copy,
          content: S.current.random_text_921),
    ];
    promotionCondListObs.assignAll(condItemModelList);
  }

  void loadAllNetData() async {
    await loadPageNetData();
    //需要上个api 接口返回的领取货币的ID
    await loadInvitePeopleData();
    // pageLoadingObs.value = false;
  }

  ///推广活动 - 活动配置
  Future<void> loadPageNetData() async {
    //todo:[0601] 如果不支持该币种 接口返回： {"status":false,"data":"refresh"}
    await ApiService.instance.getActivityPromotionConfig(
      pid: pid,
      currency_id: currentCoin.cur ?? "",
      success: (ActivityPromotionApiModel resultData) {
        var finishBack = checkActivityFinishBack(resultData.displayEndAt);
        if (finishBack) {
          reBackPromotionList();
          return;
        }
        //判断是否支持币种， 如果请求币种 跟 接口返回币种 不一样 表示不支持， 停留当前界面
        //需要考虑到，第一次进来的时候。如果是不支持的币种，直接放行
        // if (resultData.currencyId == currentCoin.cur) {
        //   requestNext = false;
        //   return;
        // }
        //页面数据
        apiModelObs.value = resultData;
        apiModelObs.refresh();
        //获取领取的货币id
        dealCoinBean();
        //组装 红包红利流程
        dealBoxPacket();
        //组装 有效推广条件
        dealPromotionCond();
        //组装 条款与条件 detail
        dealDetail(apiModel.detail);
        pageLoadingObs.value = false;
      },
      fail: (bool isConnect, String? message, candy) {
        // 如果活动 结束 且 关闭时间 ， 直接放回： message "refresh"
        log("请求异常");
        //"refresh" 活动关闭， 或者 不支持币种 都会提示该 该刷新，所有需要额外的判断
        if (ActivityCommonParams.needRefresh(message) && activityStateObs.isFinished()) {
          reBackPromotionList();
        }
      },
    );
  }

  ///退到活动列表
  void reBackPromotionList() {
    //提示并 返回列表， 且刷新 列表
    // RouteUtil.popView();
    // AllPromotionsPage.openPage(refresh: true, refreshPage: ActivityListTypeEnum.casino);
    // ActivitySnackBarHelper.showReceiveSnackBar(receiveState: ActivityReceiveState.finishActivity);
    //模拟一下 进入 退出 时间差
    Future.delayed(const Duration(milliseconds: 300), () {
      RouteUtil.popView();
      AllPromotionsPage.openPage(refresh: true, refreshPage: ActivityListTypeEnum.casino);
      ActivitySnackBarHelper.showReceiveSnackBar(receiveState: ActivityReceiveState.finishActivity);
    });
  }

  ///检查是否 活动结束，回退
  ///displayTime 为秒单位
  bool checkActivityFinishBack(int? displayTime) {
    //todo:[0603]推广活动，活动已结束，进入活动提示活动已结束且返回到活动列表
    // 1、活动已结束，展示时间未关闭，可进入活动详情，提示活动已结束
    // 2、活动已结束，且展示时间已关闭，提示活动已结束，返回到活动列表，并刷新列表
    // var timeStr = DateUtil.formatDateMs(displayTime != null ? displayTime * 1000 : 0);
    // log("结束时间：$timeStr");
    if (activityStateObs.isFinished()) {
      if (displayTime != null && displayTime * 1000 < DateTime.now().millisecondsSinceEpoch) {
        //不可以 显示
        return true;
      } else {
        ActivitySnackBarHelper.showReceiveSnackBar(
            receiveState: ActivityReceiveState.finishActivity);
        return false;
      }
    } else {
      return false;
    }
  }

  ///货币处理
  void dealCoinBean() {
    apiCurrentIdObs.value = apiModelObs.value.currencyId ?? "";
    currentCoin = getNetApiCoinBean(apiCurrentIdObs.value);
    //支持货币检查
    CurrencyBean? checkCoinBean = isSupportCoinBean(
      coinBean: currentCoin,
      langLabelList: getAllSupportLang(),
      inputCoin: true,
    );
    if (checkCoinBean != null) {
      currentCoin = checkCoinBean;
    }
    apiCurrentUrlObs.value = currentCoin.coinImgUrl;
  }

  ///处理福利
  void dealBoxPacket() {
    if (apiModel.settings != null) {
      dealAwardListDataBefore();
      dealAwardListDataToGroup();
    } else {}
  }

  ///处理推广条件
  void dealPromotionCond() {
    //todo:[0529]后台配置有效推广人数条件有位0的数据，前台隐藏
    promotionCondListObs[0].moneyOrTime = apiModel.firstDepositAmount ?? "";
    promotionCondListObs[0].currencyId = currentCoinId;
    promotionCondListObs[1].moneyOrTime = apiModel.totalDepositAmount ?? "";
    promotionCondListObs[1].currencyId = currentCoinId;
    promotionCondListObs[2].moneyOrTime = apiModel.totalBetAmount ?? "";
    promotionCondListObs[2].currencyId = currentCoinId;
    promotionCondListObs[3].moneyOrTime = apiModel.totalDepositTimes;
    promotionCondListObs[4].moneyOrTime = apiModel.totalDepositDays;
    promotionCondListObs.refresh();
  }

  ///获取领取状态
  ///isBox 是否是宝箱， automatic是否自动领取
  ActivityAwardState getAwardState({
    required Setting setting,
    required int currentPeople,
    required ActivityReceiveState? receiveState,
    required bool isBox,
    required bool isAutomatic,
    required bool isInsideMoney,
  }) {
    // int currentPeople,
    // int needPeople = setting.ppl ?? 0;
    // if (currentPeople >= needPeople) {
    //   //自动领取
    //   if (isAutomatic) {
    //     return isBox ? ActivityAwardState.box_opened : ActivityAwardState.packet_opened;
    //   } else {
    //     return isBox ? ActivityAwardState.box_unopen : ActivityAwardState.packet_unopen;
    //   }
    // } else {
    //   return isBox ? ActivityAwardState.box_close : ActivityAwardState.packet_close;
    // }

    //todo:[0530] 更改
    int needPeople = setting.ppl ?? 0;

    if (receiveState != null) {
      //自动领取
      // if (isAutomatic) {
      //   return isBox ? ActivityAwardState.box_opened : ActivityAwardState.packet_opened;
      // } else {
      //   return isBox ? ActivityAwardState.box_unopen : ActivityAwardState.packet_unopen;
      // }
      switch (receiveState) {
        case ActivityReceiveState.awaitReceive:
          return isBox ? ActivityAwardState.box_unopen : ActivityAwardState.packet_unopen;
        case ActivityReceiveState.awaitCheck:
        case ActivityReceiveState.alreadyCheck:
        case ActivityReceiveState.alreadyReceive:
          return isBox
              ? (isInsideMoney
                  ? ActivityAwardState.box_opened_inside
                  : ActivityAwardState.box_opened)
              : (isInsideMoney
                  ? ActivityAwardState.packet_opened_inside
                  : ActivityAwardState.packet_opened);
        case ActivityReceiveState.denial:
          return isBox ? ActivityAwardState.box_close : ActivityAwardState.packet_close;
        default:
          //根据人数
          if (currentPeople >= needPeople) {
            return isBox ? ActivityAwardState.box_unopen : ActivityAwardState.packet_unopen;
          } else {
            return isBox ? ActivityAwardState.box_close : ActivityAwardState.packet_close;
          }
      }
    } else {
      return isBox ? ActivityAwardState.box_close : ActivityAwardState.packet_close;
    }
  }

  ///推广活动有效推广人数
  Future<void> loadInvitePeopleData() async {
    await ApiService.instance.getActivityPromotionPeoples(
      pid: pid,
      currency_id: apiCurrentIdObs.value,
      success: (ActivityPeopleApiModel apiModel) {
        promotionPeopleObs.value = apiModel.validMemberCount ?? 0;
        apiReceiveRecordObs.assignAll(apiModel.record ?? []);
        // promotionPeopleObs.value = 3;
        dealBoxPacket();
      },
      fail: (bool isConnect, String? message, candy) {},
    );
  }

  ///推广活动 奖励领取
  ///"state": 1, //状态 1:待审核 2:已审核 3:已发放(领取) 4:待领取 5:拒绝
  void doAwardReceive({
    PromotionProcessItemModel? model, //领取model
    bool oneKeyReceive = false, //是否一键领取, true ,就不需要传递 model .
  }) async {
    // 拦截
    //【1】首先判断 活动是否开始
    if (activityStateObs.isUnStarted()) {
      ActivitySnackBarHelper.showReceiveSnackBar(
        receiveState: ActivityReceiveState.alert,
        bonusAmount: "",
        coinBean: currentCoin,
      );
      return;
    }

    //符合点击时间 领取
    bool isWaitReceive =
        model != null && model.receiveState != null && model.receiveState!.isCanReceive();
    bool isCanClickAward = model != null && model.state.isCanClickAward();
    bool isCloseAward = model != null && model.state.isCloseAward();
    //【1】情况一： 一键领取
    //【2】情况二： 点击福利领取
    if (oneKeyReceive || isWaitReceive || isCanClickAward) {
      await ApiService.instance.getActivityPromotionReceive(
        pid: pid,
        currency_id: apiCurrentIdObs.value,
        success: (ActivityReceiveApiModel resultData) {
          //{"status":true,"data":{"message":"未符合條件","state":0,"bonus_amount":"0"}}
          var receiveState = ActivityReceiveState.adaptor(resultData.state);
          //todo：[0601] 活动推广 领取的 免审核 后端不是不通知。如果是领取成功的话 手动刷新 余额
          if (receiveState == ActivityReceiveState.alreadyReceive) {
            GlobalStateController.of().inquireBalance();
          }
          //提示处理
          //比如领取之后，审核：  "message": "审核中",
          ActivitySnackBarHelper.showReceiveSnackBar(
            receiveState: receiveState,
            bonusAmount: resultData.bonusAmount,
            coinBean: currentCoin,
          );
          //重新刷新一下 页面数据
          // loadPageNetData();
          loadInvitePeopleData();
        },
        fail: (bool isConnect, String? message, candy) {
          CustomSnackBar.showError(
            message ?? "",
            Get.overlayContext!,
            // title: S.current.random_text_757,
            // preIcon: CustomSnackBarIcons.verifySucceed,
          );
        },
      );
    } else if (isCloseAward) {
      //不执行网络请求，本地直接提示
      //"您当前未满足领取条件"
      ActivitySnackBarHelper.showReceiveSnackBar(
        receiveState: ActivityReceiveState.warn,
        bonusAmount: "",
        coinBean: currentCoin,
      );
    }
  }

  ///分组之前 福利状态匹配，封装
  void dealAwardListDataBefore() {
    //需要拿到索引，index
    var tempList = apiModel.settings!.asMap().entries.map((entry) {
      var setting = entry.value;
      //获取领取状态
      var receiveState = getReceiveState(entry.key);
      var isInsideMoney = apiModel.isInsideMoney();
      return PromotionProcessItemModel(
        // imgUrl:
        //     'https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg',
        imgUrl: "",
        content: setting.ppl.toString(),
        contentUnit: S.current.random_text_528,
        //Peoples  人
        money: setting.bonus ?? "",
        insideMoney: isInsideMoney,
        // insideMoney: true,
        coinBean: currentCoin,
        state: getAwardState(
          setting: setting,
          currentPeople: promotionPeopleObs.value,
          receiveState: receiveState,
          isBox: apiModel.isBox(),
          isAutomatic: apiModel.isAutomatic(),
          isInsideMoney: isInsideMoney,
        ),
        receiveState: receiveState,
      );
    }).toList();

    // var tempList = apiModel.settings!.map((setting) {
    //   return PromotionProcessItemModel(
    //     // imgUrl:
    //     //     'https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg',
    //     imgUrl: "",
    //     content: setting.ppl.toString(),
    //     contentUnit: S.current.random_text_528,
    //     //Peoples  人
    //     money: setting.bonus ?? "",
    //     insideMoney: apiModel.isInsideMoney(),
    //     // insideMoney: true,
    //     coinBean: currentCoin,
    //     state: getAwardState(
    //         setting, promotionPeopleObs.value, apiModel.isBox(), apiModel.isAutomatic()),
    //     // receiveState:ActivityReceiveState.adaptor(),
    //   );
    // }).toList();
    processListData.assignAll(tempList);
    //todo：【0531】扫描一下 是否有可以领取的 福利， 有的话 会显示 "一键领取按钮"
    receiveBtnEnableObs.value = processListData.any((model) => model.state.isCanReceiveAward());
  }

  ///获取领取状态,
  ActivityReceiveState? getReceiveState(int index) {
    //发放梯级，从1开始
    int stepIndex = index + 1;
    //获取领取 阶梯 的状态bean
    ReceiveRecord? record =
        apiReceiveRecordObs.firstWhereOrNull((record) => stepIndex == record.lvl);
    //获取对应的领取枚举
    ActivityReceiveState receiveState = ActivityReceiveState.adaptor(record?.state);
    return receiveState;
  }

  ///奖励流程处理 分组处理
  void dealAwardListDataToGroup() {
    // processListData.map((e) => e.insideMoney = true).toList();
    var result = IterableUtil.chunk<PromotionProcessItemModel>(processListData, rowCellTotal);
    processRowListObs.assignAll(result);
  }

  final detailObs = <String>[].obs;

  ///对api detail 字段进行处理
  List<String> dealDetail(String? detail) {
    if (detail != null && detail.isNotEmpty) {
      List<String> tempList = detail.split('\n').where((item) => (item.trim().isNotEmpty)).toList();
      detailObs.assignAll(tempList);
    }
    return [];
  }

  ///获取支持的语言
  List<String> getAllSupportLang() {
    Map<String, dynamic> langConMap = json.decode(apiModel.buttonText ?? "");
    List<String> keyList = langConMap.keys.toList();
    return keyList;
  }

  ///一键领取
  void onClickOneKeyReceive() {
    doAwardReceive(oneKeyReceive: true);
  }

  //一键领取,是否显示
  bool isShowReceiveBtn() {
    return promotionPeopleObs.value > 0 && receiveBtnEnableObs.value;
  }

  ///一键领取, 是否可用
  ///条件，只要有任意一个 可以领取的 红包或者宝箱
  bool isEnableReceiveBtn() {
    return receiveBtnEnableObs.value;
  }

  ///复制链接
  void onClickCopyLink() {
    Clipboard.setData(ClipboardData(text: getFullLink()));
    CustomToast.show(S.current.random_text_151, Get.overlayContext!);
    // log("复制成功");
  }

  // final myLink = "".obs;

  ///获取完整的分享链接
  String getFullLink() {
    return '${AppUrlsValues.envConfig.api_url}${apiModel.linkUrl}';
  }

  ///点击 分享更多
  void onClickShareMore() {
    AlliancePlanPage.openPage(pageEnum: AlliancePageEnum.study);
  }

  ///点击 邀请详情
  void onClickInviteDetail() {
    ActivityInviteDetailDialogWidget.openDialog(pid, currentCoinId);
  }

  ///点击 奖励
  void onClickAward(PromotionProcessItemModel model) {
    log("点击 奖励...${model.toString()}");
    // CustomToast.show(model.state.name, Get.overlayContext!);
    model.nextState();
    //todo: 更新领取状态
    model.receiveState = null;
    processRowListObs.refresh();
  }

  ///推广活动 页面， 底部按钮 api  多语言匹配
  String? getPromotionBtnLabel(String? buttonText) {
    if (buttonText == null || buttonText.isEmpty) {
      return "";
    }
    try {
      LangConfigApiModel configModel = LangConfigApiModel.fromJson(json.decode(buttonText));
      return LangService().getConfigLabel(configModel);
    } catch (e) {
      return "";
    }
  }

  ///点击底部按钮
  void onClickBottomActionBtn({String? url, int? buttonType, int? ty, String? pid}) {
    // CustomToast.show(S.current.random_text_926, Get.overlayContext!);
    // CustomToast.show("chick", Get.overlayContext!);
    if (url != null && url.contains("http")) {
      ActivityBizHelper.launchBtnURL(url);
    } else {
      dealCustomJumpPage(buttonType: buttonType);
    }
  }

  ///todo:测试领取之后 状态提示
  void testToast() {
    var receiveState = ActivityReceiveState.awaitReceive;
    CustomSnackBar.show(
      title: receiveState.getTipTitle(),
      // resultData.message ?? "",
      // receiveState.getTipContent(),
      "",
      Get.overlayContext!,
      preIcon: Image.asset(receiveState.msgIcon),
      // preIcon: CustomSnackBarIcons.verifySucceed,
      // title: S.current.random_text_757,
      // preIcon: CustomSnackBarIcons.verifySucceed,
      subContent: receiveState.isShowReceiveMoney()
          ? Row(children: [
              CustomText(
                receiveState.getTipContent(),
                style: ThemeService()
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 1),
              MoneyCoinCellWidget(money: "11.00", coinBean: currentCoin),
              const SizedBox(width: AppValues.defaultMargin),
            ])
          : Row(
              children: [
                CustomText(
                  receiveState.getTipContent(),
                  style: ThemeService()
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: AppValues.defaultMargin),
              ],
            ),
    );
  }
}
