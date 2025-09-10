import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../../activity/widget/common_receive_button.dart';
import '../../controllers/agent_center_share_controller.dart';

class AgentCenterQrView extends StatefulWidget {
  const AgentCenterQrView({super.key});

  @override
  State<AgentCenterQrView> createState() => _AgentCenterQrViewState();
}

class _AgentCenterQrViewState extends State<AgentCenterQrView> {
  AgentCenterShareController controller = Get.find();
  GlobalKey globalKey = GlobalKey();
  bool isSaveLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80.r),
        color: context.customTheme?.dialogXColor,
      ),
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 70.w),
          child: Column(
            children: [
              Text(
                '我的推广链接',
                style: TextStyle(
                  fontSize: 54.sp,
                  color: context.customTheme?.titleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.h),
              RepaintBoundary(
                key: globalKey,
                child: _buildQrCodeImageWigdet(controller.promotionUrl.value),
              ),
              SizedBox(height: 20.h),
              _buildQrcodeTextWidget(context, controller.promotionUrl.value),
              SizedBox(height: 60.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOutlineBtn(
                    text: '保存二维码',
                    onPressed: () {
                      AppManager.instance.tapVibrate();
                      DebounceThrottle.debounce(_saveQrcode)();
                    },
                  ),
                  _buildOutlineBtn(
                    text: '复制链接',
                    onPressed: () {
                      AppManager.instance.tapVibrate();
                      ClipboardUtil.copy(controller.promotionUrl.value);
                    },
                  ),
                ],
              ),
              SizedBox(height: 60.h),
              CommonReceiveButton(
                title: '一键分享',
                height: 120,
                borderRadius: 40,
                onTap: () {
                  Share.share(
                    controller.promotionUrl.value,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 60.h),
        Divider(
          height: 1.h,
          color: const Color(colorEAEAEA),
        ),
        SizedBox(height: 60.h),
        _buildCopyCodeWidget(context),
      ],
    );
  }

  Widget _buildQrcodeTextWidget(BuildContext context, String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: context.customTheme?.lineColor ?? Colors.white, width: 2.w),
        gradient: LinearGradient(
          colors: [
            context.customTheme?.dialogBgColor ?? Colors.white, // 起始颜色
            context.customTheme?.dialogBgColor ?? Colors.white, // 起始颜色
            // context.theme.primaryColor.withOpacity(0.1), // 结束颜色
          ],
          begin: Alignment.topCenter, // 渐变的起始位置
          end: Alignment.bottomCenter, // 渐变的结束位置
          stops: const [0.2, 0.8], // 调整渐变范围，使上方颜色更集中
        ),
      ),
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Center(
        child: Text(
          url,
          style: TextStyle(
            fontSize: 39.sp,
            color: context.customTheme?.titleColor,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildQrCodeImageWigdet(String url) {
    return QrImageView(
      data: url,
      size: 350.w,
      gapless: false,
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(30.w),
      errorStateBuilder: (cxt, err) {
        return const Center(
          child: Text(
            'Uh oh! Something went wrong...',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildOutlineBtn({
    required String text,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 410.w,
      height: 98.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: context.theme.primaryColor,
            width: 2.w,
          ), // 设置边框颜色和宽度
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // 设置圆角
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: context.theme.primaryColor,
            fontSize: 39.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyCodeWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: '我的邀请码：',
              style: TextStyle(
                fontSize: 48.sp,
                color: context.customTheme?.titleColor,
              ),
              children: [
                TextSpan(
                  text: controller.promotionCode.value,
                  style: TextStyle(
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(colorE44140),
                  ),
                ),
              ],
            ),
          ),
          CommonReceiveButton(
            title: '复制',
            height: 68,
            borderRadius: 34,
            fontSize: 36,
            onTap: () {
              ClipboardUtil.copy(controller.promotionCode.value);
            },
          ),
        ],
      ),
    );
  }

  // 保存图片
  _doImageSave() async {
    if (isSaveLoading) {
      return;
    }

    setState(() => isSaveLoading = true);

    try {
      // 生成二维码并保存
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 保存到相册
      await ImageGallerySaverPlus.saveImage(pngBytes,
          quality: 100, name: "分享二维码");
    } catch (e) {
      throw Exception('Failed to save image: ${e}');
    } finally {
      setState(() => isSaveLoading = false);
      EasyLoading.showSuccess('保存成功');
    }
  }

  // 保存二维码到相册
  _saveQrcode() async {
    // 请求存储权限
    if (Platform.isAndroid) {
      //如果是安卓平台
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int sdkInt = androidInfo.version.sdkInt;
      if (sdkInt >= 29) {
        //如果版本高于29，直接使用插件就可以保存图片
        _doImageSave();
      } else {
        //版本低于29，需要请求权限
        var status = await Permission.storage.request();
        if (status.isGranted) {
          _doImageSave();
        } else {
          _showPermissionDialog();
        }
      }
    } else {
      //这里处理IOS或者其他平台的保存逻辑

      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      String version = iosInfo.systemVersion;

      // iOS 10 及以上：确保您添加了正确的权限描述。
      // iOS 14 及以上：需要动态请求权限。
      if (double.parse(version) >= 14) {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          _doImageSave();
        } else {
          _showPermissionDialog();
        }
      } else {
        _doImageSave();
      }
    }
  }

  _showPermissionDialog() {
    Get.defaultDialog(
      title: '权限请求',
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 52.sp),
      content: Column(
        children: [
          SizedBox(height: 20.h),
          Center(
            child: Text(
              '请手动前往设置中开启存储权限，以便保存二维码到相册。',
              style: TextStyle(
                fontSize: 46.sp,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
      radius: 40.r,
      contentPadding: EdgeInsets.fromLTRB(40.w, 60.h, 40.w, 40.h),
      confirm: SizedBox(
        width: 315.w,
        height: 105.h,
        child: ElevatedButton(
            onPressed: () {
              AppManager.instance.tapVibrate();
              openAppSettings(); // 打开应用设置
              Get.back(); // 关闭对话框
            },
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                context.theme.primaryColor,
              ),
            ),
            child: const Text(
              '确定',
              style: TextStyle(color: Color(colorFFFFFF)),
            )),
      ),
      cancel: SizedBox(
        width: 315.w,
        height: 105.h,
        child: OutlinedButton(
          onPressed: () {
            AppManager.instance.tapVibrate();
            Get.back(); // 关闭对话框
          },
          style: ButtonStyle(
            side: const WidgetStatePropertyAll(
              BorderSide(color: Color(colorEEEEEE)),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
          child: const Text(
            '取消',
            style: TextStyle(color: Color(colorAAAAAA)),
          ),
        ),
      ),
    );
  }
}
