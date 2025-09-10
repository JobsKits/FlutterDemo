import 'package:flutter/material.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/image_name.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import '../../../../../widget/network_image/custom_network_image_placeholder.dart';
import 'index.dart';

class CommunityPage extends GetView<CommunityController> {
  const CommunityPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Obx(() => controller.loading.value ? SizedBox(
        height: 150,
        child: CustomNetWorkImagePlaceholder(
          color: AppThemes.surfaceVariant.withOpacity(0),
          placeholderType: NetWorkImagePlaceholderType.loading,
      )) : Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: ThemeService().colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.brandDetail.keys.map((index) => _communityItem(
            name: index,
            imageName: index,
            dic: controller.brandDetail[index]
          )).toList(),
        ),
      )),
    );
  }

  Widget _communityItem({
    String name = '',
    String imageName = 'facebook',
    Map? dic,
  }){
    return dic!['state'] ? Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.margin_12),
        color: const Color(0xff0D1D29),
        height: 38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomAssetIcon(
                  name: ImageAssets.aboutUs(imageName),
                  size: 16,
                ),
                const SizedBox(width: 4),
                CustomText(name),
              ],
            ),
            GestureDetector(
              onTap:() => controller.onTap(controller.brandDetail[name]),
              child: CustomAssetIcon(
                name: ImageAssets.aboutUs('push'),
                size: 16,
              ),
            )
          ],
        ),
      ),
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      init: CommunityController(),
      id: "community",
      builder: (_) {
        return Scaffold(
          body: _buildView(),
        );
      },
    );
  }
}
