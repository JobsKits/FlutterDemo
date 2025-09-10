import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/login/controllers/register_content_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/tenant_manager.dart';
import '../../tabs/controllers/tabs_controller.dart';
import 'login_input_widget.dart';
import 'login_type_button_widget.dart';

///登录弹窗内，登录页面的内容
class RegisterContentWidget extends StatefulWidget {
  final VoidCallback? callback;
  const RegisterContentWidget({super.key, this.callback});

  @override
  State<RegisterContentWidget> createState() => _LoginContentWidgetState();
}

class _LoginContentWidgetState extends State<RegisterContentWidget> {
  late RegisterContentController controller =
      Get.put(RegisterContentController());
  late TabsController tabsController = Get.find<TabsController>();
  @override
  void initState() {
    super.initState();
    controller.callback = widget.callback;
  }

  @override
  void dispose() {
    Get.delete<RegisterContentController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 21.h),
      padding: EdgeInsets.symmetric(horizontal: 76.w),
      decoration: BoxDecoration(
        color: context.customTheme?.pageBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() => Column(
            children: [
              if (controller.isNewLogin.value) ...[_loginTipsText()],
              _currentLoginTypeWidget(context), //输入组件，根据不同的登录类型，展示不同输入组件
              _buildVerifyImageCode(), // 图形验证码
              SizedBox(
                height: 32.h,
              ),
              _errorTipsText(), //登录校验失败的提示信息
              _buildRememberPwd(), //记住密码、忘记密码的组件
              // _buildRememberPwd(), //记住密码、忘记密码的组件
              _buildLoginButton(), //登录按钮
              Container(
                margin: EdgeInsets.only(top: 90.h, bottom: 51.h),
                width: double.infinity,
                child: _buildBottomRegisterTypeButton(), //登录方式按钮
              ),
            ],
          )),
    );
  }

  ///输入组件，根据不同的登录类型，展示不同输入组件
  Widget _currentLoginTypeWidget(BuildContext context) {
    List<Widget> widgets = [];
    switch (controller.currentRegisterType.value) {
      case RegisterType.userNameRegisterType: //用户密码登录
        widgets.addAll([
          _buildUserNameWidget("${controller.currentRegisterType.value}1"),
          _pwdOrCodeLoginBtn(),
          _buildUserPwdWidget("${controller.currentRegisterType.value}2"),
        ]);
        break;
      case RegisterType.emailRegisterType: //邮箱+验证码+密码登录
        widgets.addAll([
          _buildUserEmailWidget("${controller.currentRegisterType.value}1"),
          _buildUserPwdWidget("${controller.currentRegisterType.value}2"),
          _buildUserCodeWidget("${controller.currentRegisterType.value}3"),
        ]);
        break;
      case RegisterType.phoneRegisterType: //电话+验证码登录
        if (controller.isNewLogin.value) {
          widgets.addAll([
            // _buildUserNameWidget("${controller.currentRegisterType.value}1"),
            _buildUserPhoneWidget("${controller.currentRegisterType.value}2",
                context: context, isOnlyPhone: true),
            _pwdOrCodeLoginBtn(),
            // _buildUserPwdWidget("${controller.currentRegisterType.value}3"),
            _buildUserCodeWidget("${controller.currentRegisterType.value}4"),
          ]);
        } else {
          widgets.addAll([
            _buildUserNameWidget("${controller.currentRegisterType.value}1"),
            _pwdOrCodeLoginBtn(),
            _buildUserPhoneWidget("${controller.currentRegisterType.value}2",
                context: context),
            _buildUserPwdWidget("${controller.currentRegisterType.value}3"),
            _buildUserCodeWidget("${controller.currentRegisterType.value}4"),
          ]);
        }
        break;
    }

    // 重复密码
    if (controller.hasRepassWord.value) {
      widgets.add(
        _buildUserConfirmPwdWidget("${controller.currentRegisterType.value}8"),
      );
    }

    // 真实姓名
    if (controller.hasRealName.value) {
      widgets.add(
        _buildRealNameWidget("${controller.currentRegisterType.value}9"),
      );
    }

    // 昵称
    if (controller.hasNickName.value) {
      widgets.add(
        _buildNickNameWidget("${controller.currentRegisterType.value}10"),
      );
    }

    // 资金密码
    if (controller.hasAcctPwd.value) {
      widgets.add(
        _buildAccPwdWidget("${controller.currentRegisterType.value}11"),
      );
    }

    // MobilePhone
    if (controller.hasPhone.value &&
        controller.currentRegisterType.value !=
            RegisterType.phoneRegisterType) {
      widgets.add(
        _buildUserPhoneWidget(
          "${controller.currentRegisterType.value}12",
          context: context,
        ),
      );
    }

    // Zalo
    if (controller.hasZalo.value) {
      widgets.add(
        _buildZaloWidget("${controller.currentRegisterType.value}13"),
      );
    }

    // Line
    if (controller.hasLine.value) {
      widgets.add(
        _buildLineWidget("${controller.currentRegisterType.value}14"),
      );
    }

    // Facebook
    if (controller.hasFacebook.value) {
      widgets.add(
        _buildFacebookWidget("${controller.currentRegisterType.value}15"),
      );
    }

    // telegram
    if (controller.hasTelegram.value) {
      widgets.add(
        _buildTelegramWidget("${controller.currentRegisterType.value}16"),
      );
    }

    // WhatsApp
    if (controller.hasWhatsApp.value) {
      widgets.add(
        _buildWhatsAppWidget("${controller.currentRegisterType.value}17"),
      );
    }

    // 邮箱
    if (controller.currentRegisterType.value !=
            RegisterType.emailRegisterType &&
        controller.hasEmail.value) {
      widgets.add(
        _buildEmailWidget("${controller.currentRegisterType.value}18"),
      );
    }

    // QQ
    if (controller.hasQQ.value) {
      widgets.add(
        _buildUserQQWidget("${controller.currentRegisterType.value}19"),
      );
    }

    //  邀请码
    if (controller.hasInvite.value) {
      widgets.add(
        _buildUserInviteCodeWidget("${controller.currentRegisterType.value}20"),
      );
    }

    return Column(
      children: widgets,
    );
  }

  //登录校验失败的提示信息
  Widget _loginTipsText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "支持账号/手机号注册",
        style: TextStyle(fontSize: 36.sp, color: Color(color99999)),
      ),
    );
  }

  //登录校验失败的提示信息
  Widget _errorTipsText() {
    return Obx(() {
      final errorText = controller.verifyErrorTips.value;
      if (errorText.isEmpty) return const SizedBox();
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(errorText,
                style: TextStyle(fontSize: 38.sp, color: Colors.red)),
          ),
          SizedBox(height: 32.h),
        ],
      );
    });
  }

  // 图形验证码
  Widget _buildVerifyImageCode() {
    return Obx(() => controller.isShowImageVerifyCode.value
        ? LoginInputWidget(
            margin: EdgeInsets.only(top: 43.h),
            hint: "验证码",
            defaultContent: controller.verifyCode.value,
            headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
            loginInputType: LoginInputWidgetType.imageVerifyType,
            // maxLength: 4,
            onChanged: (str) {
              controller.setImageVerifyCode(str);
            },
            onTap: () {
              DebounceThrottle.debounce(controller.reqImageVerifyCode)();
            },
            imageUrl: controller.verifyImage.value,
          )
        : const SizedBox());
  }

  //记住密码、忘记密码的组件
  Widget _buildRememberPwd() {
    return Obx(() => (controller.currentRegisterType.value ==
            RegisterType.emailRegisterType)
        ? const SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 86.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 48.w, // 设置宽度
                      height: 48.h, // 设置高度
                      child: Transform.scale(
                        scale: 0.8,
                        child: Obx(() => Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50), // 圆形
                              ),
                              value: controller.isRememberPwd.value,
                              onChanged: (bool? value) {
                                controller.isCheckRememberPwd(value);
                              },
                              activeColor: context.theme.primaryColor, // 选中颜色
                              checkColor: Colors.white, // 选中时的勾选颜色
                              side: const BorderSide(
                                  color: Colors.grey), // 未选中时的边框颜色
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller.isCheckRememberPwd(null);
                      },
                      child: Obx(() => Text(
                            controller.isNewLogin.value
                                ? (isPhoneMode.value ? "记住手机号" : "记住账号密码")
                                : "记住密码",
                            style: TextStyle(
                                fontSize: 38.sp,
                                color: const Color(color99999)),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ));
  }

  //登录按钮
  Widget _buildLoginButton() {
    return SizedBox(
      width: 863.w,
      height: 125.h,
      child: Obx(() => ElevatedButton(
            onPressed: () {
              AppManager.instance.tapVibrate();
              if (!controller.isRequestRegister.value) {
                controller.reqRegister();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: controller.isRequestRegister.value
                    ? context.theme.primaryColor.withOpacity(0.3)
                    : context.theme.primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.isRequestRegister.value
                    ? SizedBox(
                        width: 48.w,
                        height: 48.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.w,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(colorFFFFFF),
                          ), // 圆圈颜色
                        ),
                      )
                    : Text(
                        "注册",
                        style: TextStyle(fontSize: 52.sp, color: Colors.white),
                      )
              ],
            ),
          )),
    );
  }

  //登录方式按钮 ： 账号登录、邮箱登录、手机登录
  Widget _buildBottomRegisterTypeButton() {
    List<Widget> buttons = [];

    Widget? phoneRegistButton = _phoneRegisterButton();
    Widget? emailRegistButton = _emailRegisterButton();
    Widget? userNameRegistButton = _userNameRegisterButton();

    switch (controller.currentRegisterType.value) {
      case RegisterType.userNameRegisterType:
        if (phoneRegistButton != null) {
          buttons.add(phoneRegistButton);
        }
        if (emailRegistButton != null) {
          buttons.add(emailRegistButton);
        }
        break;
      case RegisterType.emailRegisterType:
        if (userNameRegistButton != null) {
          buttons.add(userNameRegistButton);
        }
        if (phoneRegistButton != null) {
          buttons.add(phoneRegistButton);
        }
        break;
      case RegisterType.phoneRegisterType:
        if (userNameRegistButton != null) {
          buttons.add(userNameRegistButton);
        }
        if (emailRegistButton != null) {
          buttons.add(emailRegistButton);
        }
        break;
    }

    buttons.addAll([
      _gameButton(),
      _customButton(),
    ]);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, children: buttons);
  }

  //在线客服按钮
  Widget _customButton() {
    return LoginTypeButtonWidget(
      title: "在线客服",
      iconPath: Assets.theme1.images.login.iconLoginCustom,
      buttonClick: () {
        Get.back();
        LoginManager.instance.isLoginDialogShowing = false;
        if (TenantManager.instance.isCanOpenCustomerService) {
          Get.toNamed(Routes.CUSTOMER_SERVICE);
        } else {
          String? onlineAddr =
              TenantManager.instance.tenantBean?.tenant?.onlineAddr;
          if (onlineAddr != null) {
            String? type = TenantManager
                .instance.tenantBean?.sysOptions?.customerServiceSkipType;
            if (type == '1') {
              launchUrl(Uri.parse(onlineAddr),
                  mode: LaunchMode.externalApplication);
            } else {
              Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                "url": onlineAddr, //请求地址
                "title": "在线客服",
              });
            }
          }
        }
      },
    );
  }

  //随便逛逛的按钮
  Widget _gameButton() {
    return LoginTypeButtonWidget(
      title: "免费试玩",
      iconPath: Assets.theme1.images.login.iconLoginGame,
      buttonClick: () {
        Get.back();
        LoginManager.instance.isLoginDialogShowing = false;
        Get.toNamed(Routes.GAME_TRY);
      },
    );
  }

  //手机登录方式的按钮
  Widget? _phoneRegisterButton() {
    if (controller.registerModeMap[RegisterType.phoneRegisterType] != true) {
      return null;
    }
    return LoginTypeButtonWidget(
      title: "手机注册",
      iconPath: Assets.theme1.images.login.iconLoginPhone,
      buttonClick: () {
        controller.changeRegisterType(RegisterType.phoneRegisterType);
      },
    );
  }

  //账号登录方式的按钮
  Widget? _userNameRegisterButton() {
    if (controller.registerModeMap[RegisterType.userNameRegisterType] != true) {
      return null;
    }
    return LoginTypeButtonWidget(
      title: "账号注册",
      iconPath: Assets.theme1.images.login.iconLoginUser,
      buttonClick: () {
        controller.changeRegisterType(RegisterType.userNameRegisterType);
      },
    );
  }

  //邮箱登录方式的按钮
  Widget? _emailRegisterButton() {
    if (controller.registerModeMap[RegisterType.emailRegisterType] != true) {
      return null;
    }
    return LoginTypeButtonWidget(
      title: "邮箱注册",
      iconPath: Assets.theme1.images.login.iconLoginEmail,
      buttonClick: () {
        controller.changeRegisterType(RegisterType.emailRegisterType);
      },
    );
  }

  RxBool isPhoneMode = true.obs;
  //用户名的输入框
  Widget _buildUserNameWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: controller.isNewLogin.value ? '账号/手机号注册' : "用户名",
      headIconPath: Assets.theme1.images.login.iconInputLeftUser.path,
      autofocus: true,
      defaultContent: controller.defualtContent.value,
      onChanged: (str) {
        controller.setUserName(str);
        if (controller.isNewLogin.value) {
          if (!isNumeric(str)) {
            controller.currentRegisterType.value =
                RegisterType.userNameRegisterType;
            isPhoneMode.value = false;
          } else {
            controller.setDefualtContent(str);
            controller.currentRegisterType.value =
                RegisterType.phoneRegisterType;
            isPhoneMode.value = true;
          }
        }
      },
    );
  }

  //密码输入框
  Widget _buildUserPwdWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "密码",
      isShowPwd: false,
      headIconPath: Assets.theme1.images.login.iconInputLeftPwd.path,
      onChanged: (str) {
        controller.setPwd(str);
      },
      loginInputType: LoginInputWidgetType.userPwdInputType,
    );
  }

  //密码输入框
  Widget _buildUserConfirmPwdWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "再次确认密码",
      isShowPwd: false,
      defaultContent: controller.userConfirmPwd.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftPwd.path,
      onChanged: (str) {
        controller.setConfirmPwd(str);
      },
      loginInputType: LoginInputWidgetType.userPwdInputType,
    );
  }

  //邀请码输入框
  Widget _buildUserInviteCodeWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入邀请码",
      defaultContent: controller.userInviteCode.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
      onChanged: (str) {
        controller.setInviteCode(str);
      },
      loginInputType: LoginInputWidgetType.textInputType,
    );
  }

  //QQ输入框
  Widget _buildUserQQWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入QQ号",
      defaultContent: controller.qq.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
      onChanged: (str) {
        controller.setQQ(str);
      },
      loginInputType: LoginInputWidgetType.textInputType,
    );
  }

  //验证码输入框
  Widget _buildUserCodeWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "验证码",
      defaultContent: controller.userCode.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
      loginInputType: LoginInputWidgetType.codeType,
      onChanged: (str) {
        controller.setCode(str);
      },
      onValid: (Function cb) {
        if (controller.currentRegisterType.value ==
            RegisterType.phoneRegisterType) {
          return controller.reqSMSCode(cb);
        }
        return controller.reqEmailCode(cb);
      },
    );
  }

  // 用户账号邮箱输入框
  Widget _buildUserEmailWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "邮箱",
      defaultContent: controller.userEmail.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.emailInputType,
      onChanged: (str) {
        controller.setUserEmail(str);
      },
    );
  }

  // WhatsApp输入框
  Widget _buildWhatsAppWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入WhatsApp",
      defaultContent: controller.whatsApp.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setWhatsApp(str);
      },
    );
  }

  // Telegram输入框
  Widget _buildTelegramWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入Telegram",
      defaultContent: controller.telegram.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setTelegram(str);
      },
    );
  }

  // Facebook输入框
  Widget _buildFacebookWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入Facebook",
      defaultContent: controller.facebook.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setFacebook(str);
      },
    );
  }

  // Line输入框
  Widget _buildLineWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入Line",
      defaultContent: controller.line.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setLine(str);
      },
    );
  }

  // Zalo输入框
  Widget _buildZaloWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入Zalo",
      defaultContent: controller.zalo.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setZalo(str);
      },
    );
  }

  // Accpwd输入框
  Widget _buildAccPwdWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入6位纯数字组成的资金密码",
      defaultContent: controller.acctPwd.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setAcctPwd(str);
      },
    );
  }

  // NickName输入框
  Widget _buildNickNameWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入昵称",
      defaultContent: controller.nickName.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setNickName(str);
      },
    );
  }

  // 真实姓名输入框
  Widget _buildRealNameWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "真实姓名与提现账户名称一致",
      defaultContent: controller.contactName.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.textInputType,
      onChanged: (str) {
        controller.setContactName(str);
      },
    );
  }

  // 邮箱输入框
  Widget _buildEmailWidget(String key) {
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: "请输入邮箱号",
      defaultContent: controller.email.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.emailInputType,
      onChanged: (str) {
        controller.setEmail(str);
      },
    );
  }

  //手机输入框
  Widget _buildUserPhoneWidget(String key,
      {BuildContext? context, bool isOnlyPhone = false}) {
    if (controller.defualtContent.value.isNotEmpty) {
      controller.setPhone(controller.defualtContent.value);
      if (isOnlyPhone) {
        controller.setUserName(controller.defualtContent.value);
      }
    }
    return LoginInputWidget(
      key: ValueKey(key),
      margin: EdgeInsets.only(top: 43.h),
      hint: controller.isNewLogin.value ? '手机号/账号注册' : "手机号",
      defaultContent: controller.defualtContent.value,
      autofocus: true,
      isShowCountryCode: false,
      headIconPath: Assets.theme1.images.login.iconInputLeftPhone.path,
      onChanged: (str) {
        controller.setPhone(str);
        if (isOnlyPhone) {
          controller.setUserName(str);
        }
        if (controller.isNewLogin.value) {
          if (!isNumeric(str)) {
            controller.defualtContent.value = str;
            controller.currentRegisterType.value =
                RegisterType.userNameRegisterType;
            controller.setDefualtContent(str);
          } else {
            controller.defualtContent.value = str;
            controller.currentRegisterType.value =
                RegisterType.phoneRegisterType;
          }
        }
      },
      // loginInputType: controller.isNewLogin.value
      //                   ? LoginInputWidgetType.userPwdInputType
      //                   : LoginInputWidgetType.phoneInputType,
      isNewPhone: controller.isNewLogin.value ? true : false,
      countryCode: controller.countryCode.value,
      countrys: controller.countrys,
      onCounrtyChanged: (code) {
        controller.setCountryCode(code);
      },
    );
  }

  bool isNumeric(String text) {
    final RegExp numericRegExp = RegExp(r'^[0-9]{6,}$');
    return numericRegExp.hasMatch(text);
  }

  Widget _pwdOrCodeLoginBtn() {
    bool isShow = TenantManager
            .instance.tenantBean?.sysOptions?.registerShowMethodSwitch ==
        "1";
    if (!isShow) {
      return SizedBox.shrink();
    }

    if (controller.userName.isNotEmpty) {
      return SizedBox.shrink();
    }

    isPhoneMode.value;
    return Padding(
      padding: EdgeInsets.only(top: 46.h, left: 30.w, right: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.changeLoginTypeStatus(true);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.theme1.images.login.iconLoginPwd,
                  width: 42.w,
                  height: 42.h,
                  colorFilter: controller.isPwdRegister.value
                      ? ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        )
                      : null,
                ),
                SizedBox(
                  width: 18.w,
                ),
                Text(
                  "密码注册",
                  style: TextStyle(
                      fontSize: 36.sp,
                      color: controller.isPwdRegister.value
                          ? context.theme.primaryColor
                          : Colors.black),
                )
              ],
            ),
          ),
          CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.changeLoginTypeStatus(false);
              },
              child: Row(
                children: [
                  SvgPicture.asset(Assets.theme1.images.login.iconLoginCode,
                      width: 42.w,
                      height: 42.h,
                      colorFilter: !controller.isPwdRegister.value
                          ? ColorFilter.mode(
                              context.theme.primaryColor,
                              BlendMode.srcIn,
                            )
                          : null),
                  SizedBox(
                    width: 18.w,
                  ),
                  Text(
                    "验证码注册",
                    style: TextStyle(
                        fontSize: 36.sp,
                        color: !controller.isPwdRegister.value
                            ? context.theme.primaryColor
                            : Colors.black),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
