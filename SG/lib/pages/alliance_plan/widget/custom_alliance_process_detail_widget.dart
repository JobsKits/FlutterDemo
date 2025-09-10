import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


///联盟计划- 推广教程-流程二级 明细 view
class CustomAllianceProcessDetailGridWidget extends StatelessWidget {
  int itemCount;
  Widget? Function(BuildContext context, int index) contentBuilder;
  double? width;
  double? height;
  final double maxHeight = Get.height;

  CustomAllianceProcessDetailGridWidget({
    super.key,
    required this.itemCount,
    required this.contentBuilder,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // log("推广教程-流程二级...$constraints");
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          minHeight: 50,
          maxWidth: width ?? constraints.maxWidth,
          maxHeight: height ?? constraints.maxHeight,
        ),
        child: GridView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          // scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            // return Column(
            //   mainAxisSize: MainAxisSize.min,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Expanded(
            //       child: CustomAllianceProcessLineWidget(lineType: ProcessLine.arrow),
            //     ),
            //     _DetailWidget(
            //       contentBuild: (BuildContext context) {
            //         return contentBuilder(context, index);
            //       },
            //     ),
            //     Expanded(
            //       child: CustomAllianceProcessLineWidget(lineType: ProcessLine.line),
            //     ),
            //   ],
            // );
            return _DetailWidget(
              contentBuild: (BuildContext context) {
                return contentBuilder(context, index);
              },
            );
          },
        ),
      );
    });
  }
}

class _DetailWidget extends StatelessWidget {
  Widget? Function(BuildContext context) contentBuild;

  _DetailWidget({
    super.key,
    required this.contentBuild,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFF213743),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: Color(0xFFFF9D00)),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: contentBuild(context) ?? Container(),
        ),
      ],
    );
  }
}
