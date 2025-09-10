import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/balance_bean.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/network/error.dart';

//登录信息管理类
class LoginManager {
  LoginManager._privateConstructor();
  static final LoginManager instance = LoginManager._privateConstructor();
  // 推送标识
  String registrationId = '';

  // 登录或注册返回的用户信息
  LoginBean? _loginInfo;
  LoginBean? get loginInfo => _loginInfo;
  // 是否登录
  RxBool isLogin = false.obs;
  // 是否为试玩账号
  RxBool isFreeUser = false.obs;

  // 用户的余额数据
  BalanceBean? _userBalance;
  BalanceBean? get userBalance => _userBalance;
  RxString balanceStr = '0.00'.obs; // 余额
  RxInt vipLevel = 1.obs; // vip等级
  bool isLoginDialogShowing = false; // 登录弹窗是否已展示

  //设置登陆信息
  void setLoginBean(LoginBean? loginInfo) {
    _loginInfo = loginInfo;
    isLogin.value = (_loginInfo != null);
    if (_loginInfo != null) {
      isFreeUser.value = (loginInfo!.custName ?? '').substring(0, 5) == 'tUser';
    } else {
      isFreeUser.value = false;
    }

    if (isLogin.value) {
      UserApi.updateLastLogin();
    }
  }

  // 设置用户余额数据
  void setUserBalanceBean(BalanceBean? balanceBean) {
    _userBalance = balanceBean;
  }

  // 获取账户余额
  Future<bool> reqMoney() async {
    final res = await LoginApi.reqBalance();

    if (res.type == NetworkService.networkTypeSuccess) {
      BalanceBean balance = BalanceBean.fromJson(res.data);
      LoginManager.instance.setUserBalanceBean(balance);
      balanceStr.value = (balance.balance! / 1000).truncateToFixed(2);
      vipLevel.value = balance.level ?? 1;
      return true;
    } else {
      if (res.data is NetworkError) {
        NetworkError error = res.data;
        error.log();
        if (error.logout) {
          Get.snackbar("登录已过期！", "请重新登录");
          LoginManager.instance.clear();
        }
      }
    }

    return false;
  }

  //清理缓存，一般用于退出登陆
  void clear() {
    _loginInfo = null;
    isLogin.value = false;
    isFreeUser.value = false;
    balanceStr.value = '0.00';
    vipLevel.value = 1;
    SpUtil.remove('loginBean');
    SpUtil.remove('recentGames');
  }

  // 检查用户是否被冻结
  bool checkIsFrozen() {
    if (_loginInfo?.isFrozen == 2) {
      EasyLoading.showError('账号已冻结，请联系客服');
      return true;
    }
    return false;
  }
}
