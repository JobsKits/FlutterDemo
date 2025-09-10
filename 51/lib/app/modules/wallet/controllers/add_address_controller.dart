import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../data/add_address_select_pop_bean.dart';
import '../data/bank_card_bean.dart';
import '../data/withdraw_type_bean2.dart';
import 'new_withdrawal_controller.dart';

class AddAddressController extends GetxController {
  late NewWithdrawalController withdrawalController;

  /// --------------arguments 参数-----------------
  late String title; // 必填项
  late String iconUrl; // 图标（根据数据计算）

  /// ---------------select pop 相关数据-----------------
  RxList<AddAddressSelectPopBean> popSelectList =
      <AddAddressSelectPopBean>[].obs; // 币种或者银行 下拉选项列表

  Rx<AddAddressSelectPopBean?> currentPopSelect =
      Rx<AddAddressSelectPopBean?>(null); // 定义默认提现 币种或者银行
  /// ----------------虚拟币交易协议----------------
  RxList<AddAddressSelectPopBean> virtualPopSelectList = [
    AddAddressSelectPopBean(name: 'TRC20', value: 'TRC20'),
  ].obs; // 虚拟币协议列表

  Rx<AddAddressSelectPopBean> virtualCurrentPopSelect =
      AddAddressSelectPopBean(name: 'TRC20', value: 'TRC20').obs; // 当前虚拟币
  late int currentType = 0;
  late String? boundName; // 已绑定的银行卡姓名
  /// --------------------------------
  RxBool ifsc = false.obs; // 是否含有ifsc (印度)

  RxBool isRequest = false.obs; // 是否正在请求

  /// ---------------数据-----------------
  RxBool isDefault = true.obs; // 是否设为默认
  RxString payNo = ''.obs; // 卡号
  RxString payName = ''.obs; // 用户名
  RxString acctPwd = ''.obs; // 资金密码

  @override
  void onInit() {
    super.onInit();
    try {
      withdrawalController = Get.find();
    } catch (e) {
      withdrawalController =
          Get.put(NewWithdrawalController()); //报错说明没有put，重新put一次
    }
    _initArguments();
    initData();
  }

  // 初始化传递的参数
  void _initArguments() {
    var arguments = Get.arguments;
    currentType = arguments["payType"];
    title = arguments["title"];
    boundName = LoginManager.instance.loginInfo?.custContact?.contactName;
    if (boundName != null && boundName!.isEmpty) {
      boundName = null;
    }

    if (boundName != null) {
      payName.value = boundName!;
    }
  }

  // 初始化数据请求
  Future<void> initData() async {
    // 银行卡
    if (currentType == 3) {
      reqNewBankList();
      // 印度币种
      if (TenantManager.instance.tenantBean!.area == 'INR') {
        reqIFSC();
        reqBindCardConfig();
      }
    }
    //数字钱包
    if (currentType == 2) {
      reqDigitalWallets();
    }
    // // pixPay
    // if (currentType == AddressType.pixPayType) {
    //   reqBindCardConfig();
    // }

    // 虚拟币
    if (currentType == 1) {
      popSelectList.value = [
        AddAddressSelectPopBean(name: 'USDT', value: 'USDT')
      ];

      currentPopSelect.value = popSelectList[0];
    }
  }

  Future<void> reqDigitalWallets() async {
    final res = await SystemApi.reqDefaultBankCard2();
    if (res.type == NetworkService.networkTypeSuccess) {
      for (var item in res.data) {
        WithdrawTypeTabBean2 secondItem = WithdrawTypeTabBean2.fromJson(item);
        if (secondItem.data != null &&
            secondItem.data!.isNotEmpty &&
            secondItem.rechargeTypeId == 2) {
          popSelectList.value = secondItem.data!
              .map((ele) => AddAddressSelectPopBean(
                  name: ele.payOrgName!, value: '${ele.payOrgId!}'))
              .toList();
          if (secondItem.data?.first.payOrgId == 308) {
            popSelectList.removeWhere((item) => item.value == "308"); //移除no钱包
          }
          currentPopSelect.value = popSelectList[0];
        }
      }
    }
  }

  /// 查询银行列表
  Future<void> reqNewBankList() async {
    final res = await SystemApi.reqNewBankList();

    if (res.type == NetworkService.networkTypeSuccess) {
      List<BankCardItemBean>? data = BankCardBean.fromJson(res.data).data;

      if (data != null && data.isNotEmpty) {
        popSelectList.value = data
            .map((ele) => AddAddressSelectPopBean(
                name: ele.name!, value: '${ele.payOrgId!}'))
            .toList();

        currentPopSelect.value = popSelectList[0];
      }
    }
  }

  /// 查询reqIFSC （印度市场用）
  Future<void> reqIFSC() async {
    final res = await SystemApi.reqIFSC();

    if (res.type == NetworkService.networkTypeSuccess) {
      ifsc.value = res.data['response_code']?.toString() == '9999';
    }
  }

  // 后台配置必填项等配置
  Future<void> reqBindCardConfig() async {
    final res = await SystemApi.reqBindCardConfig();

    if (res.type == NetworkService.networkTypeSuccess) {
      final data = BindCardConfigBean.fromJson(res.data);
      print('====> ${res.data}');
    }
  }

  // 更新当前选中pop
  void updateCurrentPopSelect(AddAddressSelectPopBean bean) {
    AppManager.instance.tapVibrate();
    currentPopSelect.value = bean;
  }

  // 更新当前选中虚拟币协议
  void updateVirtualCurrentPopSelect(AddAddressSelectPopBean bean) {
    AppManager.instance.tapVibrate();
    virtualCurrentPopSelect.value = bean;
  }

  // 修改设为默认
  void setIsDefault(bool value) {
    isDefault.value = value;
  }

  // 修改用户名
  void setPayName(String value) {
    payName.value = value;
  }

  // 修改卡号
  void setPayNo(String value) {
    payNo.value = value;
  }

  // 修改资金密码
  void setAcctPwd(String value) {
    acctPwd.value = value;
  }

  // 验证
  bool _beforeValid() {
    bool isVirtual = currentType == 1;
    bool isDigitalWallets = currentType == 2; //数字钱包
    // 卡号
    if (payNo.value.trim() == '') {
      EasyLoading.showToast('请输入您的账号');
      return false;
    }

    // 卡号
    if (!isVirtual && payName.value.trim() == '') {
      EasyLoading.showToast('请输入您的真实姓名');
      return false;
    }

    // 资金密码
    if (acctPwd.value.trim() == '') {
      EasyLoading.showToast('请输入您的资金密码');
      return false;
    }

    return true;
  }

  // 点击绑定
  Future<void> handleBindCard() async {
    /// 未通过校验
    if (!_beforeValid()) {
      return;
    }

    if (isRequest.value) {
      return;
    }
    try {
      isRequest.value = true;

      EasyLoading.show(indicator: const CommonLoadingView());

      /// 检查资金密码
      final res = await SystemApi.reqCheckFundPassword(acctPwd.value);

      if (res.type == NetworkService.networkTypeSuccess) {
        var payOrgId;
        switch (currentType) {
          case 2:
          case 3:
            payOrgId = int.parse(currentPopSelect.value!.value);
            break;
          case 4:
            payOrgId = 185;
            break;
          default:
            payOrgId = 187;
            break;
        }
        // 验证成功
        if (res.data['response_code'] == '9999') {
          // 去除卡号中的空格
          String bindPayNo = payNo.replaceAll(RegExp(r'\s+'), '');
          var data = {
            'pay_org_id': payOrgId, // 渠道id
            'pay_org_name':
                currentType != 4 ? currentPopSelect.value!.name : title, // 渠道名称
            'pay_name': payName.value,
            'pay_no': bindPayNo,
            'sort_v': isDefault.value ? 1 : 0, // 是否默认
          };

          /// ------------------判断币种---------------------
          // if (currentType == 3) {
          //   // UPI
          //   data['currency'] = 'INR';
          // } else if (currentType == AddressType.pixPayType) {
          //   // PIX
          //   data['currency'] = 'BRL';
          // } else if (currentType == AddressType.picPayType) {
          //   // PIC
          //   data['currency'] = 'BTR';
          // } else if (currentType != AddressType.virtualCurrencyType &&
          //     currentType != AddressType.bankcardsType) {
          //   // 非虚拟币 非银行卡
          //   data['currency'] = 'CNY';
          // }
          data['currency'] = 'CNY';

          /// ------------------判断虚拟币---------------------
          if (currentType == 1) {
            data['usdt_type'] = virtualCurrentPopSelect.value.value;
            data['qr_code_address'] = ''; // 先设置为空
          }

          /// ------------------判断银行卡---------------------
          if (currentType == 3) {
            data['ifsc'] = ''; // 印度才有
            data['telephone'] = ''; // 绑定手机
            data['open_addr'] = ''; // 开户行网点
          }
          final result = await SystemApi.reqBindCard(data);

          // print("请求参数：${data}   响应参数：${result.data}");
          // 绑卡成功
          if (result.type == NetworkService.networkTypeSuccess) {
            // await withdrawalController.reqBindBankList();
            if (boundName == null && payName.isNotEmpty) {
              LoginManager.instance.loginInfo?.custContact?.contactName =
                  payName.value;
              await SpUtil.saveBean<LoginBean>(
                  "loginBean", LoginManager.instance.loginInfo!);
            }

            EasyLoading.showSuccess('新增成功');
            // 刷新卡列表数据
            Get.back(result: true);
          }
        } else {
          EasyLoading.showError('资金密码不正确');
        }
      }
    } finally {
      isRequest.value = false;
      EasyLoading.dismiss();
    }
  }
}
