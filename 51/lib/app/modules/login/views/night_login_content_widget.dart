import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/common_color.dart';
import '../../home/controllers/new_home_controller.dart';
import '../controllers/login_content_controller.dart';
import 'login_input_widget.dart';
import 'login_type_button_widget.dart';
import '../../tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';

import 'night_login_input_widget.dart';

///登录弹窗内，登录页面的内容
class NightLoginContentWidget extends StatefulWidget {
  const NightLoginContentWidget({super.key, this.callback});
  final VoidCallback? callback;

  @override
  State<NightLoginContentWidget> createState() => _LoginContentWidgetState();
}

class _LoginContentWidgetState extends State<NightLoginContentWidget> {
  late LoginContentController controller = Get.put(LoginContentController());
  late TabsController tabsController = Get.find<TabsController>();
  NewHomeController homeController = Get.find<NewHomeController>();

  @override
  void initState() {
    super.initState();
    controller.callback = widget.callback;
  }

  @override
  void dispose() {
    Get.delete<LoginContentController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 21.h),
      padding: EdgeInsets.only(left: 76.w, right: 76.w, top: 30.h),
      child: Column(
        children: [
          _loginTipsText(),
          Obx(() => _currentLoginTypeWidget(context)), //输入组件，根据不同的登录类型，展示不同输入组件
          _buildVerifyImageCode(), // 图形验证码
          SizedBox(
            height: 32.h,
          ),
          _errorTipsText(), //登录校验失败的提示信息
          _buildRememberPwd(), //记住密码、忘记密码的组件
          _buildLoginButton(), //登录按钮
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.theme1.images.login.iconLoginGame,
                        height: 52.h,
                        width: 52.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff86899B),
                          BlendMode.srcIn,
                        ),
                      ),
                      const Text(
                        "免费试玩",
                        style: TextStyle(color: Color(0xff86899B)),
                      )
                    ],
                  ),
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                    LoginManager.instance.isLoginDialogShowing = false;
                    homeController.changeTabIndex(1);
                  },
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.theme1.images.login.iconLoginCustom,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff86899B),
                          BlendMode.srcIn,
                        ),
                        height: 52.h,
                        width: 52.w,
                      ),
                      const Text(
                        "在线客服",
                        style: TextStyle(color: Color(0xff86899B)),
                      )
                    ],
                  ),
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                    if (TenantManager.instance.isCanOpenCustomerService) {
                      Get.toNamed(Routes.CUSTOMER_SERVICE);
                    } else {
                      String? onlineAddr =
                          TenantManager.instance.tenantBean?.tenant?.onlineAddr;
                      if (onlineAddr != null) {
                        String? type = TenantManager.instance.tenantBean
                            ?.sysOptions?.customerServiceSkipType;
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///输入组件，根据不同的登录类型，展示不同输入组件
  Widget _currentLoginTypeWidget(BuildContext context) {
    List<Widget> widgets;
    switch (controller.currentLoginType.value) {
      case LoginType.userNameLoginType: //用户名+密码登录
        widgets = [
          _buildUserNameWidget("${controller.currentLoginType.value}1"),
          // _pwdOrCodeLoginBtn(),
          _buildUserPwdWidget("${controller.currentLoginType.value}2")
        ];
        break;

      case LoginType.emailAndPwdLoginType: //邮箱+密码登录
        widgets = [
          _buildUserEmailWidget("${controller.currentLoginType.value}1"),
          _buildUserPwdWidget("${controller.currentLoginType.value}2"),
        ];
        break;
      case LoginType.emailAndCodeLoginType: //邮箱+验证码登录
        widgets = [
          _buildUserEmailWidget("${controller.currentLoginType.value}1"),
          _buildUserCodeWidget("${controller.currentLoginType.value}2")
        ];
        break;
      case LoginType.phoneLoginType: //电话+验证码登录
        widgets = [
          _buildUserPhoneWidget("${controller.currentLoginType.value}1",
              context: context),
          // _pwdOrCodeLoginBtn(),
          _buildUserCodeWidget("${controller.currentLoginType.value}2")
        ];
        break;
    }

    return Column(
      children: widgets,
    );
  }

  Widget _pwdOrCodeLoginBtn() {
    bool isShow =
        TenantManager.instance.tenantBean?.sysOptions?.loginMethodSwitch == "1";
    bool isUserNameMode =
        !isPhoneMode.value && controller.isNumeric(controller.userName.value);
    // bool isPhone =
    //     controller.currentLoginType.value == LoginType.phoneLoginType;
    //
    if (!isShow) {
      return const SizedBox.shrink();
    }

    if (controller.userName.isNotEmpty && !isUserNameMode) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 46.h, left: 30.w, right: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
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
                  colorFilter: controller.isPwdLogin.value
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
                  "密码登录",
                  style: TextStyle(
                      fontSize: 36.sp,
                      color: controller.isPwdLogin.value
                          ? context.theme.primaryColor
                          : Colors.black),
                )
              ],
            ),
          ),
          GestureDetector(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.changeLoginTypeStatus(false);
              },
              child: Row(
                children: [
                  SvgPicture.asset(Assets.theme1.images.login.iconLoginCode,
                      width: 42.w,
                      height: 42.h,
                      colorFilter: !controller.isPwdLogin.value
                          ? ColorFilter.mode(
                              context.theme.primaryColor,
                              BlendMode.srcIn,
                            )
                          : null),
                  SizedBox(
                    width: 18.w,
                  ),
                  Text(
                    "验证码登录",
                    style: TextStyle(
                        fontSize: 36.sp,
                        color: !controller.isPwdLogin.value
                            ? context.theme.primaryColor
                            : Colors.black),
                  )
                ],
              ))
        ],
      ),
    );
  }

  //登录校验失败的提示信息
  Widget _loginTipsText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "支持账号/手机号登录",
        style: TextStyle(fontSize: 36.sp, color: const Color(0xffAEB3CC)),
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
        ? NightLoginInputWidget(
            margin: EdgeInsets.only(top: 43.h),
            hint: "验证码",
            defaultContent: controller.verifyCode.value,
            headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
            loginInputType: LoginInputWidgetType.imageVerifyType,
            onChanged: (str) {
              controller.setImageVerifyCode(str);
            },
            onTap: () {
              AppManager.instance.tapVibrate();
              DebounceThrottle.debounce(controller.reqImageVerifyCode)();
            },
            imageUrl: controller.verifyImage.value,
          )
        : const SizedBox());
  }

  //记住密码、忘记密码的组件
  Widget _buildRememberPwd() {
    return Obx(() => (controller.currentLoginType.value ==
            LoginType.emailAndCodeLoginType)
        ? const SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 80.h),
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
                    InkWell(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller.isCheckRememberPwd(null);
                      },
                      child: Text(
                        controller.isNewLogin.value == false
                            ? "记住密码"
                            : (isPhoneMode.value ? "记住手机号" : "记住账号密码"),
                        style: TextStyle(
                          fontSize: 38.sp,
                          color: const Color(0xff6A6E81),
                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    showForgetPasswordDialog();
                  },
                  child: Row(
                    children: [
                      Text(
                        "忘记密码",
                        style: TextStyle(
                          fontSize: 38.sp,
                          color: const Color(0xff6A6E81),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, left: 20.w),
                        child: Image.asset(
                          Assets.theme1.images.home.iconNightForgetPwd.path,
                          width: 40.w,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
  }

  RxBool isPhoneMode = false.obs;
  //登录按钮
  Widget _buildLoginButton() {
    return SizedBox(
      width: 863.w,
      height: 108.h,
      child: Obx(() => ElevatedButton(
            onPressed: () {
              AppManager.instance.tapVibrate();
              if (!controller.isRequestLogin.value) {
                controller.login();
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(54.r), // 👈 设置圆角半径
                ),
                backgroundColor: controller.isRequestLogin.value
                    ? context.theme.primaryColor.withOpacity(0.3)
                    : context.theme.primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.isRequestLogin.value
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
                        "立即登录",
                        style: TextStyle(fontSize: 52.sp, color: Colors.black),
                      )
              ],
            ),
          )),
    );
  }

  //登录方式按钮 ： 账号登录、邮箱登录、手机登录
  Widget _buildBottomLoginTypeButton() {
    List<Widget> buttons = [];

    Widget? userLoginButton = _userLoginButton();
    Widget? phoneLoginButton = _phoneLoginButton();
    Widget? emailLoginButton = _emailLoginButton();

    switch (controller.currentLoginType.value) {
      case LoginType.userNameLoginType:
        if (phoneLoginButton != null) {
          buttons.add(phoneLoginButton);
        }
        if (emailLoginButton != null) {
          buttons.add(emailLoginButton);
        }
        break;

      case LoginType.emailAndPwdLoginType:
      case LoginType.emailAndCodeLoginType:
        if (userLoginButton != null) {
          buttons.add(userLoginButton);
        }
        if (phoneLoginButton != null) {
          buttons.add(phoneLoginButton);
        }
        break;

      case LoginType.phoneLoginType:
        if (userLoginButton != null) {
          buttons.add(userLoginButton);
        }
        if (emailLoginButton != null) {
          buttons.add(emailLoginButton);
        }
        break;
    }
    buttons.addAll([
      _gameButton(),
      _customButton(),
    ]);
    // controller.bottomLoginButtonList.value = buttons;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buttons as List<Widget>);
  }

  //在线客服按钮
  Widget _customButton() {
    return LoginTypeButtonWidget(
      title: "在线客服",
      iconPath: Assets.theme1.images.login.iconLoginCustom,
      buttonClick: () {
        Get.back();
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
        homeController.changeTabIndex(1);
      },
    );
  }

  //手机登录方式的按钮
  Widget? _phoneLoginButton() {
    if (controller.loginModeMap[LoginType.phoneLoginType] != true) {
      return null;
    }
    return LoginTypeButtonWidget(
      title: "手机登录",
      iconPath: Assets.theme1.images.login.iconLoginPhone,
      buttonClick: () {
        controller.changeLoginType(LoginType.phoneLoginType);
      },
    );
  }

  //账号登录方式的按钮
  Widget? _userLoginButton() {
    if (controller.loginModeMap[LoginType.userNameLoginType] != true) {
      return null;
    }
    return LoginTypeButtonWidget(
      title: "账号登录",
      iconPath: Assets.theme1.images.login.iconLoginUser,
      buttonClick: () {
        controller.changeLoginType(LoginType.userNameLoginType);
      },
    );
  }

  //邮箱登录方式的按钮
  Widget? _emailLoginButton() {
    if (controller.loginModeMap[LoginType.emailAndCodeLoginType] != true) {
      return null;
    }
    return LoginTypeButtonWidget(
      title: "邮箱",
      iconPath: Assets.theme1.images.login.iconLoginEmail,
      buttonClick: () {
        controller.changeLoginType(LoginType.emailAndCodeLoginType);
      },
    );
  }

  FocusNode? userNameFocusNode;
  FocusNode? pwdFocusNode;
  FocusNode? codeFocusNode;
  FocusNode? emailFocusNode;
  FocusNode? userPhoneFocusNode;
  //用户名的输入框
  Widget _buildUserNameWidget(String key) {
    if (userNameFocusNode == null) {
      userNameFocusNode = FocusNode();
      userNameFocusNode!.addListener(() {
        if (!userNameFocusNode!.hasFocus) {
          controller.loginVerify();
        }
      });
    }
    bool isShow =
        TenantManager.instance.tenantBean?.sysOptions?.loginMethodSwitch == "1";
    return NightLoginInputWidget(
      key: ValueKey(key),
      clickInput: () {
        FocusScope.of(context).requestFocus(userNameFocusNode);
      },
      margin: EdgeInsets.only(top: 43.h),
      focusNode: userNameFocusNode,
      hint: controller.isNewLogin.value ? '账号/手机号登录' : "用户名",
      headIconPath: Assets.theme1.images.login.iconInputLeftUser.path,
      autofocus: true,
      onChanged: (str) {
        if (controller.isNewLogin.value) {
          if (!controller.isNumeric(str)) {
            if (!isShow) {
              controller.currentLoginType.value = LoginType.userNameLoginType;
            }
            isPhoneMode.value = false;
          } else {
            controller.originUserName.value = str;
            if (!isShow) {
              controller.currentLoginType.value = LoginType.phoneLoginType;
              isPhoneMode.value = true;
            }
          }
        }
        controller.setUserName(str);
      },
      defaultContent: (controller.isNumeric(controller.originUserName.value) &&
              controller.isNewLogin.value)
          ? ((controller.isPwdLogin.value && isShow)
              ? controller.originUserName.value
              : controller.originUserPhone.value)
          : ((!controller.isPwdLogin.value && isShow)
              ? controller.originUserPhone.value
              : controller.originUserName.value),
    );
  }

  //密码输入框
  Widget _buildUserPwdWidget(String key) {
    if (pwdFocusNode == null) {
      pwdFocusNode = FocusNode();
      pwdFocusNode!.addListener(() {
        if (!pwdFocusNode!.hasFocus) {
          controller.loginVerify();
        }
      });
    }
    return NightLoginInputWidget(
      key: ValueKey(key),
      clickInput: () {
        FocusScope.of(context).requestFocus(pwdFocusNode);
      },
      focusNode: pwdFocusNode,
      margin: EdgeInsets.only(top: 43.h),
      hint: "密码",
      isShowPwd: true,
      defaultContent: controller.originUserPwd.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftPwd.path,
      onChanged: (str) {
        controller.setPwd(str);
      },
      loginInputType: LoginInputWidgetType.userPwdInputType,
    );
  }

  //验证码输入框
  Widget _buildUserCodeWidget(String key) {
    if (codeFocusNode == null) {
      codeFocusNode = FocusNode();
      codeFocusNode!.addListener(() {
        if (!codeFocusNode!.hasFocus) {
          controller.loginVerify();
        }
      });
    }
    return NightLoginInputWidget(
        key: ValueKey(key),
        margin: EdgeInsets.only(top: 43.h),
        hint: "验证码",
        focusNode: codeFocusNode,
        // defaultContent:
        //     controller.currentLoginType.value == LoginType.phoneLoginType
        //         ? controller.userCode.value
        //         : controller.emailCode.value,
        headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
        loginInputType: LoginInputWidgetType.codeType,
        onChanged: (str) {
          controller.setCode(str);
        },
        onValid: (Function cb) {
          if (controller.currentLoginType.value == LoginType.phoneLoginType) {
            return controller.reqSMSCode(cb);
          }
          return controller.reqEmailCode(cb);
        });
  }

  //邮箱输入框
  Widget _buildUserEmailWidget(String key) {
    if (emailFocusNode == null) {
      emailFocusNode = FocusNode();
      emailFocusNode!.addListener(() {
        if (!emailFocusNode!.hasFocus) {
          controller.loginVerify();
        }
      });
    }
    return NightLoginInputWidget(
      key: ValueKey(key),
      focusNode: emailFocusNode,
      margin: EdgeInsets.only(top: 43.h),
      hint: "邮箱",
      defaultContent: controller.originUserEmail.value,
      headIconPath: Assets.theme1.images.login.iconInputLeftEmail.path,
      loginInputType: LoginInputWidgetType.emailInputType,
      onChanged: (str) {
        controller.setEmail(str);
      },
    );
  }

  //手机输入框
  Widget _buildUserPhoneWidget(String key, {BuildContext? context}) {
    if (userPhoneFocusNode == null) {
      userPhoneFocusNode = FocusNode();
      userPhoneFocusNode!.addListener(() {
        if (!userPhoneFocusNode!.hasFocus) {
          controller.loginVerify();
        }
      });
    }
    bool isShow =
        TenantManager.instance.tenantBean?.sysOptions?.loginMethodSwitch == "1";
    return NightLoginInputWidget(
        key: ValueKey(key),
        margin: EdgeInsets.only(top: 43.h),
        hint: controller.isNewLogin.value ? '手机号/账号登录' : "用户名",
        autofocus: true,
        focusNode: userPhoneFocusNode,
        isShowCountryCode: false,
        defaultContent: controller.originUserName.value,
        headIconPath: Assets.theme1.images.login.iconInputLeftPhone.path,
        onChanged: (str) {
          controller.setPhone(str);
          if (!isShow) {
            if (controller.isNewLogin.value) {
              if (!controller.isNumeric(str)) {
                controller.originUserName.value = str;
                controller.currentLoginType.value = LoginType.userNameLoginType;
              } else {
                controller.currentLoginType.value = LoginType.phoneLoginType;
              }
            }
          }
        },
        // loginInputType: controller.isNewLogin.value
        //                 ? NightLoginInputWidgetType.userPwdInputType
        //                 : NightLoginInputWidgetType.phoneInputType,
        isNewPhone: controller.isNewLogin.value ? true : false,
        countryCode: controller.countryCode.value,
        countrys: controller.countrys,
        onCounrtyChanged: (code) {
          controller.setCountryCode(code);
        });
  }
}
