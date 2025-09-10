import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

class NotifsLoding extends StatelessWidget {
  NotifsLoding({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomNetWorkImagePlaceholder(
      color: Colors.transparent,
      placeholderType: NetWorkImagePlaceholderType.loading,
    ).height(180);
  }

}
