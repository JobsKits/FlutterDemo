import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/dialog/dialog_utils.dart';

///导航栏搜索View
class SearchTitleView extends GetView<HomeLogic> {
  Color lineColor = ThemeService().theme.colorScheme.tertiary;
  final GlobalKey _widgetKey = GlobalKey();
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  ///文本框监听
  final ParamSingleCallback<String>? onChanged;

  ///输入框文本控制器
  late final TextEditingController? textController;

  ///清空内容
  final ParamVoidCallback? onClean;

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey = GlobalKey<ScalingTextState>();

  SearchTitleView({
    this.onChanged,
    this.textController,
    this.onClean,
    Key? key,
  }) : super(key: key) {
    textController ??= TextEditingController(text: '');
  }

  void _startAnimation() {
    _rotatingArrowKey.currentState?.startAnimation();
  }

  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_12),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(width: 2.0, color: lineColor)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Visibility(
                  visible: !globalController.showMenuImage.value, child: _chooseClassView(context)),
              Visibility(visible: !globalController.showMenuImage.value, child: _buildLine()),
              _buildSearchView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewBubbleChild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () {
            Get.back();
            print('切换为娱乐城');
            controller.changePlay(0);
          },
          child: Text(
            S.current.tab_bar_ent,
            style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                  color: globalController.menuSelectType.value == 0
                      ? /*AppThemes.secondaryColor*/ ThemeService().colorScheme.tertiary
                      : ThemeService().colorScheme.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () {
            Get.back();
            print('切换为体育');
            controller.changePlay(1);
          },
          child: Text(
            S.current.tab_bar_sports,
            style: TextStyle(
                color: globalController.menuSelectType.value == 1
                    ? /*AppThemes.secondaryColor*/ ThemeService().colorScheme.tertiary
                    : ThemeService().colorScheme.tertiary,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ),
        // SizedBox(
        //   height: 10,
        // ),
      ],
    );
  }

  Widget _chooseClassView(BuildContext context) {
    return InkWell(
        key: _widgetKey,
        onTap: () {
          controller.state.scale.value = 0.9;
          Future.delayed(const Duration(milliseconds: 100), () {
            controller.state.scale.value = 1.0;
          });
          _startAnimation();
          _startScaleAnimation(_scalingKey);

          ///弹窗选择娱乐城和体育
          DialogUtils.showCustomBubbleDialog(context, _viewBubbleChild(), 78,
              widgetKey: _widgetKey,
              height: 100,
              dyHeight: 15,
              globalKey: _rotatingArrowKey,
              globalKeyScaling: _scalingKey, onDismissCallback: () {
            controller.state.scale.value = 0.9;
            Future.delayed(const Duration(milliseconds: 100), () {
              controller.state.scale.value = 1.0;
            });
          } /*backgroundColor: ThemeService().colorScheme.tertiary*/
              );
        },
        child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.bounceIn, // 使用弹性曲线
              transform: Matrix4.identity()..scale(controller.state.scale.value),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Obx(() {
                    return ScalingText(
                      key: _scalingKey,
                      text: controller.state.selectedMap[globalController.menuSelectType.value]!,
                      textStyle: ThemeService().theme.textTheme.bodyMedium!,
                    );
                  }),
                  const SizedBox(width: 4),
                  RotatingArrow(
                    key: _rotatingArrowKey,
                    activeColor: const Color(0xffa6b2cb),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            )));
  }

  Widget _buildLine() {
    return Container(
      width: 2,
      height: double.infinity,
      color: lineColor,
    );
  }

  Widget _buildSearchView(BuildContext context) {
    // return _buildSearchOldView();
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            margin: const EdgeInsets.only(left: AppValues.extraSmallMargin),
            // child: const CustomAssetIcon(
            //   name: 'assets/images/search_icon.png',
            //   size: 22,
            // ),
          ),
          Container(
              height: 38,
              child: Obx(() => CupertinoSearchTextField(
                    prefixIcon: SvgPicture.asset("assets/svg/icon_search.svg"),
                    placeholder: globalController.menuSelectType.value == 0
                        ? S.current.search_game
                        : S.current.random_text_500,
                    placeholderStyle: const TextStyle(
                        color: Color(0xFF566771), fontSize: 14, fontWeight: FontWeight.w400),
                    padding: const EdgeInsetsDirectional.fromSTEB(5.5, 8, 30.5, 8),
                    suffixMode: OverlayVisibilityMode.never,
                    suffixIcon: const Icon(Icons.close, color: Color(0xFFB1BAD3), size: 18),
                    decoration: BoxDecoration(
                      // color: ThemeService().colorScheme.surface,
                      // border: Border.all(color: const Color(0xFF040607), width: 1.0),
                      // Add a border
                      borderRadius: BorderRadius.circular(4), // Set border radius to 0
                    ),
                    // decoration: InputDecoration(
                    //     fillColor: AppThemes.widgetColorWhite,
                    //     hintText: S.current.search_game,
                    //     hintStyle: const TextStyle(color: AppThemes.secondaryIconColor, fontSize: 14),
                    //     border: _getEditBorder(),
                    //     focusedBorder: _getEditBorder(),
                    //     disabledBorder: _getEditBorder(),
                    //     enabledBorder: _getEditBorder(),
                    //     contentPadding: const EdgeInsets.only(left: 30, right: 30, top: 6, bottom: 6)),

                    style: ThemeService().textTheme.bodyMedium!.copyWith(color: Colors.white),

                    onChanged: onChanged,
                    controller: textController,
                    onSubmitted: (String value) {
                      log('Submitted text: $value');
                    },
                    focusNode: controller.focusNode,
                    // textAlign: TextAlign.left,
                    autofocus: false,
                    // maxLines: 1,
                    // style: ThemeService().theme.textTheme.bodyMedium,
                  ))),
          Positioned(
              right: 5,
              child: Obx(() {
                return Visibility(
                  visible: controller.state.showInfoType.value == 1,
                  child: InkWell(
                    onTap: onClean,
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFB1BAD3),
                      size: 18,
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }

  ///旧代码
  _buildSearchOldView() {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            margin: const EdgeInsets.only(left: AppValues.extraSmallMargin),
            child: const CustomAssetIcon(
              name: 'assets/images/search_icon.png',
              size: 22,
            ),
          ),
          Container(
            height: 36,
            child: TextField(
              focusNode: controller.focusNode,
              textAlign: TextAlign.left,
              autofocus: false,
              maxLines: 1,
              style: ThemeService().theme.textTheme.bodyMedium,
              onChanged: onChanged,
              controller: textController,
              decoration: InputDecoration(
                  fillColor: AppThemes.widgetColorWhite,
                  hintText: S.current.search_game,
                  hintStyle: const TextStyle(color: AppThemes.secondaryIconColor, fontSize: 14),
                  border: _getEditBorder(),
                  focusedBorder: _getEditBorder(),
                  disabledBorder: _getEditBorder(),
                  enabledBorder: _getEditBorder(),
                  contentPadding: const EdgeInsets.only(left: 30, right: 30, top: 6, bottom: 6)),
            ),
          ),
          Positioned(
              right: 2,
              child: Obx(() {
                return Visibility(
                  visible: controller.state.searchContent.value.isNotEmpty ||
                      controller.state.showInfoType.value == 1,
                  child: InkWell(
                    onTap: onClean,
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: AppThemes.widgetColorWhite,
                      size: 18,
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }

  ///获取输入框的Border属性，可公用
  ///[isEdit]是否获取焦点
  OutlineInputBorder _getEditBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }
}
