import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class JobsSizeSpec {
  final double w;
  final double h;

  const JobsSizeSpec({
    required this.w,
    required this.h,
  });

  /// 快捷方法：正方形
  const JobsSizeSpec.square(double size)
      : w = size,
        h = size;
}

Future<DecorationImage> svgAssetBy(String asset, {JobsSizeSpec? size}) async {
  size = size ?? const JobsSizeSpec(w: 24, h: 24);

  final PictureInfo pictureInfo = await vg.loadPicture(
    SvgAssetLoader(asset),
    null,
  );
  final ui.Image image = await pictureInfo.picture.toImage(
    size.w.toInt(),
    size.h.toInt(),
  );
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

  return DecorationImage(
    image: MemoryImage(byteData!.buffer.asUint8List()),
    fit: BoxFit.contain,
  );
}
