import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/gamelist_model.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/account/login/login_widget.dart';
import 'package:flutter_bet/pages/find/logic.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_icon.dart';

///游戏的横向翻页列表
class CasinoChangguanFlipList extends StatefulWidget {
  final List<YuLeChengChangGuanModel> items;
  final String title;
  final String icon;
  final Function onTap;
  int? showType = 0;
  int? currentIndex; // lobby 加载的第几个

  Function? statusCallback;

  CasinoChangguanFlipList({
    super.key,
    required this.items,
    required this.title,
    required this.icon,
    required this.onTap,
    this.showType,
    this.currentIndex,
    this.statusCallback,
  });

  @override
  State<StatefulWidget> createState() => _createCasinoState();
}

class _createCasinoState extends State<CasinoChangguanFlipList> {
  late PageController pageController;
  late ScrollController scrollController;
  late int currentPage;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    pageController = PageController();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

// Callback function to handle scroll events
  void _scrollListener() {
    // Get the current scroll offset
    if (widget.statusCallback != null) {
      widget.statusCallback!(widget.currentIndex, scrollController);
    }
    double offset = scrollController.offset;
    if (offset >= scrollController.position.maxScrollExtent) {
      widget.showType = 1;
    } else if (offset <= 0) {
      widget.showType = 0;
    } else {
      widget.showType = 2;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: AppValues.margin_12, top: AppValues.margin_12),
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              widget.icon == 'assets/images/home/ic_game_provider.webp'
                  ? SizedBox(
                      child: Image.asset(
                        widget.icon,
                        fit: BoxFit.fitWidth,
                      ).tight(
                        width: 20,
                        height: 20,
                      ),
                    )
                  : SizedBox(
                      child: CustomNetWorkImage(
                        width: 20,
                        height: 20,
                        imageUrl: BranchService.instance.current.asset_url + widget.icon,
                        errorWidget: const SizedBox(),
                      ),
                    ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                  onTap: () {
                    // RouteUtil.pushToView(Routes.yulechengCategoryPage,
                    //     arguments: {"title": widget.title, "fromChangguanPage": 3});
                  },
                  child: CupertinoButton(
                    // color: Colors.blue, // 设置按钮颜色
                    alignment: Alignment.centerRight,
                    pressedOpacity: 0.5, // 设置按钮按下时的不透明度
                    child: Text(widget.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      // 按钮点击时的处理逻辑
                      RouteUtil.pushToView(Routes.yulechengCategoryPage,
                          arguments: {"title": widget.title, "fromChangguanPage": 3});
                    },
                  ) /*CustomText(
                  widget.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),*/
                  ),
              const Expanded(child: SizedBox()),
              _buildChangeButton(currentPage),
            ],
          ),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: AppValues.halfMargin),
          /*child:  PageView.builder(
              controller: pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemCount: (widget.items.length / 3).ceil(), // 计算总页数
              itemBuilder: (context, pageIndex) {
                final startIndex = pageIndex * 3;
                final endIndex =
                    (startIndex + 3 <= widget.items.length) ? startIndex + 3 : widget.items.length;
                final pageItems = widget.items.sublist(startIndex, endIndex);
                return HorizontalListView(items: pageItems);
              }),*/
          child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length == 0 ? 3 : widget.items.length,
              itemBuilder: (context1, index) {
                return GestureDetector(
                  onTap: () {
                    if (widget.items[index].maintained == "2") {
                      return;
                    }
                    widget.onTap(widget.items[index]);
                  },
                  child: Container(
                    width: Get.width / 3 - 8 - AppValues.defaultPadding,
                    alignment: Alignment.center,
                    child: widget.items.length == 0
                        ? const SizedBox()
                        : Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: ThemeService().colorScheme.surface,
                                      offset: Offset(0.0, 4.0),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppValues.halfPadding),
                                  child: CustomNetWorkImage(
                                    imageUrl: BranchService.instance.current.asset_url +
                                        widget.items[index].icon
                                            .replaceAll("%lang%", LangUtil().getLangType()),
                                    errorWidget: LimitedBox(
                                      child: <Widget>[
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(AppValues.smallPadding),
                                            ),
                                          ),
                                          // 使用Color.fromRGBO来设置半透明颜色
                                        ).paddingHorizontal(AppValues.smallPadding),
                                        <Widget>[
                                          Image.asset(
                                            'assets/images/ic_image_loading_error.webp',
                                            fit: BoxFit.cover,
                                          ).tight(height: 20),
                                          CustomText(
                                            S.current.image_load_error,
                                            style:
                                                TextStyle(color: AppThemes.iconColor, fontSize: 12),
                                          ).paddingTop(5).center(),
                                        ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
                                      ].toStack(),
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.items[index].maintained == "2")
                                // 半透明蒙版
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppValues.smallPadding),
                                    ),
                                  ),
                                  // 使用Color.fromRGBO来设置半透明颜色
                                ).paddingHorizontal(AppValues.smallPadding),
                              if (widget.items[index].maintained == "2")
                                // 上层内容
                                <Widget>[
                                  SvgPicture.asset("assets/svg/icon _yulecheng_maintanance.svg")
                                      .tightSize(16)
                                      .center()
                                      .paddingBottom(AppValues.halfPadding),
                                  Text(
                                    S.current.game_category_repair,
                                    style: ThemeService().theme.textTheme.bodySmall,
                                  ),
                                ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
                              // Text(
                              //   widget.items[index].zhName,
                              //   style: ThemeService().theme.textTheme.bodyMedium,
                              // ).alignBottom().center().paddingHorizontal(AppValues.halfPadding),
                            ],
                          ).paddingVertical(3),
                  ).paddingHorizontal(AppValues.halfPadding),
                );
              }),
        ),
      ],
    );
  }

  void _goToPage(int page) {
    var newOffset = scrollController.offset + page * (Get.width - 28);
    if (newOffset > scrollController.position.maxScrollExtent) {
      newOffset = scrollController.position.maxScrollExtent;
    } else if (newOffset < 0) {
      newOffset = 0;
    }
    scrollController.animateTo(newOffset,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

    // pageController.animateToPage(
    //   page,
    //   duration: Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }

  Widget _buildChangeButton(int currentPage) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // if (currentPage > 0) {
              //   _goToPage(-1);
              // }
              _goToPage(-1);
            },
            child: Container(
              width: 49,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  border: Border.all(
                      color: widget.showType == 0
                          ? AppThemes.ylclightGreyColor
                          : AppThemes.ylclightGreyColor)),
              child: SvgPicture.asset(
                'assets/svg/yulecheng_arrow_left.svg',
                colorFilter: ColorFilter.mode(
                  widget.showType == 0 ? AppThemes.ylclightGreyColor : AppThemes.textColorSecondary,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 0,
          ),
          GestureDetector(
            onTap: () {
              // if (currentPage < (widget.items.length / 3).ceil()) {
              //   _goToPage(1);
              // }
              _goToPage(1);
            },
            child: Container(
              width: 49,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                  border: Border.all(
                      color: widget.showType == 1 || widget.items.length < 4
                          ? AppThemes.ylclightGreyColor
                          : AppThemes.ylclightGreyColor)),
              child: SvgPicture.asset(
                'assets/svg/yulecheng_arrow_right.svg',
                colorFilter: ColorFilter.mode(
                  widget.showType == 1 || widget.items.length < 4
                      ? AppThemes.ylclightGreyColor
                      : AppThemes.textColorSecondary,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    pageController.dispose();
  }
}
