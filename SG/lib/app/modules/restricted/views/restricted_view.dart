import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';

import 'package:get/get.dart';

import '../controllers/restricted_controller.dart';

class RestrictedView extends GetView<RestrictedController> {
  const RestrictedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Center(
          child: Obx(() => SizedBox(
            width: 263,
            height: 531,
            child: CustomNetWorkImage(
              imageUrl:
              '${AppUrlsValues.envConfig.asset_url}/${controller.brandDetailUrl}',
              errorWidget: Container(),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          )),
        ),
      ]),
    );
  }
}
