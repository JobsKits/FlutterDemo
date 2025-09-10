import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:get/get.dart';
import '../../controllers/global_state_controller.dart';
import '../../services/account_service.dart';
import '../../services/api/api_service.dart';
import '../setup/a_model/auth_config_api_model.dart';
import 'model/model.dart';

class BindController extends GetxController {
  BindController();

  final GlobalStateController globalController = Get.find<GlobalStateController>();
  AccountServiceListener? _accountListener;
  final model = RegularModel().obs;
  /// 1 谷歌验证 2 资金密码 3 全部
  final checkIndex = 0.obs; 
  /// 后台配置 0 绑定邮箱 1 绑定手机号 2 绑定邮箱 手机号  3 无需绑定
  final bindIndex = 0.obs; 
  /// 前台显示 0 绑定邮箱 1 绑定手机号 2 绑定邮箱 手机号  3 显示资金密码 4 显示谷歌验证 5 提款页面
  final showIndex = 0.obs; 
  /// 显示 邮箱，手机 切换文案
  final showTitle = false.obs; 
  /// 显示手机验证
  final showPhone = false.obs; 
  /// 是否绑定了邮箱
  final isBindEmail = false.obs; 
  /// 是否绑定了手机号
  final isBindPhone = false.obs; 
  /// 是否设置资金密码
  final isPayed = false.obs; 
  /// 是否设置谷歌验证
  final isGoogled = false.obs; 

  final firstTimeBind = false.obs;


  _initData() {
    update(["bind"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    loadAuthConfigData();
    getBrandBaseInfo();
    ever(globalController.registerIndex, (callback) => getBrandDetail());
    ever(globalController.bindEmail, (callback) {
      if (globalController.bindEmail.value) {
        firstTimeBind.value = true;
        isBindEmail.value = true;
        showIndex.value = 3;
        showViewPassword();
      }
    });
    ever(globalController.bindGoogle, (callback) {
      isGoogled.value = true;
      showViewPassword();
    });
    ever(globalController.bindPayed, (callback) {
      isPayed.value = true;
      showViewPassword();
    });
    _accountListener = AccountServiceListener(onUserInfoChange: (model) {
      _updateInfo();
    });
    AccountService.sharedInstance.addListener(_accountListener!);
    _updateInfo();
  }

  ///获取安全验证配置
  ///没设置的话， authSecret为"" 空
  void loadAuthConfigData() async {
    await ApiService.instance.getAuthConfig(
      success: (AuthConfigApiModel apiModel) {
        //判断是否已开始双重验证
        isGoogled.value = apiModel.isAuthSecret();
      },
      fail: (bool isConnect, String? message, candy) {},
    );
  }

  ///获取品牌基础信息
  Future<void> getBrandBaseInfo({String tag = 'base'}) async {
    await ApiService.instance.getBrandDetail(
        tag: tag,
        success: (dynamic) {
          // print('object----验证--${dynamic}');
          int verType = dynamic['base']?['verify']?['all'] == true ? 3 : 2; //1谷歌验证 2资金密码 3全部
          if (verType != 3) {
            verType = dynamic['base']?['verify']?['otp'] == true ? 1 : 2; //1谷歌验证 2资金密码 3全部
          }
          checkIndex.value = verType;
          getBrandDetail();
        },
        fail: (String? message) {});
  }

  ///获取配置信息
  Future<void> getBrandDetail({String tag = 'regapp'}) async {
    await ApiService.instance.getBrandDetail(
        tag: tag,
        success: (dynamic) {
          if (dynamic['reg'] != null) {
            model.value = RegularModel.fromJson(dynamic['reg'].first);
            // print('object---------配置--${dynamic['reg'].first}');
            if (showIndex.value == 3 && isBindEmail.value && !isBindPhone.value && firstTimeBind.value) {
              //此页面绑定邮箱后,未绑定手机，不更新页面，停留 资金密码页面
            } else {
              dealData();
            }
          }
        },
        fail: (String? message) {});
  }

  dealData() {
    var needEmail = false;
    var needPhone = false;
    if (model.value.mail!.mail == true && model.value.mail!.verify == true) {
      needEmail = true;
    }
    if (model.value.phone!.phone == true && model.value.phone!.verify == true) {
      needPhone = true;
    }

    if (needEmail == true && needPhone == false) {//只显示邮箱
      bindIndex.value = 0;
    } else if (needEmail == false && needPhone == true) {//只显示手机
      bindIndex.value = 1;
    } else if (needEmail == true && needPhone == true) {//显示邮箱 手机
      bindIndex.value = 2;
    } else {
      bindIndex.value = 3;
    }

    showView();
  }

  showView() {
    showIndex.value = bindIndex.value;
    if (bindIndex.value == 0) {
      if (isBindEmail.value) {
        showIndex.value = 3;
      }
    } else if (bindIndex.value == 1) {
      if (isBindPhone.value) {
        showIndex.value = 3;
      }
    } else if (bindIndex.value == 2) {
      // if (isBindEmail.value && !isBindPhone.value) {
      //   showIndex.value = 1;
      // }
      // if (!isBindEmail.value && isBindPhone.value) {
      //   showIndex.value = 0;
      // }
      if (isBindEmail.value || isBindPhone.value) {
        showIndex.value = 3;
      }
    }
    // showIndex.value = 3;
    showViewPassword();
  }

  showViewPassword() {
    if (showIndex.value == 3) {
      if (checkIndex.value == 1) { // 谷歌
        showIndex.value = 4;
        if (isGoogled.value) {
          showIndex.value = 5;
        }
      } else if (checkIndex.value == 2) { // 资金
        if (isPayed.value) {
          showIndex.value = 5;
        }
      } else if (checkIndex.value == 3) { // 全部
        if (isPayed.value) {
          showIndex.value = 4;
          if (isGoogled.value) {
            showIndex.value = 5;
          }
        }
      }
    }
    // showIndex.value = 3;
    // final showIndex = 0.obs; // 前台显示 0 绑定邮箱 1 绑定手机号 2 绑定邮箱 手机号  3 显示资金密码 4 显示谷歌验证 5 提款页面
    // print('object------${showIndex.value}----${isBindEmail.value}-----${isBindPhone.value}');
    showBind();
  }

  showBind() {
    if (showIndex.value == 0) {
      showTitle.value = false;
      showPhone.value = false;
    } else if (showIndex.value == 1) {
      showTitle.value = false;
      showPhone.value = true;
    } else if (showIndex.value == 2) {
      showTitle.value = true;
      showPhone.value = false;
    } else if (showIndex.value == 3) {
      showTitle.value = false;
      showPhone.value = false;
      showMoney();
    }
  }

  showMoney() {
    if (bindIndex.value == 0) {
      showTitle.value = false;
      showPhone.value = false;
    } else if (bindIndex.value == 1) {
      showTitle.value = false;
      showPhone.value = true;
    } else if (bindIndex.value == 2) {
      showTitle.value = true;
      showPhone.value = false;
    }
    // print('object--------${bindIndex.value}---${showTitle.value}----${showPhone.value}');
  }

  void _updateInfo() {
    final account = AccountService.sharedInstance.currentUser;
    int emailCheckState = AccountService.sharedInstance.currentUser?.emailCheckState ?? 0;
    isBindEmail.value = emailCheckState == 1;
    int phoneCheckState = AccountService.sharedInstance.currentUser?.phoneCheckState ?? 0;
    isBindPhone.value = phoneCheckState == 1;
    String playPwd = AccountService.sharedInstance.currentUser?.payPassword ?? '';
    isPayed.value = playPwd == '1';
    int googled = AccountService.sharedInstance.currentUser?.googleVerify ?? 0;
    // isGoogled.value = googled == 1;
    // phoneText = account?.mext?.phone ?? '';
    // areaCodeText = account?.mext?.areaCode ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    if (_accountListener != null) {
      AccountService.sharedInstance.removeListener(_accountListener!);
    }
    super.onClose();
  }
}