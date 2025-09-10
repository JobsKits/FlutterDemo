import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/widget/custom_shimmer.dart';
import 'package:flutter_bet/widget/sport/custom_sport_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_icon_button.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/sport/custom_sport_categorybar.dart';
import '../../../widget/sport/custom_sport_odd_type.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../common_model/sport_filter.dart';
import '../logic.dart';
import '../tabmodel.dart';

class SportHallSection extends StatefulWidget {
  final SportBetClick sportBetClick;
  final ValueChanged<int>? onTapGame;
  List<SportHallCountModel>? tabs;
  List<SportMatchModel>? competitionList;
  String title;
  int index = 0;
  Map? sportMap;
  bool? m;
  int? cIndex = 0;
  bool? isShimmerView = false;
  bool isOpen;
  bool? isSide;

  List<Btl>? selectList = [];

  SportHallSection({
    Key? key,
    required this.sportBetClick,
    this.tabs,
    this.onTapGame,
    this.competitionList,
    this.sportMap,
    this.m,
    required this.title,
    required this.index,
    this.cIndex,
    this.isShimmerView,
    required this.isOpen,
    this.isSide = false,
  }) : super(key: key);

  @override
  State<SportHallSection> createState() => _SportHallSectionState();
}

class _SportHallSectionState extends State<SportHallSection> {
  final MessageLogic logic = Get.find<MessageLogic>(); 
  final GlobalKey _popKey = GlobalKey();
  final GlobalKey _popMainKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  var scale = 1.0;
  bool isOpen = false;

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    widget.selectList = logic.state.filterModel.bettypeFilter![logic.state.sit].btl!;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: AppValues.sportPadding_12.h,
              left: AppValues.sportPadding_12.w,
              right: AppValues.sportPadding_12.w),
          child: SizedBox(
            width: Get.width - AppValues.sportWidth_20.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !widget.isSide!,
                  child: Row(
                    children: [
                      Image.asset(
                        getIcon(widget.title),
                        width: AppValues.sportIcon_18.w,
                        height: AppValues.sportIcon_18.w,
                      ),
                      SizedBox(width: AppValues.sportWidth_8.w),
                    ],
                  )
                ),
                (logic.state.cagetoryTabbarInitIndex.value == 0 && widget.title != S.current.sport_bet_hot && !widget.isSide!) ?
                //今日赛事下拉框
                GestureDetector(
                  onTap: () {
                    setState(() {scale = 0.9;});
                    Future.delayed(const Duration(milliseconds: 100), () {
                      setState(() {scale = 1.0;});
                    });
                    _startAnimation(_rotatingArrowKey);
                    DialogUtils.showCustomBubbleDialog(
                          context, _buildBubbleMainChild(),logic.state.globalController.langType.value  < 3 ? AppValues.sportWidth_80.w : 174,
                          widgetKey: _popMainKey,
                          backgroundColor: Colors.white,
                          bubbleLeftOffset: (logic.state.globalController.langType.value == 6 && logic.state.indexMain != 1) ? 10 : 0,//左偏移
                          filterCall: (e) {
                            logic.state.indexMain = int.parse(e);
                            logic.state.sit = 0;
                            widget.sportBetClick(SportClikType.change, logic.state.indexMain, 0, 0, 0, '0');
                          },
                          globalKey: _rotatingArrowKey,
                          onDismissCallback: () {
                            isOpen = false;
                            setState(() {scale = 0.9;});
                            Future.delayed(const Duration(milliseconds: 100), () {
                              setState(() {scale = 1.0;});
                            });
                          });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn, // 使用弹性曲线
                    transform: Matrix4.identity()..scale(scale),
                    height: 40,
                    child: Row(
                      children: [
                        CustomText(
                          key: _popMainKey,
                          logic.state.filterModel.listFilter![logic.state.indexMain].name!,
                          style: ThemeService()
                              .theme
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w600, fontSize: AppValues.fontBodyLargeSize),
                        ),
                        RotatingArrow(
                          key: _rotatingArrowKey,
                        ),
                      ],
                    )
                  )
                )
                : CustomText(
                  widget.title,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: AppValues.fontBodyLargeSize),
                ),
                const Expanded(child: SizedBox()),
                if ((widget.title != S.current.sport_bet_hot && !widget.isSide! && logic.state.indexMain != logic.state.filterModel.listFilter!.length - 1) || (widget.isSide! && widget.title != S.current.sport_tabbar_coming))
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => logic.state.showAll(!logic.state.showAll.value),
                        child: Container(
                          color: Colors.transparent,
                          width: 50,
                          height: 40,
                          alignment: Alignment.center,
                          child: Obx(() => CustomIcon(asset: logic.state.showAll.value ? 'assets/images/sport/all.png' : 'assets/images/sport/one.png',size: 14,)),
                        ) 
                      ),
                      // const SizedBox(width: 18,),
                      //获胜盘下拉框
                      CupertinoButton(
                        // color: AppThemes.textColorWhite,
                        key: _popKey,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (logic.state.showAll.value) {
                            return ;
                          }
                          isOpen = true;
                          setState(() {});
                          DialogUtils.showCustomBubbleDialog(
                              context, _buildBubbleChild(), logic.state.globalController.isChinese() ? AppValues.sportWidth_80.w : (logic.state.globalController.isVi() ? 160 : 100),
                              widgetKey: _popKey,
                              backgroundColor: Colors.white,
                              filterCall: (e) {
                                widget.index = int.parse(e);
                                widget.sportBetClick(SportClikType.filter, widget.index, 0, 0, 0, '0');
                              },
                              globalKey: GlobalKey(),
                              onDismissCallback: () {
                                isOpen = false;
                                setState(() {});
                              });
                        },
                        child: Obx(() => CustomIconButton(
                          // onTap: () {
                          //   DialogUtils.showCustomBubbleDialog(
                          //       context, _buildBubbleChild(), AppValues.allianceWidth_124,
                          //       key: _popKey, backgroundColor: ThemeService().colorScheme.tertiary);
                          // },
                          name: widget.selectList![widget.index].btn,
                          style: ThemeService().theme.textTheme.bodyMedium!.copyWith(color: logic.state.showAll.value ? AppThemes.hintTextColor : Colors.white),
                          direction: Direction.right,
                          iconWidget: Obx(() => FaIcon(
                            isOpen ? FontAwesomeIcons.angleUp : FontAwesomeIcons.angleDown,
                            size: AppValues.sportIcon_9_41.w,
                            color: logic.state.showAll.value ? AppThemes.hintTextColor : AppThemes.iconColor,
                          )),
                          widgetHeight: 40,
                          widgetWidth: logic.state.globalController.isChinese() ? AppValues.sportWidth_80.w : (logic.state.globalController.isVi() ? 160 : 100),
                          iconHeight: AppValues.sportIcon_9_41.w,
                          iconWidth: AppValues.sportIcon_9_41.w,
                          borderRadius: 4,
                          backgroundColor: ThemeService().theme.colorScheme.surface,
                          iconThemeData: ThemeService().theme.iconTheme,
                        )),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
        if (widget.tabs!.isNotEmpty &&
            (widget.title == S.current.sport_tabbar_rolling ||
                widget.title == S.current.sport_tabbar_coming ||
                widget.title == S.current.sport_fav_comming_rolling ||
                widget.title == S.current.sport_fav_hot_rolling ||
                widget.title == S.current.random_text_680))
          CustomSportCategoryBar(
            widget.tabs ?? <SportHallCountModel>[],
            (index) {
              if (widget.onTapGame != null) {
                widget.onTapGame!(index);
              }
            },
            title: widget.title,
            index: widget.cIndex,
            model: logic.state.filterModel.listFilter![widget.isSide! ? 1 : logic.state.indexMain],
          ),
        sortW(widget.index),
        Visibility(
          visible: widget.competitionList!.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(
                left: AppValues.sportPadding_12.w, right: AppValues.sportPadding_12.w),
            child: Divider(
              color: AppThemes.widgetColorWhite.withOpacity(0.3),
              height: AppValues.sportHeight_1,
              indent: 0,
              endIndent: 0,
            ),
          ),
        ),
        if (widget.m == true && widget.competitionList!.isNotEmpty)
          GestureDetector(
            onTap: () => widget.sportBetClick(SportClikType.more, 0, 0, 0, 0, ''),
            child: Container(
              margin: EdgeInsets.only(
                  top: AppValues.sportPadding_12.w,
                  left: AppValues.sportPadding_12.w,
                  right: AppValues.sportPadding_12.w),
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))),
              height: 46.h,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: AppValues.sportPadding_12.w, left: AppValues.sportPadding_12.w),
                  child: Text(S.current.sport_add_more,
                      style: ThemeService().textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffb1bad3))),
                ),
              ),
            ),
          ),

        // SizedBox(width: AppValues.sportHeight_16.w),
        // CustomSportSection(
        //   SportListCategotyType.sport_hot,
        //   sportBetClick,
        //   0,
        //   categoryTabs: this.hotCompetitionList,
        //   sportMap: this.sportMap,
        // ),
      ],
    );
  }

  String gn() {
    int a = widget.tabs?.length ?? 0;
    if (a > 0) {
      String? b = (widget.tabs?[widget.cIndex ?? 0].sn.toString());
      return b ?? '';
    } else {
      return '';
    }
  }

  String getIcon(String title) {
    if (title == S.current.sport_tabbar_rolling) {
      switch (logic.state.indexMain) {
        case 0:
          return 'assets/images/sport/sport_today.webp';
        case 1:
          return 'assets/images/sport/sport_rolling_w.webp';
        case 2:
          return 'assets/images/sport/sport_trade.webp';
        case 3:
          return 'assets/images/sport/sport_collusion.webp';
        case 4:
          return 'assets/images/sport/sport_champion.webp';
        default:
      }
      return 'assets/images/sport/sport_today.webp';
    } else if (title == S.current.sport_bet_hot) {
      return 'assets/images/sport/sport_hots.webp';
    } else if (title == S.current.random_text_680) {
      return 'assets/images/sport/sport_vr.webp';
    } else if (title == S.current.sport_fav_hot_rolling) {
      return 'assets/images/sport/sport_collection.webp';
    } else if (title == S.current.sport_fav_comming_rolling) {
      return 'assets/images/sport/sport_collection.webp';
    } else if (title == S.current.sport_tabbar_coming) {
      return 'assets/images/sport/sport_coming.webp';
    } else {
      return 'assets/images/sport/sport_rolling.webp';
    }
  }

  ///获胜盘下拉框
  Widget _buildBubbleChild() {
    var index = widget.index;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.smallPadding),
        child: Column(
          children: widget.selectList!.asMap().entries.map((v) {
            return GestureDetector(
              child: Container(
                alignment: logic.state.globalController.isChinese() ? Alignment.center : Alignment.centerLeft,
                height: AppValues.allianceHeight_30.h,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.halfMargin),
                  child: CustomText(
                    v.value.btn!,
                    style: TextStyle(
                      color: v.key == widget.index
                          ? ThemeService().theme.buttonTheme.colorScheme?.primary
                          : ThemeService().theme.buttonTheme.colorScheme?.tertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ),
              onTap: () {
                RouteUtil.popView(result: v.key.toString());
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  ///今日赛事下拉框
  Widget _buildBubbleMainChild() {
    var indexMain = logic.state.indexMain;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.smallPadding),
        child: Column(
          children: logic.state.filterModel.listFilter!.asMap().entries.map((v) {
            return GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: AppValues.allianceHeight_30.h,
                child: CustomText(
                  v.value.name!,
                  style: TextStyle(
                    color: v.key == logic.state.indexMain
                        ? ThemeService().theme.buttonTheme.colorScheme?.primary
                        : ThemeService().theme.buttonTheme.colorScheme?.tertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                RouteUtil.popView(result: v.key.toString());
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNoDataView(String title) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              // 'assets/images/sport/sport_nodata.webp',
              'assets/images/status/ic_status_view_empty.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget sortW(int sortIndex) {
    bool h = false;
    String sort = '';
    if (sortIndex == 0) {
      sort = '43';
    } else if (sortIndex == 1) {
      sort = '1';
    } else {
      sort = '2';
    }

    widget.competitionList?.forEach((element) {
      element.ml?.forEach((e) {
        e.oen = element.oen;
        if (sort.contains(e.bt.toString())) {
          h = true;
        }
      });
    });
    if (logic.state.indexMain == logic.state.filterModel.listFilter!.length - 1) h = widget.competitionList!.isNotEmpty;
    return widget.isShimmerView == true
        ? const CustomShimmer()
        : (h
            ? CustomSportSection(
                SportListCategotyType.sport_other,
                widget.sportBetClick,
                0,
                widget.index,
                widget.title,
                gn(),
                (widget.tabs?[widget.cIndex ?? 0].nc ?? '').toString(),
                categoryTabs: widget.competitionList,
                sportMap: widget.sportMap,
                indexMain: logic.state.indexMain,
                indexLength: logic.state.filterModel.listFilter!.length,
                isSide: widget.isSide,
              )
            : _buildNoDataView(S.current.random_text_683));
  }
}
