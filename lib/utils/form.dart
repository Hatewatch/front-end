import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:pixelarticons/pixel.dart';

class WForm extends StatelessWidget {
  const WForm(
    {
      super.key, 
      this.title = '', 
      required this.controller, 
      this.hintText = 'Jon',
      this.maxLength = 20,
      this.width = 400,
      this.maxLines = 1,
      this.textFontSize = 28,
      this.onlyNumbers = false,
      this.onChanged,
      this.onSubmit,
      this.focus,
      this.fontSizeTitle = 26,
      this.height,
    }
  );

  final TextEditingController controller;
  final String title;
  final String hintText;
  final int maxLength;
  final double width;
  final int? maxLines;
  final double textFontSize;
  final bool onlyNumbers;
  final double? height;
  final FocusNode? focus;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final double fontSizeTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        if (title != '') Text(title, style: TextStyle(fontSize: fontSizeTitle),),
        SizedBox(
          width: width,
          height: height,
          child: 
          TextFormField(
            focusNode: focus,
            onFieldSubmitted: onSubmit,
            onChanged: onChanged,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(color: HColors.four, fontSize: textFontSize),
            controller: controller,
            inputFormatters: onlyNumbers ? [FilteringTextInputFormatter.allow(
              RegExp(r'^\d+([.,]\d{0,1})?$'),
            )] : null,
            decoration: InputDecoration(
              helperStyle: TextStyle(color: HColors.third, fontSize: 20),
              filled: true,
              fillColor: HColors.up,
              hintText: hintText,
              hintStyle: TextStyle(color: HColors.third, fontSize: textFontSize),
              focusColor: HColors.third,
              border: OutlineInputBorder(
                borderSide: BorderSide.none
              )
            ),
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class WFormMdp extends StatelessWidget with ChangeNotifier {
  WFormMdp(
    {
      super.key, 
      required this.title, 
      required this.controller, 
      this.hintText = '1234?',
      this.maxLength = 30,
      this.width = 400,
      this.onChanged,
      this.onSubmit,
      this.focus,
      this.fontSizeTitle = 26,
      this.fontSizeHint = 28,
    }
  );

  final TextEditingController controller;
  final String title;
  final String hintText;
  final int maxLength;
  final double width;
  final FocusNode? focus;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final double fontSizeTitle;
  final double fontSizeHint;

  final ValueNotifier<bool> obscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(title, style: TextStyle(fontSize: fontSizeTitle),),
        ValueListenableBuilder(valueListenable: obscure, builder: (context, value, child) {
          return SizedBox(
            width: width,
            child: 
            TextFormField(
              focusNode: focus,
              onChanged: onChanged,
              onFieldSubmitted: onSubmit,
              maxLength: maxLength,
              obscureText: obscure.value,
              obscuringCharacter: '*',
              style: TextStyle(color: HColors.four, fontSize: fontSizeHint),
              controller: controller,
              decoration: InputDecoration(
                suffix: 
                  IconButton(
                    onPressed: () {
                      obscure.value = !obscure.value;
                      obscure.notifyListeners();
                    }, 
                    icon: 
                      Icon(
                        value ? Pixel.eyeclosed : Pixel.eye,
                        color: HColors.four,
                      ),
                  ),
                helperStyle: TextStyle(color: HColors.third, fontSize: 20),
                filled: true,
                fillColor: HColors.up,
                hintText: hintText,
                hintStyle: TextStyle(color: HColors.third, fontSize: fontSizeHint),
                focusColor: HColors.third,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none
                )
              ),
            ),
          );
        })
      ],
    );
  }
}