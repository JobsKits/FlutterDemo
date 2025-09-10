import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';

class BonusCodeDialog extends StatefulWidget {
  final String aid;
  const BonusCodeDialog({
    super.key,
    required this.aid,
  });

  @override
  State<BonusCodeDialog> createState() => _BonusCodeDialogState();
}

class _BonusCodeDialogState extends State<BonusCodeDialog> {
  String code = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: 597.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '填写优惠码',
                  style: TextStyle(
                    fontSize: 57.sp,
                    color: const Color(0xFF3B3B3B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 显示在外部的 Text
                    Padding(
                      padding: EdgeInsets.only(
                          left: 62.w, right: 20.w), // 控制 Text 和 Container 的间距
                      child: Text(
                        '优惠码',
                        style: TextStyle(
                          fontSize: 40.sp,
                          color: const Color(0xFF3B3B3B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // 包裹 TextField 的 Container
                    Expanded(
                      child: Container(
                        height: 125.h,
                        margin: EdgeInsets.only(right: 62.w), // 添加右边距
                        decoration: BoxDecoration(
                          color: const Color(colorF4F4F4),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            code = value;
                          },
                          cursorColor: context.theme.primaryColor,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 60.h, left: 36.w),
                            hintText: "请输入优惠码",
                            hintStyle: TextStyle(
                              fontSize: 36.sp,
                              color: const Color(colorBCBCBC),
                            ),
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
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 210.w,
                    right: 210.w,
                    bottom: 30.w,
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10C8E3), Color(0xFF00F5FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x8000DEFF),
                        offset: Offset(0, 6.w),
                        blurRadius: 10.w,
                      ),
                    ],
                  ),
                  height: 120.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      AppManager.instance.tapVibrate();
                      if (code.isEmpty) {
                        Get.snackbar('提示', '请输入优惠码');
                        return;
                      }
                      final res =
                          await ActivityApi.submitPromoCode(widget.aid, code);
                      if (res.type == NetworkService.networkTypeSuccess) {
                        Get.back();

                        String msg;
                        if (res.data['response_code'] == '0') {
                          msg = res.data['msg'];
                        } else {
                          msg = res.data['t']['info'];
                        }

                        Get.dialog(
                          TipsDialog(tips: msg),
                          barrierDismissible: false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      child: Text(
                        '提交',
                        style: TextStyle(
                          fontSize: 48.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 38.h,
              right: 46.w,
              child: InkWell(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Icon(
                    Icons.clear,
                    size: 72.w,
                    color: Colors.black26,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
