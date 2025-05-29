
import 'package:flutter/material.dart';

class LittleAnimCircle extends StatefulWidget {
  const LittleAnimCircle({super.key, required this.foregroundColor, required this.backgroundColor, this.size = 20});

  final Color foregroundColor;
  final Color backgroundColor;

  final double size;

  @override
  State<LittleAnimCircle> createState() => LittleAnimCircleState();

}

class LittleAnimCircleState extends State<LittleAnimCircle> with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _radiusAnimationOther;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _radiusAnimation = Tween<double>(begin: 7, end: 9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _radiusAnimationOther = Tween<double>(begin: 7, end: 11).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCirc,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Center( 
              child: CircleAvatar(
                radius: _radiusAnimation.value,
                backgroundColor: widget.backgroundColor,
                child: CircleAvatar(
                  radius: _radiusAnimationOther.value / 2,
                  backgroundColor: widget.foregroundColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}