import 'package:flutter/material.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';

class CreatePari extends StatelessWidget {
  const CreatePari({super.key, this.func, this.text = "Créer un pari"});

  final Function? func;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          HColors.prim
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 40, vertical: 10)
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HBorder.radius)
          ),
        ),
      ),
      onPressed: () {
        func!();
      }, 
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25
        ),
      )
    );
  }
}

// ignore: must_be_immutable
class WTextButton extends StatelessWidget {
  WTextButton(
    {
      super.key, 
      this.onTap, 
      required this.text, 
      this.fontSize = 25, 
      this.horizontal = 40, 
      this.vertical = 10,
      this.colorBox = HColors.prim,
      this.activated = true,
      this.filled = true,
      this.colorText = HColors.four,
    }
  );

  final Function? onTap;
  final String text;
  final double fontSize; 
  double horizontal;
  final double vertical;
  final Color colorBox;
  final Color colorText;
  final bool activated;
  final bool filled;

  @override
  Widget build(BuildContext context) {

    if (MediaQuery.sizeOf(context).width < 600) {
      horizontal = 10;
    } else {
      horizontal = 40;
    }

    return 
    TextButton(
      style: ButtonStyle(
        backgroundColor: filled ? WidgetStateProperty.all(
          colorBox
        ) : null,
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical)
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HBorder.radius),
            side: !filled ? BorderSide(
              color: colorBox,
              width: 4
            ) : BorderSide.none,
          ),
        ),
      ),
      onPressed: onTap == null ? null : activated ? () => onTap!() : null, 
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: activated ? colorText : HColors.desac
        ),
      )
    );
  }
}