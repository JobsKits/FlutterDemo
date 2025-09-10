import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/model/notifis/feedback.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';



class DetailImageBrowsing extends StatelessWidget {
  DetailImageBrowsing({super.key, required this.images, required this.dIndex});

  final List<dynamic>images;
  final int dIndex;

  @override
  Widget build(BuildContext context) {

    // return Image.network(images[dIndex]);

    return CustomNetWorkImage(
      imageUrl: images[dIndex],
      width: Get.width - AppValues.defaultMargin * 2,
      fit: BoxFit.contain,
    );
  }
}

const kCustomDetailImageBrowsingWidget = 'DetailImageBrowsing';

Future<void> showCustomDetailImageBrowsing({
  required BuildContext context,
  required List<dynamic> images,
  required int dIndex,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show(
      context: context,
      tag: kCustomDetailImageBrowsingWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
          child:  DetailImageBrowsing(images: images, dIndex: dIndex),
        ).onTap(() {
          RouteUtil.popView();
        });
      });
}