import 'package:flutter/widgets.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:get/get.dart';
import '../../../generated/l10n.dart';
import '../../../services/event/event_service.dart';
import '../../main/code.dart';
import 'vip_club_state.dart';
import 'vip_club_view_swiper.dart';


class VipClubLogic extends BaseController {
  final VipClubState state = VipClubState();

  ///窗口列表可是最大高度
  final double windowListHeightMax = Get.height / 10 * 4;

  ///窗口列表可是最大框宽度
  final double windowListWidthMax = Get.width * 2;

  final images = <String>[
    'assets/images/personal_center_icon/ic_vip_club_swiper01.webp',
    'assets/images/personal_center_icon/ic_vip_club_swiper02.webp',
    'assets/images/personal_center_icon/ic_vip_club_swiper03.webp',
    'assets/images/personal_center_icon/ic_vip_club_swiper04.webp',
    'assets/images/personal_center_icon/ic_vip_club_swiper05.webp',
  ];
  final swiperModelList = [
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper01.webp',
        title: S.current.random_text_416,
        detail: S.current.random_text_417),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper02.webp',
        title: S.current.random_text_418,
        detail: S.current.random_text_419),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper03.webp',
        title: S.current.random_text_420,
        detail: S.current.random_text_421),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper04.webp',
        title: S.current.random_text_422,
        detail: S.current.random_text_423),
    VipClubSwiperModel(
        assetName: 'assets/images/personal_center_icon/ic_vip_club_swiper05.webp',
        title: 'Bespoke',
        detail: S.current.random_text_424),
  ];

  static final awardTitleList = [
    S.current.random_text_425,
    S.current.random_text_426,
    S.current.random_text_427,
    S.current.random_text_422,
    S.current.random_text_428,
    S.current.random_text_429,
    S.current.random_text_430,
    S.current.random_text_431,
    'BESPOKE',
  ];

  //二维数据
  final awardModelList = [
    //头部
    List.generate(11, (index) {
      return index == 0
          ? VipAwardModel(detail: awardTitleList[0], isTitle: true)
          : VipAwardModel(detail: 'VIP$index');
    }).toList(),
    //明细，从第二个开始
    ...awardTitleList.sublist(1).map((title) {
      return List.generate(11, (index) {
        return index == 0
            ? VipAwardModel(detail: title, isTitle: true)
            : VipAwardModel(detail: '$index${S.current.random_text_432}');
      }).toList();
    }).toList(),
  ];

  final ScrollController pageScrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
    // pageScrollController.addListener(() {
    //   print("_controller.offset= ${pageScrollController.offset}");
    // });
  }

  @override
  void onClose() {
    pageScrollController.dispose();
    super.onClose();
  }

  ///点击-开始游戏
  onClickBeginGame() {
    //回到 首页娱乐城，
    RouteUtil.popView();
    EventService.instance.dispatchEvent(kChangeMainPageEvent,MenuCode.GAME);
  }

  final GlobalObjectKey tabKey =  const GlobalObjectKey("tabKey");
  ///点击-查看VIP级别表
  void onClickVipLevelTable() {
    // pageScrollController. = 1720.0;
    pageScrollController.animateTo(
      1700.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

}

class VipAwardModel {
  bool isTitle;
  String detail;

  VipAwardModel({required this.detail, this.isTitle = false});
}
