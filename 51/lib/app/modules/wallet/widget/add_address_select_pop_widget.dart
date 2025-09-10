import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

// import '../controllers/add_address_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../data/add_address_select_pop_bean.dart';

typedef PopCallback = void Function(AddAddressSelectPopBean data);

/// 添加地址的弹窗
class AddAddressSelectPopWidget extends StatefulWidget {
  final String label; // 标题
  final String? iconUrl; // 图标地址
  final List<AddAddressSelectPopBean> popSelectList;
  final AddAddressSelectPopBean? currentPopSelect;
  final PopCallback? onTap;
  final bool? isShowSearch;

  const AddAddressSelectPopWidget({
    super.key,
    required this.label,
    required this.popSelectList,
    this.currentPopSelect,
    this.onTap,
    this.iconUrl,
    this.isShowSearch = false,
  });

  @override
  State<AddAddressSelectPopWidget> createState() =>
      _AddAddressSelectPopWidgetState();
}

class _AddAddressSelectPopWidgetState extends State<AddAddressSelectPopWidget> {
  RxList<AddAddressSelectPopBean> currentList = <AddAddressSelectPopBean>[].obs;
  List<AddAddressSelectPopBean> allList = [];
  RxString searchKey = "".obs;
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    allList = widget.popSelectList;
    currentList.value = widget.popSelectList;
  }

  void refreshList(String value) {
    if (widget?.isShowSearch == false) return;
    searchKey.value = value;
    if (searchKey.isEmpty) {
      // 如果搜索框为空，恢复所有数据
      currentList.value = List.from(widget.popSelectList);
      editingController.text = "";
    } else {
      // 否则根据搜索关键字过滤数据
      currentList.value =
          allList.where((item) => item.name.contains(searchKey)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentList.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      margin: EdgeInsets.only(bottom: 40.h),
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(30.r)),
      height: 160.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: TextStyle(
                fontSize: 45.sp, color: context.customTheme?.titleColor),
          ),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              showSelectPop();
            },
            child: Row(
              children: [
                widget.iconUrl != null
                    ? Image.asset(
                        widget.iconUrl!,
                        width: 78.w,
                        height: 78.w,
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  width: 18.w,
                ),
                Text(
                  widget.currentPopSelect!.name,
                  style: TextStyle(
                      fontSize: 45.sp, color: context.customTheme?.titleColor),
                ),
                SizedBox(
                  width: 37.w,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 50.h,
                  color: context.customTheme?.arrowColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //显示选择币种弹窗
  void showSelectPop() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: context.customTheme?.pageBg,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.r), topRight: Radius.circular(50.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 重要：只占用最小高度
          children: [
            Container(
              padding: EdgeInsets.only(right: 40.w),
              decoration: BoxDecoration(
                color: context.customTheme?.pageTwoBg,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r)),
              ),
              height: 130.h,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "选择${widget.label}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 51.sp,
                        color: context.customTheme?.titleColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      Get.back();
                      refreshList("");
                    },
                    child: Icon(Icons.close,
                        color: context.customTheme?.dialogXColor),
                  )
                ],
              ),
            ),
            Visibility(
                visible: (widget?.isShowSearch ?? false),
                child: Container(
                    height: 100.h,
                    margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: context.customTheme?.lineColor ??
                                const Color(colorEDEDED)),
                        color: context.customTheme?.inputBgColor,
                        borderRadius: BorderRadius.circular(45.r)),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.theme1.images.video.iconSearch,
                            width: 46.w,
                            height: 46.h,
                          ),
                          Expanded(
                              child: TextField(
                            onChanged: (value) {
                              refreshList(value);
                            },
                            style: TextStyle(
                                fontSize: 45.sp,
                                color: context.customTheme?.titleColor),
                            controller: editingController,
                            cursorColor: context.theme.primaryColor,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: "搜索",
                              contentPadding: EdgeInsets.only(left: 10.w),
                              hintStyle: TextStyle(
                                  fontSize: 45.sp,
                                  color: context.customTheme?.title3Color),
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
                          Obx(() => Visibility(
                              visible: searchKey.isNotEmpty,
                              child: InkWell(
                                onTap: () {
                                  AppManager.instance.tapVibrate();
                                  Get.focusScope?.unfocus();
                                  refreshList("");
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.black26,
                                  radius: 26.w,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 40.w,
                                  ),
                                ),
                              )))
                        ],
                      ),
                    ))),
            Expanded(
              child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      if (index >= currentList.length) {
                        return SizedBox(); // 或者你可以返回一个错误提示 widget
                      }
                      var itemData = currentList[index];
                      return Container(
                        height: 180.h,
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        margin:
                            EdgeInsets.only(top: 20.h, left: 30.w, right: 30.w),
                        decoration: BoxDecoration(
                            color: context.customTheme?.pageTwoBg,
                            borderRadius: BorderRadius.circular(30.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                widget.iconUrl != null
                                    ? Image.asset(
                                        widget.iconUrl!,
                                        width: 100.w,
                                        height: 100.w,
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(
                                  width: 32.w,
                                ),
                                Text(itemData.name,
                                    style: TextStyle(
                                        color:
                                            context.customTheme?.titleColor)),
                              ],
                            ),
                            SizedBox(
                              width: 82.w, // 设置宽度
                              height: 82.h, // 设置高度
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50), // 圆形
                                ),
                                value: widget.currentPopSelect!.value ==
                                    itemData.value,
                                onChanged: (bool? value) {
                                  if (widget.currentPopSelect!.value !=
                                      itemData.value) {
                                    AppManager.instance.tapVibrate();
                                    if (widget.onTap != null) {
                                      widget.onTap!(itemData);
                                    }
                                    Get.back();
                                    refreshList("");
                                  }
                                },
                                activeColor: context.theme.primaryColor, // 选中颜色
                                checkColor: Colors.white, // 选中时的勾选颜色
                                side: const BorderSide(
                                    color: Colors.grey), // 未选中时的边框颜色
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            )
          ],
        ),
      ),
      isDismissible: false,
    );
  }
}
