import 'package:flutter/material.dart';
import 'package:flutter_bet/utils/date_util.dart';

class CustomSelectModel {
  int type;
  String label;
  dynamic data;

  CustomSelectModel(this.label, {this.type = 0, this.data});

  copyWith({String label = '', int type = 0, dynamic data}) {
    this.label = label;
    this.type = type;
    this.data = data;
    return this;
  }



  @override
  String toString() {
    return 'CustomSelectModel{type: $type, label: $label, data: $data}';
  }
}
