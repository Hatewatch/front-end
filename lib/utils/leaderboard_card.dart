

import 'package:flutter/material.dart';
import 'package:hate_watch/api/leaderboard.dart';
import 'package:hate_watch/utils/double_helper.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';

class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({super.key, required this.lead, required this.pos});

  final Leaderboard lead;
  final int pos;

  Color colorForPlace(int i) {
    switch(i) {
      case 1:
        return HColors.eleven;
      case 2:
        return HColors.ten;
      case 3:
        return HColors.twelve;
      default:
        return HColors.third;
    }
  }

  @override
  Widget build(BuildContext context) {

    double fontSize = 24;

    if (MediaQuery.sizeOf(context).width < 600) {
      fontSize = 18;
    }

    return SizedBox(
      width: 400,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: HColors.up,
          borderRadius: HBorder.borderRadius,
        ),
        child: 
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20, 
            vertical: 5
          ),
          child: 
            Row(
              spacing: fontSize == 18 ? 5 : 15,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: 
              [
                Text(
                  pos.toString(),
                  style: TextStyle(
                    fontSize: fontSize+8,
                    color: colorForPlace(pos),
                  ),
                ),

                Text(
                  lead.name,
                  style: TextStyle(
                    color: HColors.prim,
                    fontSize: fontSize
                  ),
                ),

                RichText(
                  text: 
                    TextSpan(
                      children: [
                        TextSpan(
                          text: formatSmartClean(lead.amount),
                          style: TextStyle(
                            color: HColors.prim,
                            fontFamily: 'Jersey',
                            fontSize: fontSize
                          ),
                        ),

                        TextSpan(
                          text: " Po",
                          style: TextStyle(
                            color: HColors.third,
                            fontFamily: 'Jersey',
                            fontSize: fontSize-5
                          ),
                        ),
                      ]
                    )
                ),

                RichText(
                  text: 
                    TextSpan(
                      children: [
                        TextSpan(
                          text: lead.totalBets.toString(),
                          style: TextStyle(
                            color: HColors.prim,
                            fontFamily: 'Jersey',
                            fontSize: fontSize
                          ),
                        ),

                        TextSpan(
                          text: " Bets",
                          style: TextStyle(
                            color: HColors.third,
                            fontFamily: 'Jersey',
                            fontSize: fontSize-5
                          ),
                        ),
                      ]
                    )
                ),

                RichText(
                  text: 
                    TextSpan(
                      children: [
                        TextSpan(
                          text: formatSmartClean(lead.percent),
                          style: TextStyle(
                            color: HColors.prim,
                            fontFamily: 'Jersey',
                            fontSize: fontSize
                          ),
                        ),

                        TextSpan(
                          text: "% win",
                          style: TextStyle(
                            color: HColors.third,
                            fontFamily: 'Jersey',
                            fontSize: fontSize-5
                          ),
                        ),
                      ]
                    )
                ),
                
              ],
            ),
        ),
      )
    );
  }
  
}