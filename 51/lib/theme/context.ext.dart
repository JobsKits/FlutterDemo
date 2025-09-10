import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/theme/theme.custom.dart';

extension BuildContextExt on BuildContext {
  CustomTheme? get customTheme => Theme.of(this).extension<CustomTheme>();
}
