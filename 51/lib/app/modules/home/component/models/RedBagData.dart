import 'package:flutter/material.dart';

class RedBagData {
  final String? key;
  final Animation<double> translateY;
  final Animation<double> translateX;
  final double rotation;
  final bool isClicked;

  RedBagData({
    required this.key,
    required this.translateY,
    required this.translateX,
    required this.rotation,
    required this.isClicked,
  });

  RedBagData copyWith({
    String? key,
    Animation<double>? translateY,
    Animation<double>? translateX,
    double? rotation,
    bool? isClicked,
  }) {
    return RedBagData(
      key: key ?? this.key,
      translateY: translateY ?? this.translateY,
      translateX: translateX ?? this.translateX,
      rotation: rotation ?? this.rotation,
      isClicked: isClicked ?? this.isClicked,
    );
  }

  @override
  String toString() {
    return 'RedBagData(key: $key, translateY: ${translateY.value}, translateX: ${translateX.value}, rotation: $rotation, isClicked: $isClicked)';
  }
}
