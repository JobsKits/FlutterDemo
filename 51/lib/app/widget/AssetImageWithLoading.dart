import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FadeInLocalImage extends StatefulWidget {
  final String placeholder;
  final String image;

  const FadeInLocalImage({
    Key? key,
    required this.placeholder,
    required this.image,
  }) : super(key: key);

  @override
  _FadeInLocalImageState createState() => _FadeInLocalImageState();
}

class _FadeInLocalImageState extends State<FadeInLocalImage> {
  late Image _image;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // 预加载图片，确保图片缓存后再显示
    _image = Image.asset(widget.image);
    _image.image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
            setState(() {
              _isLoaded = true;
            });
          }, onError: (exception, stackTrace) {
            setState(() {
              _isLoaded = false;
            });
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isLoaded ? 1.0 : 0.0, // 渐变效果，控制透明度
      duration: const Duration(milliseconds: 500), // 控制淡入时间
      child: _isLoaded
          ? Image.asset(widget.image)
          : Image.asset(widget.placeholder), // 如果图片未加载，则显示占位图
    );
  }
}
