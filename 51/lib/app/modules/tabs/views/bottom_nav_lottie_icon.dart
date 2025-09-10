import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BottomNavLottieIcon extends StatefulWidget {
  final String inAsset;
  final String outAsset;
  final bool selected;

  const BottomNavLottieIcon({
    super.key,
    required this.inAsset,
    required this.outAsset,
    required this.selected,
  });

  @override
  State<BottomNavLottieIcon> createState() => _BottomNavLottieIconState();
}

class _BottomNavLottieIconState extends State<BottomNavLottieIcon>
    with TickerProviderStateMixin {
  late final AnimationController _inController;
  late final AnimationController _outController;

  LottieComposition? _inComposition;
  LottieComposition? _outComposition;

  bool showIn = false; // 控制谁在前台

  @override
  void initState() {
    super.initState();
    _inController = AnimationController(vsync: this);
    _outController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _inController.dispose();
    _outController.dispose();
    super.dispose();
  }

  void playIn() {
    setState(() => showIn = true);
    _inController
      ..reset()
      ..forward().whenComplete(() {
        _inController.value = 1.0;
      });
  }

  void playOut() {
    setState(() => showIn = false);
    _outController
      ..reset()
      ..forward().whenComplete(() {
        _outController.value = 1.0;
      });
  }

  @override
  void didUpdateWidget(covariant BottomNavLottieIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      widget.selected ? playIn() : playOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: showIn ? 1.0 : 0.0,
          child: Lottie.asset(
            widget.inAsset,
            controller: _inController,
            onLoaded: (composition) {
              _inComposition = composition;
              _inController.duration = composition.duration;
              if (widget.selected) {
                _inController.value = 1.0;
                setState(() => showIn = true);
              }
            },
            width: 80.w,
            height: 80.h,
          ),
        ),
        Opacity(
          opacity: showIn ? 0.0 : 1.0,
          child: Lottie.asset(
            widget.outAsset,
            controller: _outController,
            onLoaded: (composition) {
              _outComposition = composition;
              _outController.duration = composition.duration;
              if (!widget.selected) {
                _outController.value = 1.0;
                setState(() => showIn = false);
              }
            },
            width: 80.w,
            height: 80.h,
          ),
        ),
      ],
    );
  }
}
