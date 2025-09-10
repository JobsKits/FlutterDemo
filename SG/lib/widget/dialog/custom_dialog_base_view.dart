import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/app_themes.dart';
import '../../constant/app_values.dart';
import '../../services/theme/theme_service.dart';
import '../../utils/route_util.dart';
import '../custom_icon.dart';
import '../custom_text.dart';
import '../refresh/widget/cupertino/easy_refresh_path.dart';
import 'custom_safe_dialog.dart';

///弹性对话框 基本框架
class CustomDialogBaseView extends StatefulWidget {
  CustomDialogBaseView({super.key, this.dialogMaxHeight, this.resizeToAvoidBottomInset = false});

  final double? dialogMaxHeight;
  final bool? resizeToAvoidBottomInset;

  List<Widget> get contentView => buildContentView();

  set contentView(List<Widget> content) {
    _logContentViewSetter();
  }

  String get titleAsset => buildTitleAsset();

  String get titleLabel => buildTitleLabel();

  /// 动作状态
  bool onBackAction = false;
  bool onCloseAction = false;

  ///点击方法
  void onBackDialog() {}

  ///点击方法
  void onCloseDialog() {
    RouteUtil.popView();
  }

  ///生命周期方法，对话框销毁。最后调用
  void onDeleteDialog() {}

  String buildTitleAsset() {
    return "";
  }

  String buildTitleLabel() {
    return "";
  }

  void _logContentViewSetter() {
    final StackTrace stackTrace = StackTrace.current;
    log('ContentView was set', stackTrace: stackTrace);
  }

  List<Widget> buildContentView() {
    return <Widget>[];
  }

  ///静态方法，打开方法, 显示窗口
  static Future<void> showDetailDialog<T>({
    required BuildContext context,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
    // required BettingRecordApiModel recordModel,
    // required CasinoGameTypeEnum gameType,
    required CustomDialogBaseView dialogView,
  }) async {
    await CustomSafeDialog.show<T>(
        context: context,
        // tag: kCasinoDetailWidget,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return dialogView;
        }).then((value) {
      //关闭回调
      log("CustomDialogBaseView 关闭回调");
      dialogView.onDeleteDialog();
    });
  }

  @override
  State<CustomDialogBaseView> createState() => _CustomDialogBaseViewState();
}

class _CustomDialogBaseViewState extends State<CustomDialogBaseView> {
  double _dialogMaxHeight = Get.height - 100;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.dialogMaxHeight != null) {
      _dialogMaxHeight = widget.dialogMaxHeight!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在widget初始化之后访问GlobalKey.currentState
      // do something
      // getWidgetOffset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              body: GestureDetector(
                onTap: () {
                  if (WidgetsBinding.instance.window.viewInsets.bottom > 0) {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  }
                },
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: _dialogMaxHeight,
                    margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: ThemeService().colorScheme.background,
                        ),
                        child: Scrollbar(
                            controller: _scrollController,
                            child: SingleChildScrollView(
                                controller: _scrollController,
                                padding: EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    const SizedBox(height: AppValues.margin_2),
                                    //表头
                                    _buildTopTitleView(),
                                    //正文
                                    _buildContentDetailView(),
                                  ],
                                ))),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  _buildTopTitleView() {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Visibility(
            visible: widget.titleAsset.isNotEmpty,
            child: InkWell(
              onTap: () {
                widget.onBackDialog();
              },
              child: Padding(
                padding: EdgeInsets.zero,
                child: CustomIcon(
                  color: AppThemes.iconColor,
                  // asset: "assets/images/bet_slip/ic_casino_bet_order.webp",
                  asset: widget.titleAsset,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          CustomText(
            // S.current.tab_bar_order,
            widget.titleLabel,
            style: ThemeService()
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              widget.onCloseDialog();
            },
            child: const Padding(
              padding: EdgeInsets.all(AppValues.defaultPadding),
              child: CustomIcon(
                asset: 'assets/images/normal/ic_normal_close.png',
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildContentDetailView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.contentView,
    );
  }
}
