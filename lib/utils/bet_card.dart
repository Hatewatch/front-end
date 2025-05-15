import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/class/bet.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/popup/make_bet.dart';
import 'package:hate_watch/popup/sign_in.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hate_watch/utils/localization.dart';

class BetCard extends StatelessWidget {
  const BetCard({super.key, required this.bet});

  final Bet bet;

  void onTap(BuildContext context) {

    // bet.available == 1 ?
    // showDialog(
    //   context: context,
    //   builder: (context) => Dialog(
    //     backgroundColor: HColors.back,
    //     child: User.instance.isConnected()
    //         ? MakeBet(bet: bet,).bounceInUp()
    //         : SignIn().bounceInUp(),
    //   ),
    // ) : 
    
    // AlertInfo.show(
    //     // ignore: use_build_context_synchronously
    //     context: context,
    //     text: 'make_bet_closed'.tr,
        
    //     typeInfo: TypeInfo.info,
    //     position: MessagePosition.top,
    //     action: null,
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: () {
        onTap(context);
      }, 
      child: 
      SizedBox(
        width: 330,
        child: 
      ClipRRect(
        borderRadius: HBorder.borderRadius,
        child: 
          ColoredBox(
            color: HColors.up,
            child: 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 25,
                    
                    children: [
                      RichText(
                      text: 
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "x",
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 35
                              ),
                            ),

                            TextSpan(
                              text: bet.propOdds.toString(),
                              style: TextStyle(
                                color: HColors.getColorFromX(bet.propOdds),
                                fontFamily: 'Jersey',
                                fontSize: 35
                              ),
                            ),
                          ]
                        )
                      ),

                      Flexible(
                        child: 
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
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 0,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              color: HColors.third,
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
                                bet.amount.toString(),
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
                          )
                        ],
                      ),
                    ],
                  ),
              )
          ),
        )
      ).fadeIn(
        duration: Duration(milliseconds: 300)
      ),
    );
  }
}