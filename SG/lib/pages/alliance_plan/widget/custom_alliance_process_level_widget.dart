import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../wmodel/alliance_common_params.dart';
import 'custom_alliance_process_widget.dart';

///联盟计划- 推广教程-流程等级level view
class CustomAllianceProcessLevelGridWidget extends StatelessWidget {
  CustomAllianceProcessLevelGridWidget({
    super.key,
    required this.level,
    required this.itemCount,
    required this.contentBuilder,
    this.width,
    this.height,
  });

  ProcessLevel level;
  int itemCount;
  Widget? Function(BuildContext context) contentBuilder;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // color: Colors.yellow,
      // color: ThemeService().theme.scaffoldBackgroundColor,
      // color: ThemeService().colorScheme.surface, // 设置背景色
      constraints: BoxConstraints(
        minWidth: 50,
        minHeight: 50,
        maxWidth: width ?? double.infinity,
        maxHeight: height ?? double.infinity,
      ),
      child: GridView.builder(
        itemCount: itemCount,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // maxCrossAxisExtent: 200,
          childAspectRatio: 0.60,
          // mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return ProcessLevelWidget(
            level: level,
            index: index + 1,
            topProcess: ProcessLine.line,
            bottomProcess: ProcessLine.arrow,
            content: (BuildContext context) {
              return contentBuilder(context);
            },
          );
        },
      ),
    );
  }
}

class ProcessLevelWidget extends StatelessWidget {
  ProcessLevel level;
  int? index;
  Widget? Function(BuildContext context) content;

  ProcessLine? leftProcess;
  ProcessLine? rightProcess;
  ProcessLine? topProcess;
  ProcessLine? bottomProcess;

  ProcessLevelWidget({
    super.key,
    required this.level,
    required this.index,
    required this.content,
    this.leftProcess,
    this.rightProcess,
    this.topProcess,
    this.bottomProcess,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      // log("开发日志：ProcessLevelWidget...constraints...$constraints");
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
              visible: leftProcess != null,
              child: CustomAllianceProcessLineWidget(lineType: ProcessLine.arrowLeft)),
          Column(
            children: [
              Visibility(
                  visible: topProcess != null,
                  child: CustomAllianceProcessLineWidget(lineType: ProcessLine.line)),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  _buildContentView(context),
                  _buildRoundLevelView(),
                ],
              ),
              Visibility(
                  visible: bottomProcess != null,
                  child: CustomAllianceProcessLineWidget(lineType: ProcessLine.arrow)),
            ],
          ),
          Visibility(
              visible: rightProcess != null,
              child: CustomAllianceProcessLineWidget(lineType: ProcessLine.arrowRight)),
        ],
      );
    });
  }

  ///绘制圆形 等级level 圆形view
  _buildRoundLevelView() {
    return Container(
      alignment: Alignment.center,
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        // color: Colors.red,
        color: ThemeService().colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(45)),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.topCenter,
            child: CustomText("${level.getLevelName()}${index ?? ''}",
                style: ThemeService()
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20, color: level.color)),
          ),
          Column(
            children: const [
              SizedBox(height: 4.5),
              CustomAssetIcon(
                name: "assets/images/alliance/ic_alliance_process_level.webp",
                size: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///绘制圆形 等级level 内容view
  _buildContentView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 22.5),
      // width: 200,
      // height: 200,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 24, bottom: 10),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: content(context) ?? Container(),
    );
  }
}
