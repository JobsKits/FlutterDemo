import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';

import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/gamelist_model.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/account/login/login_widget.dart';
import 'package:flutter_bet/pages/find/logic.dart';
import 'package:flutter_bet/pages/personal_center/wallet/cardbag_exoansion.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_icon.dart';

///游戏的横向翻页列表
class CasinoPageFlipListNoLitems extends StatefulWidget {
  final List<GameListModel> itemsList;
  final String title;
  final String icon;
  final Function onTap;
  final int currentIndex; // lobby 加载的第几个
  bool needshowChaKanGengDuo; // 是否需要显示查看更多
  int showType = 0;
  bool needShowPlayer;
  final Function onTitleTap;

  CasinoPageFlipListNoLitems({
    super.key,
    required this.itemsList,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.currentIndex,
    required this.needshowChaKanGengDuo,
    this.needShowPlayer = false,
    required this.onTitleTap,
  });

  @override
  State<StatefulWidget> createState() => _createCasinoState();
}

class _createCasinoState extends State<CasinoPageFlipListNoLitems> {
  late PageController pageController;
  late ScrollController scrollController;
  late int currentPage;

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
    widget.needshowChaKanGengDuo = false;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: AppValues.margin_12, top: AppValues.margin_12),
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              widget.icon == "assets/images/yulecheng/ic_hot.webp"
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
                  if (widget.itemsList.isNotEmpty) {
                    widget.onTitleTap(widget.currentIndex);
                  }
                },
                child: CustomText(
                  widget.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const Expanded(child: SizedBox()),
              _buildChangeButton(currentPage),
            ],
          ),
        ),
        <Widget>[
          Container(
            height: widget.needShowPlayer
                ? ((Get.width - 48) / 3.0) * 18.0 / 11.0
                : ((Get.width - 48) / 3.0) * 15.0 / 11.0 + AppValues.defaultPadding,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.itemsList.isEmpty
                    ? 3
                    : widget.needshowChaKanGengDuo == true && widget.itemsList.isNotEmpty
                        ? widget.itemsList.length + 1
                        : widget.itemsList.length,
                itemBuilder: (context1, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == widget.itemsList.length &&
                          widget.needshowChaKanGengDuo == true) {
                        if (widget.currentIndex == -1) {
                          widget.onTitleTap(widget.currentIndex);
                          return;
                        }
                        widget.onTap(widget.itemsList[index - 1], true, widget.currentIndex);
                        return;
                      }
                      if (widget.itemsList[index].maintained == "2") {
                        return;
                      }
                      widget.onTap(widget.itemsList[index], false, widget.currentIndex);
                    },
                    child: Container(
                      width: (Get.width - AppValues.defaultPadding * 4) / 3,
                      alignment: Alignment.center,
                      child: widget.itemsList.isEmpty
                          ? const SizedBox()
                          : index == widget.itemsList.length &&
                                  widget.needshowChaKanGengDuo == true &&
                                  widget.itemsList.isNotEmpty
                              ? chakanQuanBu()
                              : <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      CustomNetWorkImage(
                                        imageUrl: BranchService.instance.current.asset_url +
                                            widget.itemsList[index].gameImgUrl,
                                        placeholder: CustomNetWorkImage(
                                            imageUrl: BranchService.instance.current.asset_url +
                                                widget.itemsList[index].img
                                                    .replaceAll(".webp", ".s.webp")
                                                    .replaceAll(
                                                        "%lang%", LangUtil().getLangType())),
                                      ),
                                      if (widget.itemsList[index].maintained == "2")
                                        // 半透明蒙版
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(AppValues.smallPadding),
                                            ),
                                          ),
                                          // 使用Color.fromRGBO来设置半透明颜色
                                        ),
                                      if (widget.itemsList[index].maintained == "2")
                                        // 上层内容
                                        <Widget>[
                                          // SvgPicture.asset(
                                          // "assets/svg/icon _yulecheng_maintanance.svg")
                                          // .center(),
                                          Image.network(BranchService.instance.current.asset_url +
                                                  "/images/common/%lang%/maintained.webp"
                                                      .replaceAll(
                                                          "%lang%", LangUtil().getLangType()))
                                              .center(),
                                          // Text(
                                          //   S.current.game_category_repair,
                                          //   style: ThemeService().theme.textTheme.bodyMedium,
                                          // )
                                          //     .alignBottom()
                                          //     .center()
                                          //     .paddingHorizontal(AppValues.halfPadding)
                                          //     .paddingTop(AppValues.defaultPadding),
                                        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                                      // if (index == widget.items.length - 1 &&
                                      //     widget.needshowChaKanGengDuo == true)
                                      //   Container(
                                      //     color: const Color.fromRGBO(0, 0, 0, 0.5),
                                      //     // 使用Color.fromRGBO来设置半透明颜色
                                      //   ),
                                      // if (index == widget.items.length - 1 &&
                                      //     widget.needshowChaKanGengDuo == true)
                                      //   Text(
                                      //     S.current.chaKanQuanBu,
                                      //     style: ThemeService().theme.textTheme.bodyMedium,
                                      //   ).center(),
                                    ],
                                  ).expanded(),
                                  if (!widget.needShowPlayer)
                                    SizedBox(
                                      height: AppValues.defaultPadding,
                                    ),
                                  if (widget.needShowPlayer)
                                    <Widget>[
                                      // Container(
                                      //   decoration: const BoxDecoration(
                                      //     borderRadius: BorderRadius.all(Radius.circular(4)),
                                      //     color: AppThemes.chatRoomOnlineGreenColor,
                                      //   ),
                                      // ).tight(width: 8, height: 8).paddingLeft(3),
                                      Image.asset(
                                        "assets/svg/green_pot.webp",
                                        width: 20,
                                        height: 20,
                                      ),
                                      CustomText(
                                          widget.itemsList[index].playerAmount! +
                                              S.current.random_text_578,
                                          style: TextStyle(fontSize: AppValues.fontBodySmallSize)),
                                    ].toRow().tight(height: 30).alignBottom()
                                ].toColumn(),
                    )
                        .marginOnly(
                            left: AppValues.defaultPadding,
                            right:
                                index == widget.itemsList.length - 1 ? AppValues.defaultPadding : 0)
                        .padding(
                            right:
                                widget.itemsList.length < 3 && index == widget.itemsList.length - 1
                                    ? ((Get.width - 48) / 3.0) * (3 - widget.itemsList.length)
                                    : 0),
                  );
                }),
          ),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ],
    );
  }

  Widget chakanQuanBu() {
    return <Widget>[
      Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/yulecheng/icon_check_more.webp",
            fit: BoxFit.fill,
          ),
          Text(
            S.current.chaKanQuanBu,
            style: ThemeService().theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
          ).center(),
        ],
      ).expanded(),
      if (widget.needShowPlayer) SizedBox().tight(height: 30).alignBottom()
    ].toColumn().paddingLeft(AppValues.halfPadding);
  }

  void _goToPage(int page) {
    var newOffset = scrollController.offset + page * (Get.width - AppValues.defaultPadding);
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
                      color: widget.showType == 1
                          ? AppThemes.ylclightGreyColor
                          : AppThemes.ylclightGreyColor)),
              child: SvgPicture.asset(
                'assets/svg/yulecheng_arrow_right.svg',
                colorFilter: ColorFilter.mode(
                  widget.showType == 1 ? AppThemes.ylclightGreyColor : AppThemes.textColorSecondary,
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

class HorizontalListView extends StatelessWidget {
  final List<String> items;

  HorizontalListView({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: (Get.width / 3 - 8) * 3 / 4,
        child: Row(
          children: [
            buildItem(0),
            buildItem(1),
            buildItem(2),
          ],
        ));
  }

  Widget buildItem(int index) {
    if (index < items.length) {
      return Container(
        width: Get.width / 3 - 8,
        alignment: Alignment.center,
        child: Image.asset(
          items[index],
          fit: BoxFit.fitWidth,
          height: (Get.width / 3 - 8) * 3 / 4,
        ),
      );
    } else {
      return Container();
    }
  }
}
