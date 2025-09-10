import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'dart:math' as math;

import '../../../constant/app_common.dart';
import '../../../widget/custom_icon.dart';
import '../wmodel/alliance_common_params.dart';

class CustomAllianceProcessLineWidget extends StatelessWidget {
  const CustomAllianceProcessLineWidget({
    super.key,
    this.lineType,
    this.rotate = ProcessRotate.rotate_0,
  });

  final ProcessLine? lineType; //流程线类型
  final ProcessRotate rotate; //旋转角度

  @override
  Widget build(BuildContext context) {
    // return lineType == ProcessLine.arrow ? _buildArrow() : _buildLine();
    // return _buildArrowLeft();
    return LayoutBuilder(
      builder: (_, constraints) {
        // log("开发日志：流程线...constraints...$constraints");
        return _buildSwitchView();
      },
    );
  }

  _buildSwitchView() {
    switch (lineType) {
      case ProcessLine.arrow:
        return _buildArrow();
      case ProcessLine.arrowLeft:
        return _buildArrowLeft();
      case ProcessLine.arrowRight:
        return _buildArrowRight();
      case ProcessLine.line:
        return _buildLine();
      default:
        return Container();
    }
  }

  _buildArrow() {
    return Container(
      height: 24,
      // width: 10,
      child: const CustomAssetIcon(
        name: "assets/images/alliance/ic_alliance_process_arrow.webp",
        // asset: "assets/images/alliance/ic_alliance_process_arrow.webp",
        color: Color(0xFFFF9D00),
        size: 22,
        boxFit: BoxFit.contain,
      ),
    );
    return Transform.rotate(
      //旋转90度
      angle: rotate.value,
      child: const CustomIcon(
        asset: "assets/images/alliance/ic_alliance_process_arrow.webp",
        color: Color(0xFFFF9D00),
        // size: 30,
      ),
    );
  }

  _buildArrowLeft() {
    return Column(
      // alignment: Alignment.topLeft,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  CustomAssetIcon(
        //   // asset: "assets/images/alliance/ic_alliance_process_arrow_right.webp",
        //    name: "assets/images/alliance/ic_alliance_process_arrow_right.webp",
        //   color: Color(0xFFFF9D00),
        //   size: 20,
        // ),
        Transform.translate(
            offset: Offset(0, 5),
            child: Image.asset("assets/images/alliance/ic_alliance_process_arrow_right.webp",
                width: 22)),
        Container(
          width: 2,
          height: 70,
          color: Color(0xFFFF9D00),
        ),
      ],
    );
  }

  _buildArrowRight() {
    return Column(
      // alignment: Alignment.topLeft,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //  CustomAssetIcon(
        //   // asset: "assets/images/alliance/ic_alliance_process_arrow_right.webp",
        //    name: "assets/images/alliance/ic_alliance_process_arrow_right.webp",
        //   color: Color(0xFFFF9D00),
        //   size: 20,
        // ),
        Transform.translate(
            offset: Offset(0, 5),
            child: Image.asset("assets/images/alliance/ic_alliance_process_arrow_left.webp",
                width: 22)),
        Container(
          width: 2,
          height: 70,
          color: Color(0xFFFF9D00),
        ),
      ],
    );
  }

  _buildLine() {
    return Transform.rotate(
      //旋转90度
      angle: rotate.value,
      child: Container(
        width: 2,
        height: 24,
        color: Color(0xFFFF9D00),
      ),
    );
  }
}
