import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);

  void Function(Size size) onChange;

  Size _prevSize = Size.zero;

  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child?.size ?? Size.zero;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}

class CustomMeasureSizeWidget extends SingleChildRenderObjectWidget {
  const CustomMeasureSizeWidget({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  final void Function(Size size) onChange;

  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);
}
