import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/common_gradient.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../utils/CommonRipple.dart';

class RechargeInfoQrcodeItem extends StatefulWidget {
  RechargeInfoQrcodeItem({
    super.key,
    required this.usdtType,
    required this.qrCodeAddr,
    required this.payNo,
    this.isChannel = false,
  });

  final String usdtType;
  final String qrCodeAddr;
  final String payNo;
  bool? isChannel;

  @override
  State<RechargeInfoQrcodeItem> createState() => _RechargeInfoQrcodeItem();
}

class _RechargeInfoQrcodeItem extends State<RechargeInfoQrcodeItem> {
  GlobalKey globalKey = GlobalKey();
  bool isSaveLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.isChannel == false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '官方收款钱包地址',
                style: TextStyle(
                  fontSize: 46.sp,
                  color: const Color(color2C2C2C),
                ),
              ),
              Container(
                width: 220.w,
                height: 86.h,
                decoration: BoxDecoration(
                    color: const Color(colorEBEBEB),
                    borderRadius: BorderRadius.circular(43.r)),
                child: Center(
                  child: Text(
                    widget.usdtType,
                    style: TextStyle(
                        fontSize: 46.sp, color: const Color(color424242)),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: RepaintBoundary(
              key: globalKey,
              child: widget.qrCodeAddr != ''
                  ? CachedNetworkImage(
                      imageUrl: widget.qrCodeAddr,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 440.w,
                        height: 440.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildQrCodeImageWigdet(widget.payNo),
                    )
                  : _buildQrCodeImageWigdet(widget.payNo)),
        ),
        SizedBox(height: 20.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
          decoration: BoxDecoration(
            color: const Color(colorF4F4F4),
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Text(widget.payNo),
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonRipple(
              onTap: () => DebounceThrottle.debounce(_saveQrcode)(),
              child: Container(
                width: 450.w,
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: CommonGradient.getButtonLinearGradient(),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: Text(
                    '保存二维码',
                    style: TextStyle(
                        fontSize: 46.sp, color: const Color(colorFFFFFF)),
                  ),
                ),
              ),
            ),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                ClipboardUtil.copy(widget.payNo);
              },
              child: Container(
                width: 450.w,
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: CommonGradient.getButtonLinearGradient(),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: Text(
                    '复制地址',
                    style: TextStyle(
                        fontSize: 46.sp, color: const Color(colorFFFFFF)),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _buildQrCodeImageWigdet(String url) {
    return QrImageView(
      data: url,
      size: 440.w,
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
          quality: 100, name: "官方收款钱包地址");
    } catch (e) {
      throw Exception('Failed to save image: ${e}');
    } finally {
      setState(() => isSaveLoading = false);
      EasyLoading.showSuccess('保存成功');
    }
  }

  // 保存二维码到相册
  _saveQrcode(BuildContext context) async {
    AppManager.instance.tapVibrate();
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
          _showPermissionDialog(context);
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
          _showPermissionDialog(context);
        }
      } else {
        _doImageSave();
      }
    }
  }

  _showPermissionDialog(BuildContext context) {
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
