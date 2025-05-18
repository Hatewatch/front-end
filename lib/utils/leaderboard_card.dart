

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
              spacing: 15,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: 
              [
                Text(
                  pos.toString(),
                  style: TextStyle(
                    fontSize: 32,
                    color: colorForPlace(pos),
                  ),
                ),

                Text(
                  lead.name,
                  style: TextStyle(
                    color: HColors.prim,
                    fontSize: 24
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
                            fontSize: 25
                          ),
                        ),

                        TextSpan(
                          text: " Po",
                          style: TextStyle(
                            color: HColors.third,
                            fontFamily: 'Jersey',
                            fontSize: 20
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
                            fontSize: 25
                          ),
                        ),

                        TextSpan(
                          text: " Bets",
                          style: TextStyle(
                            color: HColors.third,
                            fontFamily: 'Jersey',
                            fontSize: 20
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
                            fontSize: 25
                          ),
                        ),

                        TextSpan(
                          text: "% win",
                          style: TextStyle(
                            color: HColors.third,
                            fontFamily: 'Jersey',
                            fontSize: 20
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