import 'package:flutter/material.dart';

//对组件进行保活的Widget，需要保活保存状态的组件，用此组件包裹
class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper(
      {super.key, required this.child, this.keepAlive = true});
  final Widget child;
  final bool keepAlive;
  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWarapperState();
}

class _KeepAliveWarapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }
}
