import 'package:captcha_plugin_flutter/captcha_plugin_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/agent_center_api.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/regex_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import '../../../../api/login_api.dart';
import '../../login/data/contact_config_bean.dart';
import '../widget/dropdown_select.dart';
import 'agent_center_share_controller.dart';

enum ChangeTypeEnum {
  custName,
  password,
  repassword,
  partnerDes,
  peerQuota,
  lowerQuota,
}

class AgentCenterRegisterController extends GetxController {
  RxString pageTitle = '代理开户'.obs;

  Rx<LoginPartner> partner = LoginPartner().obs;

  RxString custName = ''.obs; // 会员账号
  RxString password = ''.obs; // 登录密码
  RxString repassword = ''.obs; // 确认密码
  RxString partnerDes = ''.obs; // 描述
  RxString peerQuota = ''.obs; // 同级配额总数
  RxString lowerQuota = ''.obs; // 下级配额总数

  RxString partnerFlag = '1'.obs; // 会员类型
  List<DropdownSelectBean> selectOption = [
    // DropdownSelectBean(label: '会员', value: '0'),
    DropdownSelectBean(label: '代理商', value: '1'),
    // DropdownSelectBean(label: '虚拟会员', value: '2'),
  ];

  RxString verifyErrorTips = ''.obs; // 错误提示

  RxBool isCanRegister = false.obs; // 能否开户

  RxBool isLoading = false.obs;

  // checkList
  RxList<Map<String, dynamic>> checklist = <Map<String, dynamic>>[].obs;
  RxList<bool> checked = <bool>[].obs; // 选中的

  /// /// 易盾智能验证
  bool isAiVerify = false;
  String captchaId = '';
  String aiValidate = '';

  @override
  void onInit() {
    super.onInit();
    _reqContactInfo();
    _initCheckList();
    _initData();

    loginVerify();
  }

  // 请求租户注册联系人配置
  Future<void> _reqContactInfo() async {
    final res = await LoginApi.reqContactConfig();

    if (res.type == NetworkService.networkTypeSuccess) {
      ContactConfigBean ccb = ContactConfigBean.fromJson(res.data);

      SysRegisterOptionsBean sysRegisterOptions = ccb.sysOptions!;
      // 是否展示易盾智能验证
      String? smartSwitch =
          sysRegisterOptions.CUST_REGISTER_CAPTCHA_MODE!.SMART_SWITCH;
      String? smartCaptchaMode = sysRegisterOptions
          .CUST_REGISTER_CAPTCHA_MODE!.Z2_M_SMART_CAPTCHA_MODE;
      if (smartSwitch == '1' && smartCaptchaMode != '0') {
        String idKey = 'CAPTCHA_ID_${smartCaptchaMode}';
        if (sysRegisterOptions.YIDUN_CAPTCHA_ID?[idKey] != null) {
          isAiVerify = true;
          captchaId = (sysRegisterOptions.YIDUN_CAPTCHA_ID?[idKey])!;
        }
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _initCheckList() async {
    // 1 金字塔模式  2.日结模式
    var agentModel = TenantManager.instance.tenantBean?.tenant?.agentModel;

    List<Map<String, dynamic>> dataList = [
      {
        'name': '允许转账下级',
        'value': 'allow_transfer',
        'show': true,
      },
      {
        'name': '允许保留返点',
        'value': 'allow_rebate',
        'show': agentModel == 1,
      },
      // {
      //   'name': '允许发展会员',
      //   'value': 'allow_cust',
      //   'show': true,
      // },
      {
        'name': '允许发展下级',
        'value': 'allow_peer',
        'show': true,
      },
      // {
      //   'name': '允许发展下级',
      //   'value': 'allow_lower',
      //   'show': true,
      // },
      // {
      //   'name': '允许添加好友',
      //   'value': 'allowAddFriend',
      //   'show': true,
      // },
      // {
      //   'name': '允许私聊好友',
      //   'value': 'allowChat',
      //   'show': true,
      // }
    ];

    checklist.value = dataList;

    // checked.value = [false, false, false, false, false, false, false];
    checked.value = [false, false, false];
  }

  void setChecked(bool? val, int index) {
    checked[index] = val ?? false;
  }

  // 数据请求
  Future<void> _initData() async {
    Map<String, dynamic> params = {};
    final response = await AgentCenterApi.reqAgentInfo(params);
    // print('_initData======> ${response.type}');
    if (response.type == NetworkService.networkTypeSuccess) {
      // print('_initData======> ${response.data}');
      partner.value = LoginPartner.fromJson(response.data);
    }
  }

  void setChangeValue(String val, ChangeTypeEnum type) {
    switch (type) {
      case ChangeTypeEnum.custName:
        custName.value = val;
        break;
      case ChangeTypeEnum.password:
        password.value = val;
        break;
      case ChangeTypeEnum.repassword:
        repassword.value = val;
        break;
      case ChangeTypeEnum.partnerDes:
        partnerDes.value = val;
        break;
      case ChangeTypeEnum.peerQuota:
        peerQuota.value = val;
        break;
      case ChangeTypeEnum.lowerQuota:
        lowerQuota.value = val;
        break;
    }

    loginVerify();
  }

  //验证失败的提示信息
  String _getVerifyErrorTip() {
    if (custName.value.isEmpty) return "会员账号不能为空";

    if (!RegexUtils.isUserName(custName.value)) {
      return '用户名必须以字母开头,可以有数字或"_"的长度为6-12';
    }

    if (password.value.isEmpty) return "密码不能为空";
    if (password.value.length < 6) return "密码长度不能小于6位";
    if (password.value.length > 16) return "密码长度不能超过16位";

    // if (peerQuota.value.isEmpty) return '同级配额总数不能为空';
    // if (lowerQuota.value.isEmpty) return '下级配额总数不能为空';

    return '';
  }

  //登录验证
  void loginVerify() {
    String errorMsg = _getVerifyErrorTip();

    verifyErrorTips.value = errorMsg;

    isCanRegister.value = errorMsg.isEmpty;
  }

  String computedTitle() {
    if (partnerFlag.value == '0') {
      return '确定要新增会员吗?';
    }

    if (partnerFlag.value == '1') {
      return '确定要新增代理商吗?';
    }

    return '确定要新增虚拟会员吗?';
  }

  void showCaptcha() {
    aiValidate = '';
    isLoading.value = true;

    CaptchaPluginFlutter captchaPlugin = CaptchaPluginFlutter();
    CaptchaPluginConfig styleConfig = CaptchaPluginConfig(
        radius: 10,
        capBarTextColor: "#25D4D0",
        capBarTextSize: 18,
        capBarTextWeight: "bold",
        borderColor: "#25D4D0",
        borderRadius: 10,
        backgroundMoving: "#DC143C",
        executeBorderRadius: 10,
        executeBackground: "#DC143C",
        capBarTextAlign: "center",
        capPaddingTop: 10,
        capPaddingRight: 10,
        capPaddingBottom: 10,
        capPaddingLeft: 10,
        paddingTop: 15,
        paddingBottom: 15);
    captchaPlugin.init({
      "captcha_id": captchaId,
      'is_debug': false,
      'is_show_loading': false,
      "dimAmount": 0.8,
      "is_touch_outside_disappear": true,
      "timeout": 8000,
      "is_hide_close_button": false,
      "use_default_fallback": true,
      "failed_max_retry_count": 4,
      "language_type": "zh-CN",
      "is_close_button_bottom": true,
      "styleConfig": styleConfig.toJson(),
    });

    captchaPlugin.showCaptcha(onLoaded: () {
      // print("================onLoaded==============");
    }, onSuccess: (dynamic data) {
      // print('onSuccess: $data');
      bool result = data['result'] == true || data['result'] == 'true';
      if (result) {
        aiValidate = data['validate'];
        isLoading.value = false;
        handleRegister();
      }
    }, onClose: (dynamic data) {
      // print('onClose: $data');
      isLoading.value = false;
    }, onError: (dynamic data) {
      // print('onError: $data');
      isLoading.value = false;
    });
  }

  // 点击注册
  Future<void> handleRegister() async {
    AgentCenterShareController agentCenterShareController = Get.find();

    try {
      isLoading.value = true;
      if (isAiVerify) {
        if (aiValidate.isEmpty) {
          showCaptcha();
          return;
        }
      }
      int busicode = 0;
      if (checked[0]) {
        // 转账下级
        busicode += 16;
      }
      if (checked[1]) {
        // 保留返点
        busicode += 8;
      }
      // if (checked[2]) {
      //   // 发展同级
      //   busicode += 2;
      // }
      if (checked[2]) {
        // 发展下级
        busicode += 1;
      }
      // String friendCode = '';
      // friendCode += (checked[5] ? '1' : '0');
      // friendCode += (checked[6] ? '1' : '0');

      Map<String, dynamic> data = {
        'busi_code': busicode,
        // 'friend_code': int.parse(friendCode, radix: 2),
        'friend_code': 0,
        'cust_name': custName.value,
        // 'peer_quota': peerQuota.value,
        // 'lower_quota': lowerQuota.value,
        'inviteCode': agentCenterShareController.promotionCode.value,
        'invite_code': agentCenterShareController.promotionCode.value, // 邀请码
        'partner_des': partnerDes.value,
        'password': password.value,
        'partner_flag': partnerFlag.value,
        'isQp': 1,
        'validate': aiValidate,
      };
      print("这是什么啊:${data}");
      final response =
          await AgentCenterApi.reqAddAgentOrUser(data, partner: partner.value);

      if (response.type == NetworkService.networkTypeSuccess) {
        if (response.data['cust_id'] != null) {
          EasyLoading.showSuccess('开户成功');
          Get.back();
        } else {
          EasyLoading.showError('开户失败');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void changePartnerFlag(String val) {
    partnerFlag.value = val;
  }
}
