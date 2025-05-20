import 'dart:async';

import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/class/prop.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/popup/make_bet.dart';
import 'package:hate_watch/popup/prop_edit.dart';
import 'package:hate_watch/popup/sign_in.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:pixelarticons/pixel.dart';

// ignore: must_be_immutable
class PariCard extends StatelessWidget with ChangeNotifier {
  PariCard({super.key, required this.prop});

  final Prop prop;

  final ValueNotifier<bool> inWidget = ValueNotifier(false);
  final ValueNotifier<String> timerValue = ValueNotifier("00:00");
  bool firstFrame = true;

  void onTap(BuildContext context) {

    prop.state == "OPEN" ?
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

  Color getColorForStatus(Prop prop) {
    switch(prop.state) {
      case 'CLOSED':
        return HColors.seven;
      default:
        return HColors.third;
    }
  }

  void startMatchTimer(int startEpochMillis) {

    int now = DateTime.now().millisecondsSinceEpoch;

    int elapsedMillis = now - startEpochMillis;
    Duration elapsed = Duration(milliseconds: elapsedMillis);
    timerValue.value = formatDuration(elapsed);
    timerValue.notifyListeners();

    Timer.periodic(Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      int elapsedMillis = now - startEpochMillis;
      Duration elapsed = Duration(milliseconds: elapsedMillis);

      // print(formatDuration(elapsed)); // e.g. 00:01, 00:02, etc.
      timerValue.value = formatDuration(elapsed);
      timerValue.notifyListeners();
    });
  }
  
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {

    double sizeText = 35;
    bool resized = false;

    if (MediaQuery.sizeOf(context).width < 600) {
      sizeText = 30;
      resized = true;
    }


    if (firstFrame) {
      startMatchTimer(prop.epoch);
      firstFrame = false;
    }

    return 
    MouseRegion(
      cursor: prop.state == "CLOSED" ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (event) {
        inWidget.value = true;
        inWidget.notifyListeners();
      },
      onExit: (event) {
        inWidget.value = false;
        inWidget.notifyListeners();
      },
      child: 
      ValueListenableBuilder(valueListenable: inWidget, builder: (context, value, child) {
      
        return GestureDetector(
          
          // TODO : HOVER POINTER
          onTap: () {
            onTap(context);
          }, 
          child: 
          SizedBox(
            width: 650,
            child: 
              DecoratedBox(
                decoration: BoxDecoration(
                  color: HColors.up,
                  border: value ? Border.all(
                    width: 4,
                    color: getColorForStatus(prop),
                  ) : null,
                  borderRadius: HBorder.borderRadius,
                ),
                child: 
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: 
                          Wrap(
                            runSpacing: 25,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            spacing: 25,
                            
                            children: [
                              
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  
                                  Text(
                                    "Win",
                                    style: TextStyle(
                                      fontSize: sizeText-15,
                                      color: HColors.third,
                                    ),
                                  ),
                                  
                                  RichText(
                                  text: 
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "x",
                                          style: TextStyle(
                                            color: HColors.third,
                                            fontFamily: 'Jersey',
                                            fontSize: sizeText
                                          ),
                                        ),

                                        TextSpan(
                                          text: prop.oddsWin.toString(),
                                          style: TextStyle(
                                            color: HColors.getColorFromX(prop.oddsWin),
                                            fontFamily: 'Jersey',
                                            fontSize: sizeText
                                          ),
                                        ),
                                      ]
                                    )
                                  ),
                                ],
                              ),

                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  
                                  Text(
                                    "Lose",
                                    style: TextStyle(
                                      fontSize: sizeText-15,
                                      color: HColors.third,
                                    ),
                                  ),
                                  
                                  RichText(
                                  text: 
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "x",
                                          style: TextStyle(
                                            color: HColors.third,
                                            fontFamily: 'Jersey',
                                            fontSize: sizeText
                                          ),
                                        ),

                                        TextSpan(
                                          text: prop.oddsLose.toString(),
                                          style: TextStyle(
                                            color: HColors.getColorFromX(prop.oddsLose),
                                            fontFamily: 'Jersey',
                                            fontSize: sizeText
                                          ),
                                        ),
                                      ]
                                    )
                                  ),
                                ],
                              ),
                              
                              if (prop.champ != null)
                              CachedNetworkImage(
                                width: resized ? 40 : 75,
                                height: resized ? 40 : 75,
                                imageUrl: 'https://ddragon.leagueoflegends.com/cdn/15.10.1/img/champion/${prop.champ!}.png',
                                errorWidget: (context, url, error) {
                                  return SizedBox();
                                },
                              ),

                                SizedBox(
                                  width: 210,
                                  child:
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    
                                    //if (PropHelper.getAllBetsForId(prop.id) != 0)
                                    Wrap(
                                      runSpacing: 5,
                                      spacing: 5,
                                      //mainAxisSize: MainAxisSize.min,
                                      children: [ 
                                        if (PropHelper.getAllBetsForId(prop.id) != 0)
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
                                                  fontSize: sizeText-13
                                                ),
                                                textHeightBehavior: TextHeightBehavior(
                                                  applyHeightToFirstAscent: false,
                                                  applyHeightToLastDescent: false,
                                                ),
                                              ),
                                          ],)
                                        ),

                                        if (prop.state == "CLOSED")
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: HBorder.borderRadius,
                                            border: Border.all(
                                              color: HColors.seven,
                                              width: 2,
                                            ),
                                          ),
                                          child: 
                                          Row(
                                            spacing: 5,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Pixel.hourglass,
                                                color: HColors.seven,
                                              ),
                                              Text(
                                                'onGoing'.tr,
                                                style: TextStyle(
                                                  fontSize: sizeText-13
                                                ),
                                                textHeightBehavior: TextHeightBehavior(
                                                  applyHeightToFirstAscent: false,
                                                  applyHeightToLastDescent: false,
                                                ),
                                              ),
                                          ],)
                                        ),

                                        if (User.instance.role == "ADMIN")
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                backgroundColor: HColors.back,
                                                child:
                                                  EditProp(prop: prop,).bounceInUp(),
                                              ),
                                            );
                                          },
                                          child: 
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                            decoration: BoxDecoration(
                                              borderRadius: HBorder.borderRadius,
                                              border: Border.all(
                                                color: HColors.eight,
                                                width: 2,
                                              ),
                                            ),
                                            child: 
                                            Row(
                                              spacing: 5,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Pixel.edit,
                                                  color: HColors.eight,
                                                ),
                                                Text(
                                                  "ADMIN",
                                                  style: TextStyle(
                                                    fontSize: sizeText-13
                                                  ),
                                                  textHeightBehavior: TextHeightBehavior(
                                                    applyHeightToFirstAscent: false,
                                                    applyHeightToLastDescent: false,
                                                  ),
                                                ),
                                            ],)
                                          ),
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
                                                  fontSize: sizeText-10,
                                                  height: 1.1,
                                                ),
                                              ),

                                              TextSpan(
                                                text: " ${prop.title}",
                                                style: TextStyle(
                                                  color: HColors.four,
                                                  fontFamily: 'Jersey',
                                                  fontSize: sizeText-10,
                                                  height: 1.1,
                                                ),
                                              ),
                                            ]
                                          )
                                        )
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
                                  ValueListenableBuilder(valueListenable: timerValue, builder: (context, value, child) {
                                    return Text(
                                      value,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: HColors.third,
                                        fontSize: sizeText-5,
                                      ),
                                    );
                                  }),
                                  
                                  SizedBox(height: 5,),

                                  Text(
                                    "Total Bets | Users",
                                    style: TextStyle(
                                      color: HColors.third,
                                      fontSize: sizeText-15,
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
                                          fontSize: sizeText+10
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
                                        fontSize: sizeText-10,
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
                                        fontSize: sizeText-10,
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
      })
    );
  }
  
}

class PariCardNone extends StatelessWidget {
  const PariCardNone({super.key});

  @override
  Widget build(BuildContext context) {

    double sizeText = 35;

    if (MediaQuery.sizeOf(context).width < 600) {
      sizeText = 30;
    }

    return 
    SizedBox(
      width: 500,
      child: 
    ClipRRect(
      borderRadius: HBorder.borderRadius,
      child: 
        ColoredBox(
          color: HColors.up,
          child: 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: sizeText-15),
              child: 
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: sizeText == 30 ? 10 : 25,
                  
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
                              fontSize: sizeText
                            ),
                          ),

                          TextSpan(
                            text: 1.4.toString(),
                            style: TextStyle(
                              color: HColors.getColorFromX(1.4),
                              fontFamily: 'Jersey',
                              fontSize: sizeText
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
                                padding: EdgeInsets.symmetric(horizontal: sizeText == 30 ? 5 : 10, vertical: 0),
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
                                      size: sizeText - 15,
                                    ),
                                    Text(
                                      "BETTED : 400",
                                      style: TextStyle(
                                        fontSize: sizeText-15
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
                            minFontSize: sizeText-15, 
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'guest'.tr,
                                  style: TextStyle(
                                    color: HColors.sec,
                                    fontFamily: 'Jersey',
                                    fontSize: sizeText-10,
                                    height: 1.1,
                                  ),
                                ),

                                TextSpan(
                                  text: " ${"lose_first_bet".tr}",
                                  style: TextStyle(
                                    color: HColors.four,
                                    fontFamily: 'Jersey',
                                    fontSize: sizeText-10,
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
                            fontSize: sizeText-15,
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
                                fontSize: sizeText+10
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
                                fontSize: sizeText-10,
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
                                fontSize: sizeText-10,
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
                                fontSize: sizeText-10,
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