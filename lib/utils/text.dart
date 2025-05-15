

import 'package:flutter/material.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:typewritertext/typewritertext.dart';

class HintText extends StatelessWidget {
  const HintText(
    {
      super.key, 
      required this.text, 
      this.color = HColors.third, 
      this.fontSize = 20, 
      this.durationAnim = const Duration(milliseconds: 20),
      this.textAlign = TextAlign.start,
    }
  );

  final String text;
  final Color color;
  final double fontSize;
  final Duration durationAnim;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TypeWriter.text(
      text,
      textAlign: textAlign,
      duration: durationAnim,
      style: TextStyle(
        color: color,
        fontSize: fontSize
      ),
    );
  }
  
}

class HintTextNoAnim extends StatelessWidget {
  const HintTextNoAnim(
    {
      super.key, 
      required this.text, 
      this.color = HColors.third, 
      this.fontSize = 20, 
      this.textAlign = TextAlign.start,
    }
  );

  final String text;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize
      ),
    );
  }
  
}