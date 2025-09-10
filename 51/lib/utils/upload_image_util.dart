// import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'dart:io';

import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/data/upload_image_bean.dart';

typedef StringCallback = void Function(String str);

/// 上传图片工具
class UploadImageUtil {
  /// 静态变量保存域名
  static List<UploadImageUrlItem>? _urlList;

  /// 清除上传的图片 URL
  static void clearUploadedImageUrl() {
    _urlList = null;
  }

  /// 检查图片是否符合格式
  static Future<bool> _beforeUploadCheckImage(XFile image) async {
    File imageFile = File(image.path);
    // 检查图片格式
    String fileExtension = imageFile.path.split('.').last.toLowerCase();
    // 检查图片大小
    int fileSize = await imageFile.length(); // 文件大小以字节为单位

    // 不支持的格式 （mp4暂时不考虑， 目前未涉及到改格式文件）
    if (!['png', 'jpg', 'jpeg', 'webp'].contains(fileExtension)) {
      EasyLoading.showToast('请重新选择图片，支持png、jpg、webp格式');
      return false;
    }

    // 设置最大文件大小（例如：10MB）
    const int maxSizeInBytes = 10 * 1024 * 1024;
    if (fileSize > maxSizeInBytes) {
      EasyLoading.showToast('请选择10M以下的图片');
      return false;
    }

    return true;
  }

  /// 根据图片大小设置压缩比例
  static double _getCompressRatio(int size) {
    if (size > 8 * 1024 * 1024) {
      // 8-10M
      return 1 / 18;
    } else if (size > 6 * 1024 * 1024) {
      // 6-8M
      return 1 / 16;
    } else if (size > 4 * 1024 * 1024) {
      // 4-6M
      return 1 / 14;
    } else if (size > 2 * 1024 * 1024) {
      // 2-4M
      return 1 / 12;
    } else if (size > 1 * 1024 * 1024) {
      // 1-2M
      return 1 / 4;
    } else if (size > 0.5 * 1024 * 1024) {
      // 500kb-1M
      return 1 / 2;
    }
    return 1;
  }

  /// 图片压缩
  static Future<XFile> _toCompressImage(XFile image) async {
    File imageFile = File(image.path);
    // 检查图片大小
    int fileSize = await imageFile.length(); // 文件大小以字节为单位
    double ratio = _getCompressRatio(fileSize);

    if (ratio == 1) {
      return image;
    }

    // 读取图片文件
    var imageBytes = await imageFile.readAsBytes();
    // 解码图片
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage != null) {
      // 获取原始宽度和高度
      int oldWidth = originalImage.width;
      int oldHeight = originalImage.height;

      // 设置缩放比例
      int newWidth = (oldWidth * ratio).round();
      int newHeight = (oldHeight * ratio).round();

      // 按比例缩小图片
      img.Image resizedImage =
          img.copyResize(originalImage, width: newWidth, height: newHeight);

      // 获取文件扩展名
      String extension =
          imageFile.uri.pathSegments.last.split('.').last.toLowerCase();

      // 将缩小后的图片保存到文件
      File resizedFile = File(
          '${imageFile.parent.path}/resized_${imageFile.uri.pathSegments.last}');

      if (['jpeg', 'jpg'].contains(extension)) {
        await resizedFile
            .writeAsBytes(img.encodeJpg(resizedImage, quality: 80));
      } else if (extension == 'png') {
        await resizedFile.writeAsBytes(img.encodePng(resizedImage));
      } else {
        return image;
      }

      return XFile(resizedFile.path);
    }

    return image;
  }

  /// 文件变化
  static onFileChange({
    required XFile image,
    required StringCallback callback,
  }) async {
    try {
      // 判断所选是否能上传
      bool canUpload = await _beforeUploadCheckImage(image);
      if (canUpload) {
        EasyLoading.show(indicator: const CommonLoadingView());
        // 获取压缩后的图片
        XFile newImage = await _toCompressImage(image);

        // 获取域名
        await _reqUploadImageUrlList();
        // 图片上传
        await _doDomainValid(0, image: newImage, callback: callback);
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  // 获取域名地址
  static _reqUploadImageUrlList() async {
    if (_urlList != null) {
      return true;
    }

    final res = await SystemApi.reqUploadImageUrlList();

    if (res.type == NetworkService.networkTypeSuccess) {
      _urlList = UploadImageUrlBean.fromJson(res.data).url;
    }
  }

  /// 获取阿里云oss配置
  static Future<String> _reqAliyunOssConfig(int domainType) async {
    final res = await SystemApi.reqAliyunOssConfig(domainType);

    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data == null) {
        return '';
      }
      return AliyunOssConfigBean.fromJson(res.data).value ?? '';
    }

    return '';
  }

  /// 获取阿里云存储令牌凭证
  static Future<AliyunOssSecretBean?> _reqAliyunOssSecret(
      Map<String, dynamic> parseAliyunOssConfig) async {
    Map<String, dynamic> data = {
      'regionId': parseAliyunOssConfig['regionId'],
      'accessKeyId': parseAliyunOssConfig['accessKeyId'],
      'accessSecret': parseAliyunOssConfig['secretAccessKey'],
      'roleArn': parseAliyunOssConfig['roleArn'],
      'roleSessionName': parseAliyunOssConfig['roleSessionName']
    };

    final res = await SystemApi.reqAliyunOssSecret(data);
    if (res.type == NetworkService.networkTypeSuccess) {
      return AliyunOssSecretBean.fromJson(res.data);
    }
    return null;
  }

  /// 处理线路是否可用的判断
  static _doDomainValid(
    int index, {
    required XFile image,
    required StringCallback callback,
  }) async {
    if (_urlList == null) {
      EasyLoading.showError('线路为空');
      return;
    }

    UploadImageUrlItem urlItem = _urlList![index];

    String domainAddr = urlItem.domain_addr ?? '';
    String callbackAddr = urlItem.callback_addr ?? '';
    int domainType = urlItem.domain_type!;

    // 未找到配置
    if (domainAddr == '') {
      if (index + 1 >= _urlList!.length) {
        EasyLoading.showError('配置错误');
      } else {
        // 检测下一个
        _doDomainValid(index + 1, image: image, callback: callback);
      }
      return;
    }

    // 域名容错
    if (!(domainAddr.contains('http') || domainAddr.contains('https'))) {
      domainAddr = 'https://${domainAddr}';
    }

    int timeStamp = DateTime.now().microsecondsSinceEpoch;
    String fileKey = '${NetworkService().hostName}/${timeStamp}_${image.name}';

    // aliyun oss
    if (domainType == 9) {
      /// 获取aliyun Oss 配置
      String aliyunOssConfig = await _reqAliyunOssConfig(domainType);

      if (aliyunOssConfig == '') {
        // 检测下一个
        _doDomainValid(index + 1, image: image, callback: callback);
        return;
      }
      final parseAliyunOssConfig = GameUtils.parseJson(aliyunOssConfig);

      /// 获取aliyun Oss token
      AliyunOssSecretBean? secret =
          await _reqAliyunOssSecret(parseAliyunOssConfig);

      if (secret == null || secret.tokenSecret! == '') {
        // 检测下一个
        _doDomainValid(index + 1, image: image, callback: callback);
        return;
      }

      Auth authGetter() {
        // 设置过期时间为当前时间加上 1 小时
        final DateTime now = DateTime.now();
        final String expire =
            now.add(const Duration(minutes: 1)).toIso8601String();

        return Auth(
          accessKey: secret.accessKeyId!,
          accessSecret: secret.accessKeySecret!,
          expire: expire,
          secureToken: secret.tokenSecret!,
        );
      }

      // 初始化
      Client.init(
        ossEndpoint: parseAliyunOssConfig['endpoint'],
        bucketName: parseAliyunOssConfig['bucketName'],
        authGetter: authGetter,
      );

      await Client().putObjectFile(image.path, fileKey: fileKey);

      callback('${domainAddr}/${fileKey}');
    } else if (domainType == 10) {
      /// 亚马逊 S3

      /// 获取amazon s3 配置
      String amazonS3Config = await _reqAliyunOssConfig(domainType);

      if (amazonS3Config == '') {
        // 检测下一个
        _doDomainValid(index + 1, image: image, callback: callback);
        return;
      }

      final parseAmazonS3Config = GameUtils.parseJson(amazonS3Config);

      await AwsS3.uploadFile(
        accessKey: parseAmazonS3Config['ak'],
        secretKey: parseAmazonS3Config['sk'],
        file: File(image.path),
        bucket: parseAmazonS3Config['bucketName'],
        region: parseAmazonS3Config['aws_area'],
        destDir: '',
        filename: fileKey,
        // metadata: {"test": "test"},
      );

      callback('${parseAmazonS3Config['url']}/${fileKey}');
    } else {
      if (callbackAddr == '') {
        EasyLoading.showError('配置错误');
        return;
      }
      File file = File(image.path);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: image.name),
      });

      // 使用 Dio 上传文件
      Response response = await Dio().post(callbackAddr, data: formData);
      if (response.statusCode == 200) {
        if (response.data is String) {
          callback(response.data);
        }
      }
    }
  }
}
