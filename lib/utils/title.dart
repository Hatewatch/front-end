import 'package:flutter/material.dart';
import 'package:hate_watch/utils/hcolors.dart';

class HTitle extends StatelessWidget {
  const HTitle({super.key, this.start, this.end});

  final String? start;
  final String? end;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      RichText(
        text: 
        TextSpan(
          children: [
            if (start != null)
            TextSpan(
              text: start,
              style: TextStyle(
                color: HColors.four,
                fontFamily: 'Jersey',
                fontSize: 35
              ),
            ),

            if (end != null)
            TextSpan(
              text: end,
              style: TextStyle(
                color: HColors.prim,
                fontFamily: 'Jersey',
                fontSize: 35
              ),
            ),
          ]
        )
      ),
    ],);
  }
  
}