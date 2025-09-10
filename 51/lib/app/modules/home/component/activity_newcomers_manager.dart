import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/task_newcomers_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_newcoers_signin_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_newcoers_unsign_dialog.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/utils/dialog_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';

enum PopupMode {
  NO_POPUP,
  DAILY_ONCE,
  HIGH_FREQUENCY,
  EVERY_LOGIN,
  ONLY_ONCE,
}

class ActivityNewcomersManager {
  static final firstLoginNewcomers = false.obs;

  static Future<void> handleNewcomersDialog(TaskNewcomersModel data) async {
    final isLoggedIn = LoginManager.instance.isLogin.value;
    final preLoginMode = _parsePopupMode(data.t?.preLoginModal);
    final postLoginMode = _parsePopupMode(data.t?.postLoginModal);

    if (isLoggedIn) {
      await _handlePostLogin(postLoginMode, data);
    } else {
      await _handlePreLogin(preLoginMode, data);
    }
  }

  static PopupMode _parsePopupMode(String? modeStr) {
    switch (modeStr) {
      case 'NO_POPUP': return PopupMode.NO_POPUP;
      case 'DAILY_ONCE': return PopupMode.DAILY_ONCE;
      case 'HIGH_FREQUENCY': return PopupMode.HIGH_FREQUENCY;
      case 'EVERY_LOGIN': return PopupMode.EVERY_LOGIN;
      case 'ONLY_ONCE': return PopupMode.ONLY_ONCE;
      default: return PopupMode.NO_POPUP;
    }
  }

  static Future<void> _handlePreLogin(PopupMode mode, TaskNewcomersModel data) async {
    if (mode == PopupMode.NO_POPUP) return;

    final localPreLogin = await loadLoaclData('newcomersPreLogin');
    if (data.t?.preLoginModal != localPreLogin && localPreLogin != null) {
      await _resetPreLoginFlags();
    }

    // Check if we should skip showing based on local flags
    if (await _shouldSkipPreLogin()) return;

    switch (mode) {
      case PopupMode.DAILY_ONCE:
        if (!await loadTodayData('preLoginModal_newcomersToday')) {
          await _showPreLoginDialog(data);
          await saveToday('preLoginModal_newcomersToday', true);
        }
        break;

      case PopupMode.ONLY_ONCE:
        if (!await loadNaverData('preLoginModal_newcomersNaver')) {
          await _showPreLoginDialog(data);
          await saveInfo('preLoginModal_newcomersNaver', true);
        }
        break;

      case PopupMode.HIGH_FREQUENCY:
        await _showPreLoginDialog(data);
        break;

      case PopupMode.NO_POPUP:
      case PopupMode.EVERY_LOGIN:
        // Not applicable for pre-login
        break;
    }
  }

  static Future<void> _handlePostLogin(PopupMode mode, TaskNewcomersModel data) async {
    if (mode == PopupMode.NO_POPUP) return;

    final custId = LoginManager.instance.loginInfo?.custId ?? '';
    final localNextLogin = await loadLoaclData('newcomersLoginShow');
    final alreadyShown = await loadNaverData('newcomersEveryLoginShow');

    // 检查是否需要重置标志
    if ((data.t?.postLoginModal != localNextLogin && localNextLogin != null) ||
      (mode == PopupMode.EVERY_LOGIN && !alreadyShown)) {
      await _resetPostLoginFlags();
      // 重置EVERY_LOGIN特定状态
      await saveInfo('newcomersEveryLoginShow', false);
    }

    if (await _shouldSkipPostLogin()) return;

    // 检查EVERY_LOGIN特定状态
    if (mode == PopupMode.EVERY_LOGIN) {
      if (alreadyShown) return;
    }

    switch (mode) {
      case PopupMode.DAILY_ONCE:
        if (!await loadTodayData('postLoginModal_newcomersLoginToday$custId')) {
          await _showPostLoginDialog(data);
          await saveToday('postLoginModal_newcomersLoginToday$custId', true);
        }
        break;

      case PopupMode.ONLY_ONCE:
        if (!await loadNaverData('postLoginModal_newcomersLoginNaver$custId')) {
          await _showPostLoginDialog(data);
          await saveInfo('postLoginModal_newcomersLoginNaver$custId', true);
        }
        break;

      case PopupMode.HIGH_FREQUENCY:
        await _showPostLoginDialog(data);
        break;

      case PopupMode.EVERY_LOGIN:
        await _showPostLoginDialog(data);
        await saveInfo('newcomersEveryLoginShow', true); // 保存已显示状态
        break;

      case PopupMode.NO_POPUP:
        break;
    }
  }

  static Future<bool> _shouldSkipPreLogin() async {
    return await loadTodayData('local_newcomersToday') ||
           await loadNaverData('local_newcomersNaver');
  }

  static Future<bool> _shouldSkipPostLogin() async {
    return await loadTodayData('local_newcomersLoginToday') ||
           await loadNaverData('local_newcomersLoginNaver');
  }

  static Future<void> _resetPreLoginFlags() async {
    await saveToday('preLoginModal_newcomersToday', false);
    await saveInfo('preLoginModal_newcomersNaver', false);
    await saveToday('local_newcomersToday', false);
    await saveInfo('local_newcomersNaver', false);
  }

  static Future<void> _resetPostLoginFlags() async {
    final custId = LoginManager.instance.loginInfo?.custId ?? '';
    await saveToday('postLoginModal_newcomersLoginToday$custId', false);
    await saveInfo('postLoginModal_newcomersLoginNaver$custId', false);
    await saveToday('local_newcomersLoginToday', false);
    await saveInfo('local_newcomersLoginNaver', false);
  }

  static Future<void> _showPreLoginDialog(TaskNewcomersModel data) async {
    DialogManager.showDialogWithQueue(
      dialog: ActivityNewcoersUnsignDialog(
        price: (double.parse((data.t?.total ?? 0).toString()) / 1000).truncateToFixed(0),
      ),
      priority: 99,
    );
  }

  static Future<void> _showPostLoginDialog(TaskNewcomersModel data) async {
    DialogManager.showDialogWithQueue(
      dialog: ActivityNewcoersSigninDialog(newcoersModel: data),
      priority: 99,
    );
  }

  static Future<bool> loadTodayData(String key) async {
    var today = await SpUtil.getInt(key);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(today ?? 0);
    DateTime now = DateTime.now();
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
    return today == null ? false : isToday;
  }

  static Future<bool> loadNaverData(String key) async {
    var naver = await SpUtil.getBool(key);
    return naver ?? false;
  }

  static Future<String?> loadLoaclData(String key) async {
    var string = await SpUtil.getString(key);
    return string;
  }

  static saveToday(String saveName, bool value) async {
    if (value) {
      int timestampSeconds = DateTime.now().millisecondsSinceEpoch;
      await SpUtil.saveInt(saveName, timestampSeconds);
    } else {
      await SpUtil.saveInt(saveName, 0);
    }
  }

  static saveInfo(String saveName, bool value) async {
    await SpUtil.saveBool(saveName, value);
  }

  static saveLocal(String saveName, String value) async {
    await SpUtil.saveString(saveName, value);
  }
}
