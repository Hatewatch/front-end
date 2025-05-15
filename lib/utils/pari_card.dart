import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/class/prop.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/popup/make_bet.dart';
import 'package:hate_watch/popup/sign_in.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:pixelarticons/pixel.dart';

class PariCard extends StatelessWidget {
  const PariCard({super.key, required this.prop});

  final Prop prop;

  void onTap(BuildContext context) {

    prop.available == 1 ?
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: HColors.back,
        child: User.instance.isConnected()
            ? MakeBet(bet: prop,).bounceInUp()
            : SignIn().bounceInUp(),
      ),
    ) : 
    
    AlertInfo.show(
        // ignore: use_build_context_synchronously
        context: context,
        text: 'make_bet_closed'.tr,
        
        typeInfo: TypeInfo.info,
        position: MessagePosition.top,
        action: null,
      );
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
        width: 400,
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
                              text: prop.odds.toString(),
                              style: TextStyle(
                                color: HColors.getColorFromX(prop.odds),
                                fontFamily: 'Jersey',
                                fontSize: 35
                              ),
                            ),
                          ]
                        )
                      ),

                      Flexible(
                      child: 
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          
                          if (PropHelper.getAllBetsForId(prop.id) != 0)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [ 
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                  borderRadius: HBorder.borderRadius,
                                  border: Border.all(
                                    color: HColors.sec,
                                    width: 2,
                                  ),
                                ),
                                child: 
                                Row(
                                  spacing: 5,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Pixel.checkdouble,
                                      color: HColors.sec,
                                    ),
                                    Text(
                                      "BETTED : ${PropHelper.getAllBetsForId(prop.id)}",
                                      style: TextStyle(
                                        fontSize: 17
                                      ),
                                      textHeightBehavior: TextHeightBehavior(
                                        applyHeightToFirstAscent: false,
                                        applyHeightToLastDescent: false,
                                      ),
                                    ),
                                ],)
                              )
                            ]
                          ,),

                          AutoSizeText.rich(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 25),
                            minFontSize: 20, 
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: prop.player,
                                  style: TextStyle(
                                    color: HColors.sec,
                                    fontFamily: 'Jersey',
                                    fontSize: 25,
                                    height: 1.1,
                                  ),
                                ),

                                TextSpan(
                                  text: " ${prop.title}",
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
                        ],),

                    ),

                      // Flexible(
                      //   child: 
                      //   AutoSizeText.rich(
                      //     maxLines: 3,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: TextStyle(fontSize: 25),
                      //     minFontSize: 20, 
                      //     TextSpan(
                      //       children: [
                      //         TextSpan(
                      //           text: prop.player,
                      //           style: TextStyle(
                      //             color: HColors.sec,
                      //             fontFamily: 'Jersey',
                      //             fontSize: 25,
                      //             height: 1.1,
                      //           ),
                      //         ),

                      //         TextSpan(
                      //           text: " ${prop.title}",
                      //           style: TextStyle(
                      //             color: HColors.four,
                      //             fontFamily: 'Jersey',
                      //             fontSize: 25,
                      //             height: 1.1,
                      //           ),
                      //         ),
                      //       ]
                      //     )
                      //   ),
                      // ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 0,
                        children: [
                          Text(
                            "Total Bets | Users",
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
                                prop.total.toString(),
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

                              Text(
                              "|",
                              style: TextStyle(
                                color: HColors.third,
                                fontSize: 25,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: true,
                              ),
                            ),

                            Text(
                              prop.totalUsers.toString(),
                              style: TextStyle(
                                color: HColors.prim,
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

class PariCardNone extends StatelessWidget {
  const PariCardNone({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: 400,
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
                            text: 1.4.toString(),
                            style: TextStyle(
                              color: HColors.getColorFromX(1.4),
                              fontFamily: 'Jersey',
                              fontSize: 35
                            ),
                          ),
                        ]
                      )
                    ),

                    
                        
                    Flexible(
                      child: 
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [ 
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                  borderRadius: HBorder.borderRadius,
                                  border: Border.all(
                                    color: HColors.sec,
                                    width: 2,
                                  ),
                                ),
                                child: 
                                Row(
                                  spacing: 5,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Pixel.checkdouble,
                                      color: HColors.sec,
                                    ),
                                    Text(
                                      "BETTED : 400",
                                      style: TextStyle(
                                        fontSize: 17
                                      ),
                                      textHeightBehavior: TextHeightBehavior(
                                        applyHeightToFirstAscent: false,
                                        applyHeightToLastDescent: false,
                                      ),
                                    ),
                                ],)
                              )
                            ]
                          ,),

                          AutoSizeText.rich(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 25),
                            minFontSize: 20, 
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'guest'.tr,
                                  style: TextStyle(
                                    color: HColors.sec,
                                    fontFamily: 'Jersey',
                                    fontSize: 25,
                                    height: 1.1,
                                  ),
                                ),

                                TextSpan(
                                  text: " ${"lose_first_bet".tr}",
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
                        ],),

                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 0,
                      children: [
                        Text(
                          "Total Bets | Users",
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
                              400.toString(),
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

                            Text(
                              "|",
                              style: TextStyle(
                                color: HColors.third,
                                fontSize: 25,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: true,
                              ),
                            ),

                            Text(
                              10.toString(),
                              style: TextStyle(
                                color: HColors.prim,
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
    );
  }
  
}