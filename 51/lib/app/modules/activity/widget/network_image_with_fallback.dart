import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final String fallbackAsset;
  final BoxFit? fit;
  final bool? isIcon;

  const NetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    required this.fallbackAsset,
    this.fit,
    this.isIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == '') {
      return Image.asset(
        fallbackAsset,
        height: 300.h,
      );
    }
    return FutureBuilder(
      future: _checkNetworkImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // 网络图片加载失败，显示本地图片
          if (isIcon == true) {
            return Icon(
              Icons.image_search,
              size: 180.w,
              color: context.theme.primaryColor,
            );
          }
          return Image.asset(fallbackAsset, fit: fit);
        } else {
          // 网络图片加载成功
          return CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: fit,
                  image: imageProvider,
                ),
              ),
            ),
          );
          // return Image.network(imageUrl, fit: fit);
        }
      },
    );
  }

  Future<void> _checkNetworkImage(String url) async {
    final response = await Dio().get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    }
  }
}
