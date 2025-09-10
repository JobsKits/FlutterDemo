import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabbarLogic extends GetxController {
  List<Tab> tabs = [
    Tab(
      text: '首页了开始的',
      icon: Icon(Icons.car_crash),
      iconMargin: EdgeInsets.only(bottom: 5),
    ),
    Tab(
      text: '单项投注',
      icon: Icon(Icons.ballot),
      iconMargin: EdgeInsets.only(bottom: 5),
    ),
    Tab(
      text: '大厅',
      icon: Icon(Icons.media_bluetooth_off),
      iconMargin: EdgeInsets.only(bottom: 5),
    ),
    Tab(
      text: '复式投注',
      icon: Icon(Icons.label),
      iconMargin: EdgeInsets.only(bottom: 5),
    ),
    Tab(
      text: '复式投注',
      icon: Icon(Icons.car_rental),
      iconMargin: EdgeInsets.only(bottom: 5),
    ),
    Tab(
      text: '复式投注',
      icon: Icon(Icons.cabin),
      iconMargin: EdgeInsets.only(bottom: 5),
    ),
    Tab(
      text: '复式投注',
      icon: Icon(Icons.key),
      iconMargin: EdgeInsets.only(bottom: 5),
    ),
  ];

  List<Tab> tabsNoIcons = [
    Tab(
      text: '首页了开始的',
    ),
    Tab(
      text: '单项投注',
    ),
    Tab(
      text: '大厅',
    ),
    Tab(
      text: '复式投注',
    ),
    Tab(
      text: '复式投注',
    ),
    Tab(
      text: '复式投注',
    ),
    Tab(
      text: '复式投注',
    ),
  ];


}
