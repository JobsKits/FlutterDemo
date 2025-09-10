import 'package:flutter/material.dart';

///联盟计划 专用， listview + 上下页
class CustomAllianceListPnView extends StatelessWidget {
  final List<Widget> children;

  const CustomAllianceListPnView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}
