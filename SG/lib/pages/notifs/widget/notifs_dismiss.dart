import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/widget/custom_icon.dart';

/// 左滑删除Widget
class NotifsDismissWidget extends StatelessWidget {
  // 内容
  final Widget child;

  // 自定义删除View
  final Widget? customDeleteView;

  // 删除点击回调
  final Function()? callback;

  const NotifsDismissWidget({super.key, required this.child, this.callback, this.customDeleteView});

  @override
  Widget build(BuildContext context) {

    ScrollController scrollController = ScrollController();

    final deleteView = customDeleteView ?? Container(
      color: Colors.red,
      alignment: Alignment.center,
      width: 62,
      height: 64,
      child: const CustomIcon(
        color: Colors.white,
        asset: "assets/images/notice/delete.webp"
        , size: AppValues.iconSize_28
      ),
    );

    final dismissItem = NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          double maxScrollExtent = scrollController.position.maxScrollExtent;
          double halfMaxScrollExtent = maxScrollExtent / 2;
          Future.delayed(Duration.zero,() {
            scrollController.animateTo(
              scrollController.offset >= halfMaxScrollExtent ? maxScrollExtent : 0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
            );
          });
        }
        return true;
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        child: <Widget>[
          child,
          deleteView.onTap(() {
            scrollController.jumpTo(0);
            callback?.call();
          })
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
      ),
    );

    return dismissItem;
  }
}
