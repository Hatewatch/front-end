

import 'package:flutter/material.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.value, this.subValue});

  final String title;
  final String value;
  final String? subValue;

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      // height: 100,
      child: 
      ClipRRect(
        borderRadius: HBorder.borderRadius,
        child: 
        ColoredBox(
          color: HColors.up,
          child: 
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5, right: 15, left: 15),
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 0,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: HColors.four,
                      fontSize: 20,
                    ),
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 10,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          color: HColors.prim,
                          fontSize: 45
                        ),
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                      
                      if (subValue != null)
                      Text(
                        subValue!,
                        style: TextStyle(
                          color: HColors.third,
                          fontSize: 25,
                        ),
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: true,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
        ),
      ),
    );
  }
}