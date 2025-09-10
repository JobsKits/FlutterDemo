
import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 限制小数点后最多八位
    String newText = newValue.text;
    if (newText.contains('.') &&
        newText.substring(newText.indexOf('.') + 1).length > 8) {
      return oldValue;
    }
    return newValue;
  }
}