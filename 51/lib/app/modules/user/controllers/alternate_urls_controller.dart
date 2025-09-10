import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../../../../api/user_api.dart';
import '../data/alternate_urls_bean.dart';

class AlternateUrlsController extends GetxController {
  RxList<AlternateUrlsItem> itemList = <AlternateUrlsItem>[].obs;
  RxString appName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (TenantManager.instance.tenantBean?.tenant?.tenantName != null) {
      appName.value = TenantManager.instance.tenantBean!.tenant!.tenantName!;
    }
    reqAlternateURLs();
  }

  void reqAlternateURLs() async {
    AlternateUrlsBean? bean = await UserApi().reqAlternateURLs();
    if (bean != null && (bean.data?.isNotEmpty ?? false)) {
      itemList.value = bean.data!;
    }
  }
}
