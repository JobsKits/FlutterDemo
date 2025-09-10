import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_manager.dart';
import '../../../../utils/common_color.dart';
import '../controllers/new_home_controller.dart';

class CommonGameSearchView extends StatefulWidget {
  final bool? isShowAll;
  final VoidCallback? clickHot;
  final VoidCallback? clickAll;
  final VoidCallback? clickCollect;
  final VoidCallback? clickRecent;
  final ValueChanged<String>? search;
  final bool? isGameTry;
  const CommonGameSearchView(
      {super.key,
      this.isShowAll = false,
      this.clickHot,
      this.clickAll,
      this.clickCollect,
      this.clickRecent,
      this.isGameTry = false,
      this.search});

  @override
  State<CommonGameSearchView> createState() => _CommonGameSearchViewState();
}

class _CommonGameSearchViewState extends State<CommonGameSearchView>
    with TickerProviderStateMixin {
  var tabArray = [
    "热门",
    "全部",
    "收藏",
    "最近",
  ];
  int currentSelectIndex = 0;
  @override
  void initState() {
    if (widget.isShowAll == false) {
      tabArray.removeWhere((item) => item == "全部");
    }
    super.initState();
  }

  Widget tabView() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabArray.length, (index) {
          return _buildSearchTabItem(context, index);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.customTheme?.pageBg,
      padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
      child: (widget.isGameTry ?? false)
          ? gameTrySearchView()
          : normalSearchView(),
    );
  }

  Widget gameTrySearchView() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
              height: 100.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                  color: context.customTheme!.homeGameSearchBgColor,
                  borderRadius: BorderRadius.circular(20.r)),
              child: GestureDetector(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  // controller.changeSearchStatus(!controller.isSearch.value);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: TextField(
                      // controller: controller.searchNameController,
                      // focusNode: controller.searchFocusNode,
                      cursorColor: context.theme.primaryColor,
                      textInputAction: TextInputAction.search,
                      onSubmitted: widget.search,
                      onChanged: widget.search,
                      style: TextStyle(
                          color: context.customTheme?.homeGameSearchTxtColor),
                      decoration: InputDecoration(
                        hintText: "搜索游戏",
                        contentPadding: EdgeInsets.only(left: 10.w),
                        hintStyle: TextStyle(
                            fontSize: 45.sp,
                            color: context
                                .customTheme?.homeGameSearchHintTxtColor),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                      ),
                    )),
                    Image.asset(
                      Assets.theme1.images.home.iconHomeGameSearch.path,
                      width: 46.w,
                      height: 46.h,
                    ),
                  ],
                ),
              )),
        ),
        Expanded(
          flex: 2,
          child: Container(
              height: 100.h,
              margin: EdgeInsets.only(right: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                  color: context.customTheme!.homeGameSearchBgColor,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "全部试玩",
                    style: TextStyle(
                        color: context.customTheme?.homeGameSearchHintTxtColor,
                        fontSize: 45.sp),
                  )),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.customTheme?.homeGameSearchHintTxtColor,
                    size: 80.w,
                  )
                ],
              )),
        ),
      ],
    );
  }

  Widget normalSearchView() {
    return Row(
      children: [
        Expanded(
          child: tabView(),
        ),
        Expanded(
          child: Container(
              height: 100.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                  color: context.customTheme!.homeGameSearchBgColor,
                  borderRadius: BorderRadius.circular(20.r)),
              child: GestureDetector(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  // controller.changeSearchStatus(!controller.isSearch.value);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: TextField(
                      // controller: controller.searchNameController,
                      // focusNode: controller.searchFocusNode,
                      cursorColor: context.theme.primaryColor,
                      textInputAction: TextInputAction.search,
                      onSubmitted: widget.search,
                      onChanged: widget.search,
                      style: TextStyle(
                          color: context.customTheme?.homeGameSearchTxtColor),
                      decoration: InputDecoration(
                        hintText: "搜索游戏",
                        contentPadding: EdgeInsets.only(left: 10.w),
                        hintStyle: TextStyle(
                            fontSize: 45.sp,
                            color: context
                                .customTheme?.homeGameSearchHintTxtColor),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                      ),
                    )),
                    Image.asset(
                      Assets.theme1.images.home.iconHomeGameSearch.path,
                      width: 46.w,
                      height: 46.h,
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildSearchTabItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        switch (tabArray[index]) {
          case "热门":
            currentSelectIndex = index;
            widget.clickHot?.call();
            break;
          case "全部":
            currentSelectIndex = index;
            widget.clickAll?.call();
            break;
          case "收藏":
            if (LoginManager.instance.isLogin.value) {
              currentSelectIndex = index;
              widget.clickCollect?.call();
            } else {
              showLoginDialog();
            }
            break;
          case "最近":
            currentSelectIndex = index;
            widget.clickRecent?.call();
            break;
        }
        setState(() {});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tabArray[index],
            style: currentSelectIndex == index
                ? TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.sp,
                    color: context.theme.primaryColor)
                : TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.sp,
                    color: const Color(colorAFAFAF)),
          ),
          SizedBox(
            height: 6.h,
          ),
          CircleAvatar(
            backgroundColor: currentSelectIndex == index
                ? context.theme.primaryColor
                : Colors.transparent,
            radius: 6.w,
          )
        ],
      ),
    );
  }
}
