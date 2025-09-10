import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/CommonRipple.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class AgentTransferDialog extends StatefulWidget {
  final VoidCallback? onPress;
  final String? username;
  final String? userid;
  final String? amount;
  final String? remark;
  const AgentTransferDialog({
    super.key,
    this.username,
    this.userid,
    this.amount,
    this.remark,
    this.onPress,
  });

  @override
  _AgentTransferDialogState createState() => _AgentTransferDialogState();
}

class _AgentTransferDialogState extends State<AgentTransferDialog>
    with SingleTickerProviderStateMixin {

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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent.withOpacity(0),
            ),
          ),
          Align(
            // 使用 Align 包裹 Positioned
            alignment: Alignment.center, // 居中
            child: Column(
              mainAxisSize: MainAxisSize.min, // 使 Column 仅占用所需空间
              children: [
                Container(
                  width: 0.8.sw, // Dialog width as a percentage of screen width
                  height: 870.h, // Dialog height as a percentage of screen height
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      _buildTitle(), // Title fixed at the top
                      Expanded(
                        child: SingleChildScrollView(
                          // Only the body scrolls
                          child: _buildBody(),
                        ),
                      ),
                      _buildButtonArea(),
                      const SizedBox(height: 25)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 45),
          const Expanded(
            child: Center(
              child: Text(
                '转账信息确认',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          CommonRipple(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 30,
              height: 30,
              child: const Icon(
                Icons.close_sharp,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
          const SizedBox(width: 15)
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '为了您的资金安全，请确认会员身份信息，以防转错',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 38.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Column(
              children: [
                // 会员姓名
                _buildInfoRowWithBorder(
                  label: '会员姓名',
                  value: widget.username ?? '',
                  mainColor: false
                ),
                // 会员ID
                _buildInfoRowWithBorder(
                  label: '会员ID',
                  value: widget.userid ?? '',
                  mainColor: false
                ),
                // 转入金额
                _buildInfoRowWithBorder(
                  label: '转入金额',
                  value: widget.amount ?? '',
                  mainColor: true
                ),
                // 备注
                _buildInfoRowWithBorder(
                  label: '备注',
                  value: widget.remark ?? '',
                  mainColor: false
                ),
              ],
            )
          ),

        ],
      )
    );
  }

  Widget _buildInfoRowWithBorder({
    required String label,
    required String value,
    required bool mainColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: mainColor ? '*' : '',
                  style: TextStyle(
                    color: const Color(0xffE39D10), // 蓝色星号
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: const Color(0xff999999),
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: mainColor ? const Color(theme01MainColor) : Colors.black,
              fontSize: 38.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      )
    );
  }

  Widget _buildButtonArea() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120.h,
            margin: EdgeInsets.only(left: 50.w, right: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: Colors.white,
              border: Border.all(
                color: const Color(theme01MainColor),
                width: 1.0,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                AppManager.instance.tapVibrate();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.r),
                ),
              ),
              child: Text(
                "取消",
                style: TextStyle(
                  fontSize: 48.sp,
                  color: const Color(theme01MainColor),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Container(
            height: 120.h,
            margin: EdgeInsets.only(left: 10.w, right: 50.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: const LinearGradient(
                colors: [Color(theme01MainColor), Color(theme01MainColor)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(theme01MainColor).withOpacity(0.5),
                  offset: Offset(0, 6.w),
                  blurRadius: 10.w,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                AppManager.instance.tapVibrate();
                Get.back();
                widget.onPress!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.r),
                ),
              ),
              child: Text(
                "确认",
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
    );
  }

}
