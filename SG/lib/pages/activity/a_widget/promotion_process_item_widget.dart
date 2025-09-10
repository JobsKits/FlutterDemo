import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';

import '../../../constant/app_common.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../a_model/promotion_process_item_model.dart';

///推广界面 开宝箱流程 格子 item
class PromotionProcessItemWidget extends StatelessWidget {
  const PromotionProcessItemWidget({super.key, required this.index, required this.model});

  final int index;
  final PromotionProcessItemModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 第一行
          // _buildArrowIcon(ProcessRotate.rotate_180),
          SizedBox(height: AppValues.defaultPadding),
          //第二行
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // _buildArrowIcon(ProcessRotate.rotate_180),
              // SizedBox(width: AppValues.defaultPadding),
              _buildCenterIcon(
                  "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg"),

              SizedBox(width: AppValues.defaultPadding),
              Visibility(
                visible: !_countIndexRowEnd(index),
                child: _buildArrowIcon(ProcessRotate.rotate_0),
              ),
            ],
          ),
          SizedBox(height: AppValues.padding_2),
          CustomText(
            "9999.00",
            style: ThemeService()
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppValues.padding_10),
          _buildArrowIcon(ProcessRotate.rotate_90),
          //第三行
        ],
      ),
    );
  }

  ///是否是位数
  bool _countIndexRowEnd(int index) {
    return index % 4 == 3;
  }

  Widget _buildArrowIcon(ProcessRotate rotate) {
    return Transform.rotate(
      //旋转90度
      angle: rotate.value,
      child: const CustomAssetIcon(
        size: 14,
        name: 'assets/images/common/ic_common_arrow_right.webp',
      ),
    );
  }

  Widget _buildCenterIcon(String imgUrl) {
    return CustomNetWorkImage(
      width: 54,
      height: 54,
      showErrorMsg: false,
      imageUrl: imgUrl,
    );
  }
}
