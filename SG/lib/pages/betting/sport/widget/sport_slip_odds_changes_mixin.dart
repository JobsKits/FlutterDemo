import 'package:flutter/cupertino.dart';

import '../../../../widget/custom_asset_icon.dart';

mixin SportSlipOddsChangesMixin {
  void showOddsChangesAnimation(BuildContext context, Offset startOffset, Size size, String type) {
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return CustomOddsChangeOverlay(
          startOffset: startOffset,
          size: size,
          type: type,
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 2300), () {
      overlayEntry.remove();
    });
  }
}

class CustomOddsChangeOverlay extends StatefulWidget {
  final Offset startOffset;
  final Size size;
  final String type;

  const CustomOddsChangeOverlay(
      {super.key, required this.startOffset, required this.size, required this.type});

  @override
  State<StatefulWidget> createState() => _CustomOddsChangeState();
}

class _CustomOddsChangeState extends State<CustomOddsChangeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationTranslate;
  late Offset currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPosition = widget.startOffset;
    // 创建动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2300),
    );
    _animationTranslate = TweenSequence<Offset>([
      TweenSequenceItem<Offset>(
        tween: Tween(begin: Offset(-20, 8), end: Offset(-20, -5.0)),
        weight: 1.0,
      ),
      TweenSequenceItem<Offset>(
        tween: Tween(begin: Offset(-20, 8), end: Offset(-20, -5.0)),
        weight: 1.0,
      ),
      TweenSequenceItem<Offset>(
        tween: Tween(begin: Offset(-20, 8), end: Offset(-20, -5.0)),
        weight: 1.0,
      ),
      TweenSequenceItem<Offset>(
        tween: Tween(begin: Offset(-20, 8), end: Offset(-20, -5.0)),
        weight: 1.0,
      ),
    ]).animate(_controller);

    _controller.repeat(reverse: true); // 设置动画循环
    _controller.forward();
  }

  void startAnimation() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Release the animation controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: currentPosition.dx,
      top: currentPosition.dy,
      child: AnimatedBuilder(
        animation: _animationTranslate,
        builder: (context, child) {
          final currentPosition = Offset(widget.startOffset.dx - 20, widget.startOffset.dy);
          final animatedPosition = _animationTranslate.value;
          return Transform.translate(
            offset: animatedPosition,
            child: CustomAssetIcon(
              name: 'assets/images/bet_slip/ic_odds_up.webp',
              size: 10,
            ),
          );
        },
      ),
    );


  }
}
