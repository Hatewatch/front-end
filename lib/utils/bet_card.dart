import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/class/bet.dart';
import 'package:hate_watch/utils/double_helper.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hate_watch/utils/localization.dart';

class BetCard extends StatelessWidget {
  const BetCard({super.key, required this.bet});

  final Bet bet;

  Color getColorForStatus(Bet bet) {
    switch(bet.state) {
      case 'PLACED':
        return HColors.third;
      case 'CLOSED':
        return HColors.seven;
      case 'ONGOING':
        return HColors.seven;
      case 'FINISHED':
        return bet.result == "WIN" ? HColors.sec : HColors.five;
      default:
        return HColors.third;
    }
  }

  String getStringForStatus(Bet bet) {
    // print(bet.state);
    switch(bet.state) {
      case 'PLACED':
        return 'placed_bet'.tr;
      case 'CLOSED':
        return 'ongoing'.tr;
      case 'ONGOING':
        return 'ongoing'.tr;
      case 'FINISHED':
        return bet.result == "WIN" ? 'win_bet'.tr : 'lose_bet'.tr;
      default:
        return 'placed_bet'.tr;
    }
  }

  int getMulti(Bet bet) {
    switch(bet.state) {
      case 'FINISHED':
        return bet.result == "WIN" ? 1 : -1;
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return  
      Container(
        decoration: BoxDecoration(
          borderRadius: HBorder.borderRadius,
          color: HColors.up,
          border: bet.state != null ? Border.all(
            color: getColorForStatus(bet),
            width: 4
          ) : null,
        ),
        width: 350,
        child: 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: 
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 25,
                
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 0,
                    children: [
                      if (bet.state != null)
                      Text(
                        getStringForStatus(bet),
                        style: TextStyle(
                          color: getColorForStatus(bet),
                          fontSize: 20,
                        ),
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                      
                  //     Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       spacing: 1,
                  //       children: [
                          
                  //         Text(
                  //           bet.amount.toString(),
                  //           style: TextStyle(
                  //             color: HColors.prim,
                  //             fontSize: 45
                  //           ),
                  //           textHeightBehavior: TextHeightBehavior(
                  //             applyHeightToFirstAscent: false,
                  //             applyHeightToLastDescent: false,
                  //           ),
                  //         ).bounceIn(delay: Duration(milliseconds: 200)),
                          
                  //         Text(
                  //           "Po",
                  //           style: TextStyle(
                  //             color: HColors.third,
                  //             fontSize: 25,
                  //           ),
                  //           textHeightBehavior: TextHeightBehavior(
                  //             applyHeightToFirstAscent: false,
                  //             applyHeightToLastDescent: true,
                  //           ),
                  //         ),
                  //       ],
                  //     ).bounceIn(),

                  //     SizedBox(height: 2,),

                  //     RichText(
                  //     text: 
                  //       TextSpan(
                  //         children: [
                  //           TextSpan(
                  //             text: "x",
                  //             style: TextStyle(
                  //               color: HColors.third,
                  //               fontFamily: 'Jersey',
                  //               fontSize: 25
                  //             ),
                  //           ),

                  //           TextSpan(
                  //             text: bet.propOdds.toString(),
                  //             style: TextStyle(
                  //               color: HColors.getColorFromX(bet.propOdds),
                  //               fontFamily: 'Jersey',
                  //               fontSize: 25
                  //             ),
                  //           ),

                  //           TextSpan(
                  //             text: ' = ',
                  //             style: TextStyle(
                  //               color: HColors.third,
                  //               fontFamily: 'Jersey',
                  //               fontSize: 25
                  //             ),
                  //           ),

                  //           TextSpan(
                  //             text: (bet.amount * bet.propOdds).toString(),
                  //             style: TextStyle(
                  //               color: HColors.prim,
                  //               fontFamily: 'Jersey',
                  //               fontSize: 25
                  //             ),
                  //           ),
                  //           // TextSpan(
                  //           //   text: ' Po',
                  //           //   style: TextStyle(
                  //           //     color: HColors.third,
                  //           //     fontFamily: 'Jersey',
                  //           //     fontSize: 19
                  //           //   ),
                  //           // ),
                  //         ]
                  //       )
                  //     ),
                  //   ],
                  // ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 1,
                        children: [
                          
                          Text(
                            bet.result != "LOSE" ? formatSmartClean((bet.amount * bet.propOdds * getMulti(bet))) : formatSmartClean(-bet.amount),
                            style: TextStyle(
                              color: HColors.prim,
                              fontSize: 45
                            ),
                            textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                          ).bounceIn(delay: Duration(milliseconds: 200)),
                          
                          Text(
                            "Po",
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
                      ).bounceIn(),

                      SizedBox(height: 2,),

                      if (bet.result != "LOSE")
                      RichText(
                      text: 
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "= ",
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 25
                              ),
                            ),

                            TextSpan(
                              text: formatSmartClean(bet.amount),
                              style: TextStyle(
                                color: HColors.prim,
                                fontFamily: 'Jersey',
                                fontSize: 25
                              ),
                            ),

                            TextSpan(
                              text: 'x',
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 25
                              ),
                            ),

                            TextSpan(
                              text: bet.propOdds.toString(),
                              style: TextStyle(
                                color: HColors.getColorFromX(bet.propOdds),
                                fontFamily: 'Jersey',
                                fontSize: 25
                              ),
                            ),
                          ]
                        )
                      ),
                    ],
                  ),


                  Flexible(
                    child: 
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        if (bet.betPlayer != null)
                        AutoSizeText.rich(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 25),
                          minFontSize: 18, 
                          TextSpan(
                            children: [
                              TextSpan(
                                text: bet.betPlayer,
                                style: TextStyle(
                                  color: HColors.sec,
                                  fontFamily: 'Jersey',
                                  fontSize: 25,
                                  height: 1.1,
                                ),
                              ),

                              TextSpan(
                                text: " ${'bet_betted_on'.tr}",
                                style: TextStyle(
                                  color: HColors.four,
                                  fontFamily: 'Jersey',
                                  fontSize: 25,
                                  height: 1.1,
                                ),
                              ),
                            ]
                          )
                        ),

                        if (bet.betPlayer != null)
                        AutoSizeText.rich(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 25),
                          minFontSize: 20, 
                          TextSpan(
                            children: [
                              TextSpan(
                                text: bet.propPlayer,
                                style: TextStyle(
                                  color: HColors.sec.withAlpha(150),
                                  fontFamily: 'Jersey',
                                  fontSize: 21,
                                  height: 1.1,
                                ),
                              ),

                              TextSpan(
                                text: " ${bet.propTitle}",
                                style: TextStyle(
                                  color: HColors.four.withAlpha(150),
                                  fontFamily: 'Jersey',
                                  fontSize: 21,
                                  height: 1.1,
                                ),
                              ),
                            ]
                          )
                        ),

                        if (bet.betPlayer == null)
                        AutoSizeText.rich(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 25),
                          minFontSize: 20, 
                          TextSpan(
                            children: [
                              TextSpan(
                                text: bet.propPlayer,
                                style: TextStyle(
                                  color: HColors.sec,
                                  fontFamily: 'Jersey',
                                  fontSize: 25,
                                  height: 1.1,
                                ),
                              ),

                              TextSpan(
                                text: " ${bet.propTitle}",
                                style: TextStyle(
                                  color: HColors.four,
                                  fontFamily: 'Jersey',
                                  fontSize: 25,
                                  height: 1.1,
                                ),
                              ),
                            ]
                          )
                        ),
                    ],)
                  ),
                ],
              ),
            )
        ).fadeIn(duration: Duration(milliseconds: 300));
  }
}