import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/login/data/contact_config_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/user_info_bean2.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/change_name_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/change_sex_dialog.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/regex_util.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/login_manager.dart';
import '../../../../utils/sp_util.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../data/login_bean.dart';
import '../widget/change_phone_dialog.dart';

//个人信息临时实体类
class UserInfoBean {
  final String title;
  RxString desc = "".obs;
  UserInfoBean({required this.title, String desc = ""}) {
    this.desc.value = desc;
  }
}

class UserInfoController extends GetxController {
  RxString userHead = "".obs;
  var infoList = <UserInfoBean>[
    UserInfoBean(title: "姓名", desc: "请填写真实姓名"),
    UserInfoBean(title: "昵称"),
    UserInfoBean(title: "账户ID"),
    UserInfoBean(title: "手机号", desc: "绑定手机号保护账户安全"),
    UserInfoBean(title: "性别", desc: "未设置"),
    UserInfoBean(title: "生日", desc: "未设置"),
  ];
  late UserInfoBean2 userInfoBean2;
  bool isShowSendCode = false; //绑定手机号码的弹窗是否显示发送验证码的选项，默认为不显示
  RxBool isLoading = false.obs;
  bool isShowBindPhoneDialog = false; // 是否直接打开绑定手机弹窗，默认false
  bool isShowBirthday = false; // 是否直接打开绑定手机弹窗，默认false

  // ------------------------------------
  RxList<CountryCode> countrys = <CountryCode>[].obs;
  final Map<String, dynamic> _defaultCountryCode = {
    'name': 'Brazil',
    'code': 'BR',
    'dial_code': '+55',
  };
  late Rx<CountryCode> countryCode =
      CountryCode.fromJson(_defaultCountryCode).obs;
  RxList<CountryCode> countryList = <CountryCode>[].obs; // 存放所有国家数据

  RxString originUserPhone = "".obs; // 手机号
  RxString userPhone = "".obs; // 手机号
  RxString userCode = "".obs; // 验证码
  RxBool isSendCodeLoading = false.obs;
  // ------------------------------------
  RxBool canUpdatePhone = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map<String, dynamic>;
      isShowSendCode = arguments['isShowSendCode'] ?? false;
      isShowBindPhoneDialog = arguments['isShowBindPhoneDialog'] ?? false;
      isShowBirthday = arguments['isShowBirthday'] ?? false;
    }

    _reqContactInfo();
    initUserInfo();
  }

  @override
  void onReady() {
    super.onReady();
    if (isShowBindPhoneDialog) {
      bandPhone();
    } else if (isShowBirthday) {
      if (hasBirthday) {
        EasyLoading.showToast('生日已经设置了');
        return;
      }
      showCustomDatePicker(Get.context!, 5);
    }
  }

  void clickItem(int index) async {
    switch (index) {
      case 0: //姓名
        if (infoList[0].desc.value.isNotEmpty) return; //不为空就不给点击了
        String oriValue = infoList[0].desc.value;
        String value = await Get.dialog(
          ChangeNameDialog(isRealName: true, oriValue: oriValue),
          barrierDismissible: false,
        );
        if (value.isNotEmpty) {
          infoList[index].desc.value = value;
        }
        break;
      case 1: //nic
        String oriValue = infoList[1].desc.value;
        String value = await Get.dialog(
          ChangeNameDialog(oriValue: oriValue),
          barrierDismissible: false,
        );
        if (value.isNotEmpty) {
          infoList[index].desc.value = value;
          LoginManager.instance.loginInfo?.nickname = value;
          //更新SP缓存
          await SpUtil.saveBean<LoginBean>(
              "loginBean", LoginManager.instance.loginInfo!);
        }
        break;
      case 3: //手机号
        if (canUpdatePhone.value) {
          bandPhone();
        }
        break;
      case 4: //性别
        String value = await Get.dialog(
            ChangeSexDialog(
              userInfo: userInfoBean2,
            ),
            barrierDismissible: false);
        if (value.isNotEmpty) {
          infoList[index].desc.value = value;
          initUserInfo(isShowLoading: false);
        }
        break;
      case 5: //生日
        if (hasBirthday) {
          EasyLoading.showToast('生日已经设置了');
          return;
        }
        showCustomDatePicker(Get.context!, index);
        break;
    }
  }

  void showCustomDatePicker(BuildContext context, int index) {
    final DateTime initialDate = DateTime.now(); // 或你想要的默认值
    // 在构建组件后，你可以直接使用 initialDate
    var defaultFormatted = DateFormat('MMdd').format(initialDate);
    Get.dialog(
        Dialog(
          backgroundColor: context.customTheme?.dialogBgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(30.w),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text('设置生日',
                          style: TextStyle(
                              fontSize: 18,
                              color: context.customTheme?.titleColor)),
                      const SizedBox(height: 12),
                      Expanded(
                        child: DatePickerWidget(
                          onMonthChangeStartWithFirstDate: false,
                          pickerTheme: const DateTimePickerTheme(
                            showTitle: false, // ✅ 隐藏顶部按钮
                          ),
                          locale: DateTimePickerLocale.zh_cn,
                          dateFormat: 'MM月-dd日',
                          onChange: (date, _) {
                            defaultFormatted = DateFormat('MMdd').format(date);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 1.sw,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.theme.primaryColor,
                            foregroundColor: Colors.white, // 文字颜色
                          ),
                          onPressed: () async {
                            EasyLoading.show(indicator: CommonLoadingView());
                            try {
                              int operMethod = 2;
                              var oriValue = '未设置';
                              if (hasBirthday) {
                                oriValue = userInfoBean2.birthday ?? '';
                              } else {
                                operMethod = 1;
                              }
                              String newValue = defaultFormatted;

                              var data = {
                                'ori_value': oriValue,
                                'new_value': newValue,
                                'trans_type': 101,
                                'busi_type': 202,
                                'oper_method': operMethod,
                              };
                              NetworkResponse res =
                                  await UserApi().setContactMessage(data);
                              bool isSuccess = false;
                              if (res.type ==
                                  NetworkService.networkTypeSuccess) {
                                if (res.data['response_code'] == '9999') {
                                  isSuccess = true;
                                }
                              }
                              if (isSuccess) {
                                infoList[index].desc.value =
                                    formatToMonthDay(defaultFormatted);
                                hasBirthday = true;
                              } else {
                                EasyLoading.showToast("设置失败:${res.data}");
                              }
                            } finally {
                              EasyLoading.dismiss();
                            }
                            Navigator.pop(context);
                          },
                          child: const Text("确认"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          '生日当天可获得生日红包',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          '生日一旦设置，不可更改',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    child: CommonRipple(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close,
                          color: context.customTheme?.dialogXColor),
                    ),
                    right: 0,
                  )
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }

  String formatToMonthDay(String raw) {
    if (raw.length != 4) return raw;

    final month = int.tryParse(raw.substring(0, 2));
    final day = int.tryParse(raw.substring(2, 4));

    if (month == null || day == null) return raw;

    return '${month}月${day}日';
  }

  void bandPhone() async {
    String? value = await Get.dialog(
        ChangePhoneDialog(
          isShowSendCode: isShowSendCode,
        ),
        barrierDismissible: false);
    if (value != null) {
      infoList[3].desc.value = value;
    }
  }

  bool hasBirthday = false;
  //初始化用户信息
  Future<void> initUserInfo({bool isShowLoading = true}) async {
    if (isShowLoading) {
      EasyLoading.show(indicator: const CommonLoadingView());
    }

    final res = await SystemApi.reqConfig('CUST_PHONE_DISPLAY_SWITCH');

    if (res.type == NetworkService.networkTypeSuccess) {
      String? value = res.data['value'];
      if (value == '0') {
        // print('绑定后，不可以修改手机号');
        canUpdatePhone.value = false;
      }
    }

    String head = LoginManager.instance.loginInfo?.head ?? '';
    if (head.startsWith('http')) {
      userHead.value = head;
    } else {
      String imgDomain = await TenantManager.instance.getCurrentImgDomain();
      if (imgDomain.isNotEmpty) {
        userHead.value = "$imgDomain/$head";
      }
    }

    var userInfoBean2 = await UserApi().reqUserInfo();
    if (userInfoBean2 != null) {
      this.userInfoBean2 = userInfoBean2;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        String mobileCountry = userInfoBean2.mobileCountry ?? '';
        String mobilePhone = userInfoBean2.mobilePhone ?? '';

        infoList[0].desc.value = userInfoBean2.contactName ?? "请填写真实姓名";
        infoList[1].desc.value =
            LoginManager.instance.loginInfo?.nickname ?? "";
        infoList[2].desc.value =
            LoginManager.instance.loginInfo?.custId?.toString() ?? "";
        infoList[3].desc.value =
            mobilePhone.isEmpty ? "绑定手机号保护账户安全" : mobilePhone;
        if (mobilePhone.isEmpty) {
          canUpdatePhone.value = true;
        }
        infoList[4].desc.value = '未设置';
        if (userInfoBean2.gender != null) {
          if (userInfoBean2.gender == 1) {
            infoList[4].desc.value = '男';
          } else if (userInfoBean2.gender == 2) {
            infoList[4].desc.value = '女';
          }
        }
        hasBirthday = userInfoBean2.birthday_set == "1";
        infoList[5].desc.value = '未设置';
        if (userInfoBean2.birthday_set == "1") {
          infoList[5].desc.value =
              formatToMonthDay(userInfoBean2.birthday ?? "");
        }
        // 如果有手机号
        if (mobilePhone.isNotEmpty) {
          originUserPhone.value = mobilePhone;
          userPhone.value = mobilePhone;
        }

        // 区号和系统配置不一致时，修改默认值
        if (mobileCountry.isNotEmpty &&
            mobileCountry != countryCode.value.name) {
          for (int i = 0; i < countryList.length; i++) {
            CountryCode countryItem = countryList[i];

            if (countryItem.name == mobileCountry) {
              countryCode.value = countryItem;
            }
          }
        }
      });
    }
    EasyLoading.dismiss();
  }

  // 请求租户注册联系人配置
  Future<void> _reqContactInfo() async {
    final res = await LoginApi.reqContactConfig();

    if (res.type == NetworkService.networkTypeSuccess) {
      SysLoginOptionsBean sysLoginOptions =
          ContactConfigBean.fromJson(res.data).sysLoginOptions!;

      _initLoginType(sysLoginOptions);
    }
  }

  // 初始化登录类型
  _initLoginType(SysLoginOptionsBean sysLoginOptions) {
    CountryCode? defaultCountryCode;

    sysLoginOptions.SMS_OPEN_COUNTRY!.forEach((key, value) {
      var splitValue = value.split('+');
      var code = splitValue[0].trim();
      var dialCode = splitValue[1].trim();
      var country = CountryCode(name: key, code: code, dialCode: dialCode);
      countrys.add(country);

      countryList.add(CountryCode.fromJson({
        "name": key,
        "code": code,
        "dial_code": dialCode,
      }));

      defaultCountryCode ??= country;
    });

    if (countrys.isNotEmpty) {
      countryCode.value = defaultCountryCode!;
    }
  }

  //设置电话号码
  void setPhone(String str) {
    userPhone.value = str;
  }

  // 设置选中的国家地区
  void setCountryCode(CountryCode code) {
    countryCode.value = code;
  }

  //设置验证码
  void setCode(String str) {
    userCode.value = str;
  }

  // 验证手机
  bool _validPhoneCode() {
    if (userPhone.value.isEmpty) {
      EasyLoading.showToast('手机号不能为空');
      return false;
    }

    if (!RegexUtils.isMobileSimple(userPhone.value)) {
      EasyLoading.showToast('请输入正确的[手机号]');
      return false;
    }

    return true;
  }

  //电话+验证码的验证
  bool _validUserCode() {
    if (userCode.value.isEmpty) {
      EasyLoading.showToast('验证码不能为空');
      return false;
    }

    return true;
  }

  // 获取手机验证码
  Future<void> reqSMSCode(Function callback) async {
    if (isSendCodeLoading.value) {
      return;
    }

    if (!_validPhoneCode()) {
      return;
    }

    var data = {
      'verifycode_key': '',
      'verifycode': '',
      'country': countryCode.value.name,
      'receive_mobile': userPhone.value,
      'type': 5,
    };

    EasyLoading.show(indicator: const CommonLoadingView());
    isSendCodeLoading.value = true;
    final res = await LoginApi.reqSMSCode(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      final resData = res.data;
      if (resData != null && resData['response_code'] == '9999') {
        callback();
        EasyLoading.showSuccess('发送成功');
      }
    }
    EasyLoading.dismiss();
    isSendCodeLoading.value = false;
  }

  Future<void> reqBindPhone() async {
    if (!_validPhoneCode()) {
      return;
    }

    if (!_validUserCode()) {
      return;
    }

    isLoading.value = true;

    var data = {
      'phone': userPhone.value,
      'smsCode': userCode.value,
      'ori_value': originUserPhone.value,
      'new_value': userPhone.value,
      'trans_type': 104,
      'busi_type': 214,
      'oper_method': originUserPhone.value.isEmpty ? 1 : 2,
    };

    bool success = await UserApi().bindPhoneByCode(data);
    isLoading.value = false;
    if (success) {
      Get.back(result: userPhone.value);
      // Get.snackbar("修改成功!", "");
      EasyLoading.showSuccess("修改成功!");
    }
  }
}
