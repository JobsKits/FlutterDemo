import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/agent_center_api.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/member/common_tips_dialog.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/data/login_bean.dart';

enum ChangeTypeEnum {
  custName,
  amount,
  comfAmount,
  codeVolume,
  remark,
  password,
}

class AgentCenterTransferSubController extends GetxController {
  Rx<LoginPartner> partner = LoginPartner().obs;

  RxString custName = ''.obs; // 代理账号
  RxString amount = ''.obs; // 转入金额
  RxString comfAmount = ''.obs; // 确认转入金额
  RxString codeVolume = ''.obs; // 打码量
  RxString remark = ''.obs; // 备注
  RxString password = ''.obs; // 登录密码

  RxString verifyErrorTips = ''.obs; // 错误提示

  RxBool isCanOpt = false.obs; // 能否操作

  RxBool isLoading = false.obs;
  RxBool isReq = false.obs;

  RxString userId = ''.obs; // 会员账号
  RxString defaultUserId = ''.obs; // 会员账号

  late FocusNode userIdFocusNode;
  RxString username = ''.obs; // 会员姓名

  RxList<dynamic> subList = <dynamic>[].obs; // 下级列表
  RxString selectAcctId = ''.obs; // 选中数据
  RxString selectPartnerName = ''.obs; // 选中数据

  RxDouble quantityMultiple = 1.00.obs;

  @override
  void onInit() {
    super.onInit();
    userIdFocusNode = FocusNode();
    userIdFocusNode.addListener(onUserIdFocusChange);
    // _reqLowMemberList();
    // _reqMemberInfo();
    // _initData();
    _getQuantityMultiple();
    loginVerify();
  }

  @override
  void onClose() {
    userIdFocusNode.removeListener(onUserIdFocusChange);
    super.onClose();
  }

  void onUserIdFocusChange() async {
    if (!userIdFocusNode.hasFocus && userId.value.trim().isNotEmpty) {
      final res = await AgentCenterApi.reqQuerySubMember(userId.value.trim());
      print({'object ======= $res'});
      if (res.type == NetworkService.networkTypeSuccess && res.data != null) {
        username.value = res.data['partner_name'];
        // String name = res.data['partner_name'];
        // if (name.length == 1) {
        //   username.value = name;
        // } else if (name.length == 2) {
        //   username.value = '*${name.substring(1)}';
        // } else if (name.length == 3) {
        //   username.value = '${name.substring(0, 1)}*${name.substring(1)}';
        // } else if (name.length == 4) {
        //   username.value =
        //       '${name.substring(0, 1)}**${name.substring(name.length - 1)}';
        // } else if (name.length > 4) {
        //   username.value =
        //       '${name.substring(0, 1)}***${name.substring(name.length - 1)}';
        // }
      } else {
        // 不清空 defaultUserId，保持用户输入的值，只清空验证结果
        username.value = '';
        setUserId('');
        Get.dialog(
          const CommonTipsDialog(
            tips: '暂无此下级ID',
          ),
          barrierDismissible: false,
        );
      }
    }
  }

  Future<void> _getQuantityMultiple() async {
    final response = await AgentCenterApi.getQuantityMultiple();

    if (response.type == NetworkService.networkTypeSuccess) {
      var resData = response.data;
      if (resData is List && resData.isNotEmpty) {
        quantityMultiple.value =
            double.parse('${resData[0]['codeCount'] ?? 1}');
      }
    }
  }

  // 数据请求
  Future<void> _initData() async {
    Map<String, dynamic> params = {};
    final response = await AgentCenterApi.reqAgentInfo(params);

    if (response.type == NetworkService.networkTypeSuccess) {
      partner.value = LoginPartner.fromJson(response.data);
    }
  }

  // 下级列表
  Future<void> _reqLowMemberList() async {
    final response = await AgentCenterApi.reqLowMemberList();

    if (response.type == NetworkService.networkTypeSuccess) {
      print('_reqLowMemberList===> ${response.data}');

      if (response.data is List) {
        subList.value = response.data;
      } else {
        subList.value = [];
      }
    }
  }

  // 会员信息
  Future<void> _reqMemberInfo() async {
    final response = await AgentCenterApi.reqMemberInfo();

    if (response.type == NetworkService.networkTypeSuccess) {
      print('===> ${response.data}');
    }
  }

  setUserId(String str) {
    userId.value = str;
    defaultUserId.value = str; // 同步更新 defaultUserId，确保 UI 立即响应

    loginVerify();
  }

  void setChangeValue(String val, ChangeTypeEnum type) {
    switch (type) {
      case ChangeTypeEnum.custName:
        custName.value = val;
        break;
      case ChangeTypeEnum.amount:
        amount.value = val;

        String newVal = val.isEmpty ? '0' : val;
        codeVolume.value =
            parseNumber(double.parse(newVal) * quantityMultiple.value);
        break;
      case ChangeTypeEnum.comfAmount:
        comfAmount.value = val;
        break;
      case ChangeTypeEnum.password:
        password.value = val;
        break;
      case ChangeTypeEnum.remark:
        remark.value = val;
        break;
      case ChangeTypeEnum.codeVolume:
        codeVolume.value = val;
        break;
    }

    loginVerify();
  }

  //验证失败的提示信息
  String _getVerifyErrorTip() {
    if (userId.value.isEmpty) return "请输入转入会员ID";
    if (amount.value.isEmpty) return '请输入转入金额';
    if (password.value.isEmpty) return "请输入转账密码";

    // if (codeVolume.value.isEmpty) return '';
    // if (remark.value.isEmpty) return '';

    return '';
  }

  //登录验证
  void loginVerify() {
    String errorMsg = _getVerifyErrorTip();

    verifyErrorTips.value = errorMsg;

    isCanOpt.value = errorMsg.isEmpty;
  }

  // 点击转入
  Future<void> handleTransfer() async {
    try {
      isLoading.value = true;

      // var transferList = subList
      //     .where((item) => '${item['acct_id']}' == selectAcctId.value)
      //     .toList();
      // var item = transferList[0];
      final res = await AgentCenterApi.reqQuerySubMember(userId.value.trim());
      // print('reqQuerySubMember res:${res.data}');
      if (res.type == NetworkService.networkTypeSuccess && res.data != null) {
        Map<String, dynamic> data = {
          'cust_id2': res.data['partner_id'],
          'acct_id2': res.data['acct_id'],
          'acct_name2': res.data['partner_name'],
          'acct_type': '',
          'gen_amount':
              amount.value != '' ? double.parse(amount.value) * 1000 : 0,
          'acct_pwd': password.value,
          'marking_quantity': codeVolume.value != ''
              ? double.parse(codeVolume.value) * 1000
              : 0,
          'remark': remark.value
        };
        final response = await AgentCenterApi.reqAddTransfer(data);

        // print('res====> ${response.type} ${response.data} ');

        if (response.type == NetworkService.networkTypeSuccess) {
          EasyLoading.showSuccess('转账成功');
          // 刷新余额
          await LoginApi.reqBalance();
          // 关闭
          Get.back();
        } else {
          EasyLoading.showError(response.data ?? '转账失败');
        }
      } else {
        EasyLoading.showError('用户不存在');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setSelectAcctId(String id) async {
    selectAcctId.value = id;

    List findList = subList
        .where((item) => '${item['acct_id']}' == selectAcctId.value)
        .toList();

    if (findList.isNotEmpty) {
      selectPartnerName.value = findList[0]['partner_name'];
      custName.value = findList[0]['partner_name'];
    } else {
      selectPartnerName.value = '';
      custName.value = '';
    }

    loginVerify();
  }
}
