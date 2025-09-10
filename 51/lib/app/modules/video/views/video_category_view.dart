import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/common_color.dart';
import '../controllers/video_category_controller.dart';
import '../widget/video_category_detail_list_widget.dart';

class VideoCategoryView extends GetView<VideoCategoryController> {
  const VideoCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("${controller.title}"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() => (controller.categoryList.isNotEmpty
        ? VideoCategoryDetailListWidget(
            // key: controller.homeListKeys[index],
            data: controller.categoryList,
          )
        : SizedBox()));
  }
}
