import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/app_manager.dart';
import '../../../../utils/common_color.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../widget/common_gradient.dart';
import '../controllers/new_home_controller.dart';
import '../new_home_const.dart';
import '../nightHome/common_game_search_view.dart';

class NightGameTryView extends StatefulWidget {
  const NightGameTryView({super.key});

  @override
  State<NightGameTryView> createState() => _NightGameTryViewState();
}

class _NightGameTryViewState extends State<NightGameTryView> {
  NewHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonGameSearchView(
          isGameTry: true,
          search: (str) {
            if (str.isEmpty) {
              controller.gameTryList.value = controller.oldGameTryList;
              return;
            }
            controller.gameTryList.value = controller.gameTryList
                .where((item) => (item.play_cname ?? "").contains(str))
                .toList();
          },
        ),
        Expanded(
          child: Obx(() => controller.gameTryList.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.gameTryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 每行 3 个
                    mainAxisSpacing: 20.w,
                    crossAxisSpacing: 20.h,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final gameItem = controller.gameTryList[index];
                    String imgUrl = GameUtils.getHotGameImageUrl(
                        playName: gameItem.play_name ?? "",
                        upperPlayId: gameItem.upper_play_id ?? 0,
                        bigType: gameItem.big_type ?? 0,
                        playId: gameItem.play_id?.toInt() ?? 0);
                    bool isMaintain = gameItem.state!.toInt() == 2;
                    return Stack(
                      children: [
                        SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              // jumpGame(hotDataItem, isMaintain, index);
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 20.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36.r),
                                color: Colors.red,
                                gradient: CommonGradient.getRadialGradient(
                                    index: index),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(colorF4F4F4),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.r)),
                                        ),
                                        child: CircularProgressIndicator(
                                          color: context.theme.primaryColor,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(Assets.theme1.images.home
                                              .errorImg.path),
                                      imageUrl: imgUrl,
                                    ),
                                  ),
                                  Text(
                                    '${gameItem.play_cname}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 42.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(colorFFFFFF),
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isMaintain)
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: const Color.fromARGB(178, 0, 0, 0),
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: 230.h,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        Assets.theme1.images.home.systemMaintain
                                            .path,
                                        width: 152.w,
                                        height: 152.h,
                                      ),
                                      Text(
                                        '维护中...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                )
              : SizedBox()),
        )
      ],
    );
  }

  jumpGame(GameBeanItem hotDataItem, bool isMaintain, index) {
    AppManager.instance.tapVibrate();
    if (!isMaintain) {
      bool isBigClass =
          hotDataItem.play_id == hotDataItem.upper_play_id; //这两个相等，判断为大类，切换tab;

      if (isBigClass && hotDataItem.big_type != HomeGameCategory.LOTTERY) {
        //不是彩票的大类，才走这里
        var gameType = controller.switchGameType(hotDataItem.big_type);

        controller.handleGameBanner(
          gameType: gameType ?? "",
          index: index,
          playId: hotDataItem.play_id,
        );
      } else {
        controller.openHotGame(hotDataItem);
        controller.addGameRecord(HomeCollectionListItemBean(
          collectionId: hotDataItem.play_collection == 2
              ? hotDataItem.play_id?.toInt()
              : null,
          play_id: hotDataItem.play_id?.toInt(),
          upper_play_id: hotDataItem.upper_play_id?.toInt(),
          playName: hotDataItem.play_name,
          playCname: hotDataItem.play_cname,
          play_cat: hotDataItem.play_cat?.toInt(),
          play_state: hotDataItem.state?.toInt(),
          play_big_type: hotDataItem.big_type?.toInt(),
          gameImgUrl: hotDataItem.thumbnail_img_url ?? hotDataItem.gameImgUrl,
          gtype: hotDataItem.gtype,
          isRecord: false,
        ));
      }
    }
  }
}
