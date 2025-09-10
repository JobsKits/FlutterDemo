import 'package:flutter/material.dart';

// 虚实体
class AgentCenterTabBean {
  AgentCenterTabBean({
    required this.child,
    required this.title,
    required this.show,
  });

  final String title;
  final Widget child;
  final bool show;
}
