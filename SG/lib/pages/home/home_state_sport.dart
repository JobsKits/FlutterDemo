import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../routes/routes.dart';
import '../../widget/expansion/expand_list_model.dart';
import 'amodel/home_common_params.dart.dart';
import 'amodel/navigation_item_info.dart';

///首页菜单 体育的菜单状态
class HomeSportState {
  ///体育导航数据
  late List<NavigationItemInfo> sportOne;
  late List<NavigationItemInfo> sportTwo;

  ///个人资料、促销活动、联盟计划、Vip俱乐部
  late List<NavigationItemInfo> sportThree;
  late List<NavigationItemInfo> sportFour;

  late List<ExpandListModel> topSportData = <ExpandListModel>[].obs; //顶级体育项目
  late List<ExpandListModel> allSportData = <ExpandListModel>[].obs; //体育项目


  buildSportStateData(){
    sportOne = [
      NavigationItemInfo(
          title: RxString(S.current.sport_tabbar_rolling),
          icon: 'assets/images/home/ic_rolling_ball_tray.webp',
          tag: 'roll',
          route: Routes.sport_side,
          showTag: true),
      NavigationItemInfo(
          title: RxString(S.current.sport_tabbar_coming),
          icon: 'assets/images/home/ic_about_to_start.webp',
          tag: '',
          route: Routes.sport_side,
          showTag: false),
      NavigationItemInfo(
          title: RxString(S.current.sport_tabbar_mybet),
          icon: 'assets/images/home/ic_my_bet.webp',
          tag: '',
          showTag: false,
          route: Routes.browseMenuMyBetting),
    ];
    sportTwo = [
      NavigationItemInfo(
          title: RxString(S.current.top_sports), icon: 'assets/images/home/ic_star.webp'),
    ];
    sportThree = [
      NavigationItemInfo(
        title: RxString(""),
        navEnum: NavEnum.profile,
      ),
      NavigationItemInfo(
        title: RxString(""),
        navEnum: NavEnum.promotions,
      ),
      NavigationItemInfo(
          route: S.current.alliance_program,
          title: RxString(S.current.alliance_program),
          icon: 'assets/images/home/ic_affiliate_program.webp'),
      NavigationItemInfo(
          route: S.current.vip_club,
          title: RxString(S.current.vip_club),
          icon: 'assets/images/home/ic_vip_club.webp'),
      // NavigationItemInfo(
      //     route: '博客',
      //     title: RxString(S.current.home_blog), icon: 'assets/images/home/ic_ blog.webp'),
      // NavigationItemInfo(
      //     route: '论坛',
      //     title: RxString(S.current.home_forum), icon: 'assets/images/home/ic_ forum.webp'),
    ];
    sportFour = [
      NavigationItemInfo(
          route: S.current.responsible_gaming,
          title: RxString(S.current.responsible_gaming),
          icon: 'assets/images/home/ic_safe.webp'),
      NavigationItemInfo(
          title: RxString(S.current.live_support), icon: 'assets/images/home/ic_online.webp'),
    ];
  }
}
