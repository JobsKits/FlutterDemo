import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_page_bottom_bar_widget.dart';

class MainPageBottomBarController  {
  ValueChanged<int>? selectedMenuTap;
  void selectedAtIndex(int code) {
    selectedMenuTap!(code);
  }
}

class GlobalKeyController extends GetxController {
  final GlobalKey<MainPageBottomBarWidgetState> mainPageKey = GlobalKey<MainPageBottomBarWidgetState>();
}