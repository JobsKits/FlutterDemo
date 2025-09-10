import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/upload_image_util.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';

// 子账号
class SubAccountWidget extends StatefulWidget {
  final String selectId;
  final List<dynamic> subList;
  final StringCallback? callback;

  const SubAccountWidget({
    super.key,
    required this.selectId,
    required this.subList,
    this.callback,
  });

  @override
  State<SubAccountWidget> createState() => _SubAccountWidgetState();
}

class _SubAccountWidgetState extends State<SubAccountWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.7.sh,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Text(
                  "选择下级会员账号",
                  style: TextStyle(fontSize: 48.sp),
                ),
                SizedBox(height: 40.h),
                Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: Colors.black26,
                ),
                Expanded(child: _buildList())
              ],
            ),
          ),
          Positioned(
            top: 40.h,
            right: 30.w,
            child: CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
              },
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: widget.subList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Obx(() => _buildItem(index));
      },
    );
  }

  Widget _buildItem(int index) {
    var itemData = widget.subList[index];
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        if (widget.callback != null) {
          widget.callback!('${itemData['acct_id']}');
        }
        Get.back();
      },
      child: Container(
        height: 152.h,
        padding: EdgeInsets.symmetric(horizontal: 42.w),
        child: Row(
          children: [
            SizedBox(
              width: 30.w,
            ),
            Expanded(child: Text("${itemData['partner_name']}")),
            SizedBox(
              width: 40.w, // 设置宽度
              height: 40.h, // 设置高度
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // 圆形
                ),
                value: widget.selectId == '${itemData['acct_id']}',
                onChanged: (value) {
                  if (widget.callback != null) {
                    widget.callback!('${itemData['acct_id']}');
                  }
                  Get.back();
                },
                activeColor: context.theme.primaryColor, // 选中颜色
                checkColor: Colors.white, // 选中时的勾选颜色
                side: const BorderSide(color: Colors.grey), // 未选中时的边框颜色
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
