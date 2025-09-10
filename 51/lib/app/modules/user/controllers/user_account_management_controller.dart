import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../api/user_api.dart';
import '../../../../constants/withdraw_constants.dart';
import '../../wallet/data/withdraw_method_bean.dart';
import '../../wallet/data/withdraw_type_bean.dart';
import '../data/user_bank_info_bean.dart';

class UserAccountManagementController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  List<UserBankInfoBean> allTabList = []; //过滤之前的集合

  RxList<WithdrawMethodBean> tabList = <WithdrawMethodBean>[].obs;
  List<WithdrawBindCardItemBean> allContentList = [];
  RxList<WithdrawBindCardItemBean> contentList =
      <WithdrawBindCardItemBean>[].obs;
  RxInt currentTabIndex = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 0, vsync: this);
    print(
        "token:${LoginManager.instance.loginInfo?.accessToken}  cid:${LoginManager.instance.loginInfo?.custId}");
    reqAccountBankTabList();
  }

  void reqAccountBankList() async {
    allContentList = await UserApi().reqAccountBankList();
    changeTabIndex(currentTabIndex.value);
    EasyLoading.dismiss();
  }

  void reqAccountBankTabList() async {
    EasyLoading.show(indicator: const CommonLoadingView());
    allTabList = await UserApi().reqAccountBankTabList(); //这里是所有的集合
    List<WithdrawMethodBean> currentWithrawMethodList = [];

    List<int> cutList = withdrawMethodConfigList
        .map((method) => method['value'] as int)
        .toList();

    for (UserBankInfoBean payInfo in allTabList) {
      int isBind = payInfo.isBind;
      int cut = payInfo.cut;
      // 有权限绑定的 并且 配置含有该项
      if (isBind != 2 && cutList.contains(cut)) {
        Map<String, dynamic> methodConfig = withdrawMethodConfigList
            .firstWhere((method) => method['value'] == cut);
        currentWithrawMethodList.add(
          WithdrawMethodBean(
            label: methodConfig['label'],
            value: methodConfig['value'],
            payType: methodConfig['payType'],
            add: methodConfig['add'],
            key: methodConfig['key'],
            icon: '',
          ),
        );
      }
    }
    tabList.value = currentWithrawMethodList;
    tabController.dispose();
    tabController = TabController(length: tabList.length, vsync: this);
    reqAccountBankList();
  }

  void changeTabIndex(int index) {
    currentTabIndex.value = index;
    var type = tabList[index].payType;
    if (type == 0) {
      // 不同银行的银行卡payOrgId不同，也不为0
      // 除了支付宝、虚拟币、GoPay...剩下的是银行卡
      List<int> payTypeList = withdrawMethodConfigList
          .map((method) => method['payType'] as int)
          .toList();
      contentList.value = allContentList.where((value) {
        return !payTypeList.contains(value.payOrgId) || value.payOrgId == type;
      }).toList();
    } else {
      contentList.value =
          allContentList.where((value) => value.payOrgId == type).toList();
    }
  }

  String getIconPath() {
    var type = tabList[currentTabIndex.value].payType;
    print("object");
    String iconPath = "";
    switch (type) {
      case 0:
        iconPath = Assets.theme1.images.withdraw.icons.icoCut0.path;
        break;
      case 185:
        iconPath = Assets.theme1.images.withdraw.icons.icoCut1.path;
        break;
      default:
        iconPath = Assets.theme1.images.withdraw.icons.icoCut2.path;
        break;
    }
    return iconPath;
  }

  //切换默认卡
  void setDefaultValue(int index) async {
    bool isUnSelect = contentList[index].sortV != 1; //判断一下点击的是否已经是默认卡
    if (isUnSelect) {
      EasyLoading.show(indicator: const CommonLoadingView());
      //不是默认卡
      //执行设置默认卡的逻辑
      bool isSuccess =
          await UserApi().setDefaultBank(contentList[index].payInfoId!);
      if (isSuccess) {
        //设置成功，重新请求列表数据
        reqAccountBankList();
      }
    }
  }

  //显示或者隐藏账号
  void showOrHideAccount(int index) {
    contentList[index].isShowNum.value = !(contentList[index].isShowNum.value);
    if (!contentList[index].isShowNum.value) {
      contentList[index].tempPayNo = contentList[index]
          .payNo!
          .replaceRange(3, contentList[index].payNo!.length - 4, '...');
    }
  }
}
