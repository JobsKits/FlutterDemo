import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';

import '../../constant/app_themes.dart';
import '../network_image/custom_network_image_placeholder.dart';

///三个球 加载动画
class CustomLoadLoadingView extends StatelessWidget {
  const CustomLoadLoadingView({super.key, this.height, this.padding, this.margin});

  final double? height;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 180,
      padding: padding,
      margin: margin,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
        // borderRadius: borderRadius,
        // border: border,
      ),
    );
  }
}
