import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/area.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/ball.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/data.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/model/lottery_handicp_model/lottery_handicp_model.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../model/lottery_odds_info_model/lottery_odds_info_model.dart';

class LotteryHandicapPage extends StatefulWidget {
  final List<LotteryHandicpModel?> menus;
  const LotteryHandicapPage({super.key, required this.menus});

  @override
  State<LotteryHandicapPage> createState() => _LotteryHandicapPageState();
}

class _LotteryHandicapPageState extends State<LotteryHandicapPage>
    with TickerProviderStateMixin {
  final LotteryController lotterController = Get.find();
  int selectIndex = 0;
  late final tabController =
      TabController(length: (widget.menus).length, vsync: this)
        ..addListener(listener);

  listener() {
    setState(() {
      selectIndex = tabController.index;
    });
  }

  handleSelectTab(int index) {
    AppManager.instance.tapVibrate();
    setState(() {
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          padding: EdgeInsets.zero,
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          indicatorColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.label,
          splashFactory: NoSplash.splashFactory,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
              color: context.theme.cardColor.withOpacity(.2),
              borderRadius: BorderRadius.circular(5)),
          labelStyle: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: context.textTheme.bodyLarge?.copyWith(),
          tabs: (widget.menus)
              .mapIndexed((i, e) => Container(
                  decoration: BoxDecoration(
                      color: selectIndex == i
                          ? context.theme.cardColor.withOpacity(.5)
                          : null,
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(e?.areas?[0].show ?? '')))
              .toList(),
          onTap: handleSelectTab,
        ),
        Expanded(
          child: TabBarView(
              controller: tabController,
              children: (widget.menus)
                  .mapIndexed((i, e) => HandicapSumItem(
                        key: ValueKey('$i'),
                        handicpModel: e!,
                      ))
                  .toList()),
        )
      ],
    );
  }
}

class HandicapSumItem extends StatefulWidget {
  // final List<Area>? areas;
  final LotteryHandicpModel handicpModel;
  const HandicapSumItem({super.key, required this.handicpModel});

  @override
  State<HandicapSumItem> createState() => _HandicapSumItemState();
}

class _HandicapSumItemState extends State<HandicapSumItem> {
  final LotteryController lotterController = Get.find();

  LotteryOddsInfoModel? numsModel = LotteryOddsInfoModel();
  LotteryHandicpModel? selectHandicpModel;
  String? odds = '';

  Map<String, dynamic> style = {
    "大小单双": {"count": 2, "ratio": 1.5, 'fontSize': 84.sp},
    "和值": {"count": 4, "ratio": 1.2, 'fontSize': 44.sp},
    "二同号单选": {"count": 3, "ratio": 1.35, 'fontSize': 44.sp},
    "同号": {"count": 3, "ratio": 1.35, 'fontSize': 44.sp},
    "二同号复选": {"count": 3, "ratio": 1.35, 'fontSize': 44.sp},
    "二同号": {"count": 3, "ratio": 1.35, 'fontSize': 44.sp},
    "二不同号": {"count": 3, "ratio": 1.35, 'fontSize': 44.sp},
    "三不同号": {"count": 3, "ratio": 1.35, 'fontSize': 44.sp},
    "三同号单选": {"count": 3, "ratio": 1.15, 'fontSize': 44.sp},
    "三同号通选": {"count": 2, "ratio": 1.5, 'fontSize': 84.sp},
    "三连号通选": {"count": 2, "ratio": 1.5, 'fontSize': 84.sp},
  };

  @override
  void initState() {
    init();
    super.initState();
  }

  handleSelect(
      LotteryHandicpModel originModel, Area originArea, Ball selectBall) {
    bool exists = false;

    // 检查是否存在相同的 Ball
    if (lotterController.selectList.isNotEmpty) {
      for (var model in lotterController.selectList) {
        for (var area in model.areas ?? []) {
          if (area.data.balls.any((ball) =>
              ball.id == selectBall.id &&
              ball.name == selectBall.name &&
              ball.cmd == selectBall.cmd)) {
            exists = true;
            break;
          }
        }
        if (exists) break;
      }
    }

    // 如果存在，移除该 Ball
    if (exists) {
      for (var model in lotterController.selectList) {
        for (var area in model.areas ?? []) {
          area.data.balls.removeWhere((ball) =>
              ball.id == selectBall.id &&
              ball.name == selectBall.name &&
              ball.cmd == selectBall.cmd);
        }
      }
      print("Ball 已经存在，已移除");
    } else {
      // 如果不存在，添加到第一个 LotteryHandicpModel 的第一个 area 的 balls 列表中
      print("empty =======${lotterController.selectList.isNotEmpty}");
      bool ishave = false;
      if (lotterController.selectList.isNotEmpty) {
        lotterController.selectList[0].areas![0].data!.balls?.add(selectBall);
        for (LotteryHandicpModel model in lotterController.selectList) {
          if (model.id == originModel.id) {
            ishave = true;
            for (Area area in model.areas ?? []) {
              if (area.ballpanid == originArea.ballpanid &&
                  area.baseballid == originArea.baseballid) {
                for (Ball ball in area.data?.balls ?? []) {
                  if (ball.id == selectBall.id &&
                      ball.name == selectBall.name &&
                      ball.cmd == selectBall.cmd) {
                    area.data!.balls?.add(selectBall);
                  }
                }
              }
            }
          }
        }

        if (!ishave) {
          var newModel = LotteryHandicpModel(
            id: originModel.id,
            areas: [
              Area(
                show: originArea.show,
                baseballid: originArea.baseballid,
                ballpanid: originArea.ballpanid,
                data: Data(id: originArea.data?.id, balls: [
                  Ball(
                      id: selectBall.id,
                      name: selectBall.name,
                      cmd: selectBall.cmd,
                      odds: selectBall.odds)
                ]),
              )
            ],
          );
          lotterController.selectList.add(newModel);
        }
      } else {
        // 如果 selectList 是空的，需要创建一个新的 LotteryHandicpModel 并添加进去
        var newModel = LotteryHandicpModel(
          id: originModel.id,
          areas: [
            Area(
              show: originArea.show,
              baseballid: originArea.baseballid,
              ballpanid: originArea.ballpanid,
              data: Data(id: originArea.data?.id, balls: [
                Ball(
                    id: selectBall.id,
                    name: selectBall.name,
                    cmd: selectBall.cmd,
                    odds: selectBall.odds)
              ]),
            )
          ],
        );
        lotterController.selectList.add(newModel);
      }
      print("Ball 不存在，已添加");
    }
    print("Ball ======= ${lotterController.selectList}");

    // print({'data ======${data}'});
    selectHandicpModel = lotterController.selectList
        .firstWhereOrNull((model) => model.id == widget.handicpModel.id);

    setState(() {});
  }

  void init() async {
    style = style[widget.handicpModel.areas?.first.show ?? ''] ??
        {"count": 2, "ratio": 1.5, 'fontSize': 84.sp};
    numsModel = lotterController.oddsInfo.firstWhereOrNull(
        (e) => e.playId.toString() == widget.handicpModel.id)!;

    if (numsModel?.playCname != '和值') {
      odds = lotterController.calculatingAllOddsEven(
          numsModel?.playId ?? 0,
          numsModel?.playCname ?? '',
          numsModel?.baseNoteNum ?? 0,
          numsModel?.subPlayPlanNum ?? 0,
          numsModel?.subPlayPlanNumWin ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    return ListView.builder(
      itemCount: widget.handicpModel.areas?.length,
      itemBuilder: (BuildContext context, int index) {
        final area = widget.handicpModel.areas?[index];

        final selectArea = selectHandicpModel?.areas?[index];
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: style['count'] ?? 2,
              childAspectRatio: style['ratio'] ?? 1.5),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: area!.data!.balls?.length,
          itemBuilder: (context, gridIndex) {
            final ball = area.data?.balls?[gridIndex];

            final selectBall = selectArea?.data!.balls
                ?.firstWhereOrNull((e) => e.name.toString() == ball?.name);
            print({'object ========= $selectBall'});
            if (numsModel?.playCname == '和值') {
              odds = lotterController.calculatingSumOddsEven(
                  numsModel!, '${widget.handicpModel.id}${ball?.cmd}');
            }
            return Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  // selectBall == null ? Colors.white : (selectBall.id == ball?.id && selectBall.name == ball?.name && selectBall.cmd == ball?.cmd) ? Colors.blue[100]: Colors.white
                  decoration: BoxDecoration(
                    color: selectBall == null
                        ? Colors.white
                        : (selectBall.id == ball?.id &&
                                selectBall.name == ball?.name &&
                                selectBall.cmd == ball?.cmd)
                            ? Colors.blue[100]
                            : Colors.white,
                    borderRadius: BorderRadius.circular(8), // 设置圆角半径
                  ),
                  child: Column(
                    mainAxisAlignment:
                        widget.handicpModel.areas?.first.show == '三同号单选'
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                    children: [
                      if (widget.handicpModel.areas?.first.show == '大小单双' ||
                          widget.handicpModel.areas?.first.show == '和值' ||
                          widget.handicpModel.areas?.first.show == '三同号通选' ||
                          widget.handicpModel.areas?.first.show == '三连号通选') ...[
                        Text(
                          ball?.name ?? '',
                          style: TextStyle(fontSize: style['fontSize']),
                        ),
                      ] else ...[
                        Column(
                          children: [
                            if (ball?.name?.length == 1) ...[
                              Image.asset(
                                scoreImageUrlByPath(ball?.name ?? ''),
                                width: 80.w,
                                height: 80.h,
                              )
                            ] else if (ball?.name?.length == 2) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    scoreImageUrlByPath(ball?.name ?? ''),
                                    width: 80.w,
                                    height: 80.h,
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset(
                                    scoreImageUrlByPath(ball?.name ?? ''),
                                    width: 80.w,
                                    height: 80.h,
                                  )
                                ],
                              ),
                            ] else if (ball?.name?.length == 3) ...[
                              const SizedBox(height: 20),
                              Image.asset(
                                scoreImageUrlByPath(ball?.name ?? ''),
                                width: 80.w,
                                height: 80.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    scoreImageUrlByPath(ball?.name ?? ''),
                                    width: 80.w,
                                    height: 80.h,
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset(
                                    scoreImageUrlByPath(ball?.name ?? ''),
                                    width: 80.w,
                                    height: 80.h,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        )
                      ],
                      Text(odds ?? '',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.black))
                          .paddingOnly(top: 5),
                    ],
                  ).onTap(() {
                    AppManager.instance.tapVibrate();
                    // Handle tap events here
                    handleSelect(widget.handicpModel, area, ball!);
                  }),
                ));
          },
        );
      },
    );
    // });
  }

  String scoreImageUrlByPath(String score) {
    if (score.contains('1')) {
      return Assets.theme1.images.lottery.lotteryDice1.path;
    } else if (score.contains('2')) {
      return Assets.theme1.images.lottery.lotteryDice2.path;
    } else if (score.contains('3')) {
      return Assets.theme1.images.lottery.lotteryDice3.path;
    } else if (score.contains('4')) {
      return Assets.theme1.images.lottery.lotteryDice4.path;
    } else if (score.contains('5')) {
      return Assets.theme1.images.lottery.lotteryDice5.path;
    } else if (score.contains('6')) {
      return Assets.theme1.images.lottery.lotteryDice6.path;
    } else {
      return Assets.theme1.images.lottery.lotteryDice1.path;
    }
  }
}
