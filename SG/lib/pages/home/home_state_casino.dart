
import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../routes/routes.dart';
import 'amodel/home_common_params.dart.dart';
import 'amodel/navigation_item_info.dart';

///首页菜单 娱乐城的菜单状态
class HomeCasinoState {


  ///娱乐城导航数据
  late List<NavigationItemInfo> casinoOne;

  ///个人资料、促销活动、联盟计划、Vip俱乐部
  late RxList<NavigationItemInfo> casinoThree;

  ///负责任博彩、在线支持、语言切换
  late RxList<NavigationItemInfo> casinoFour;

  buildCasinoStateData(){
    casinoOne = [
      NavigationItemInfo(
          title: RxString(S.current.sport_tabbar_favorites),
          icon: 'assets/images/home/ic_star.webp'),
      NavigationItemInfo(
          title: RxString(S.current.home_recent_games),
          icon: 'assets/images/home/ic_game_history.webp'),

      ///新版的我的投注， 包括娱乐城 和 体育的；
      NavigationItemInfo(
          title: RxString(S.current.sport_tabbar_mybet),
          icon: 'assets/images/home/ic_my_bet.webp',
          tag: '',
          showTag: false,
          route: Routes.browseMenuMyBetting),
      // route: Routes.betListPage),
      // NavigationItemInfo(
      //     title: RxString(S.current.home_challenge), icon: 'assets/images/home/ic_challenge.webp'),
    ].obs;
    casinoThree = [
      NavigationItemInfo(
        title: RxString(""),
        navEnum: NavEnum.profile,
      ),
      NavigationItemInfo(
        title: RxString(""),
        navEnum: NavEnum.promotions,
      ),
      NavigationItemInfo(
          title: RxString(S.current.alliance_program),
          route: S.current.alliance_program,
          icon: 'assets/images/home/ic_affiliate_program.webp'),
      NavigationItemInfo(
          title: RxString(S.current.vip_club),
          route: S.current.vip_club,
          icon: 'assets/images/home/ic_vip_club.webp'),
      // NavigationItemInfo(
      //     route: '博客',
      //     title: RxString(S.current.home_blog), icon: 'assets/images/home/ic_ blog.webp'),
      // NavigationItemInfo(
      //     route: '论坛',
      //     title: RxString(S.current.home_forum), icon: 'assets/images/home/ic_ forum.webp')
    ].obs;
    casinoFour = [
      NavigationItemInfo(
          route: S.current.responsible_gaming,
          title: RxString(S.current.responsible_gaming),
          icon: 'assets/images/home/ic_safe.webp'),
      NavigationItemInfo(
          title: RxString(S.current.live_support), icon: 'assets/images/home/ic_online.webp'),
    ].obs;
  }

}