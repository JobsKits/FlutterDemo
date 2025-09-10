import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:get/get.dart';

import '../../data/home_tab_data.dart';

class NewHomeUtils {
  /// 获取首页详情 棋牌/捕鱼/电子 相关tab场馆的icon
  static getHomeTabIcon({
    required num bigType,
    required List<HomeTabData> tabList,
    required String name,
  }) {
    if (tabList.isNotEmpty) {
      HomeTabData? item = tabList
          .firstWhereOrNull((item) => name.contains(item.playName ?? ""));
      if (item == null) {
        return 'assets/theme1/images/home/tab/icon_$bigType.png';
      }
      String netUrl = "";
      if (item?.logoUrl1 != null || item!.logoUrl1!.isNotEmpty) {
        netUrl = item!.logoUrl1!;
      }
      if (!netUrl.contains("http")) {
        netUrl = 'assets/theme1/images/home/tab/icon_$bigType.png';
      }
      return netUrl;
    }

    return 'assets/theme1/images/home/tab/icon_$bigType.png';
  }
}
