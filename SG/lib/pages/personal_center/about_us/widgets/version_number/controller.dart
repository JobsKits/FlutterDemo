import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import '../../../../../widget/snack_bar/custom_snack_bar.dart';
import 'download/view.dart';

class VersionNumberController extends GetxController {
  VersionNumberController();

  late BuildContext context;
  var currentVersion = '1.0.0';
  var lastestVersion = '1.0.0';
  bool isLatest = true;
  // bool isLatest = false;

  _initData() {
    update(["version_number"]);
    getPackageInfo();
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
  }

  void onTap() {
    if (!isLatest) {
      // var url = 'https://dk0gdtx9n13r0.cloudfront.net/dev_01-18_10-53-02.apk';
      // UrlLaunchUtil.launchURL(url);
      showDownloadWidget();
    }
  }

  showError() {
    CustomSnackBar.showError(S.current.random_text_862, context);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
