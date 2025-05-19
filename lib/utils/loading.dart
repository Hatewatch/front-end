
import 'package:flutter/material.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:loading_indicator/loading_indicator.dart';

// ignore: must_be_immutable
class Loading extends StatelessWidget {
  const Loading({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        color: HColors.prim,
        borderRadius: HBorder.borderRadius,

      ),
      width: size.width,
      height: size.height,
      child: 
      Transform.scale(
        scale: 0.5,
        child: LoadingIndicator(
          indicatorType: Indicator.lineScale,
          colors: const [Colors.white],
          strokeWidth: 0.5,
        ),
      ),
    );
  }

}