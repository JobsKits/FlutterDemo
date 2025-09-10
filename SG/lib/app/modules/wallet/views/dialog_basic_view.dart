import 'package:flutter/material.dart';

import '../../../../services/theme/theme_service.dart';

class BasicView extends StatelessWidget {
  final Widget contentView;

  const BasicView({super.key, required this.contentView});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              color: ThemeService().colorScheme.background,
            ),
            child: contentView));
  }
}
