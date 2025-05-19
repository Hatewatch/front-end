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

  @override
  Widget build(BuildContext context) {

    double sizeText = 35;

    if (MediaQuery.sizeOf(context).width < 600) {
      sizeText = 25;
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
            width: 520,
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 25,
                            
                            children: [
                              
                              Column(
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
                                          text: prop.odds.toString(),
                                          style: TextStyle(
                                            color: HColors.getColorFromX(prop.odds),
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
                                width: 75,
                                height: 75,
                                imageUrl: 'https://ddragon.leagueoflegends.com/cdn/15.10.1/img/champion/${prop.champ!}.png',
                                errorWidget: (context, url, error) {
                                  return SizedBox();
                                },
                              ),

                              Flexible(
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
                                        fontSize: sizeText-13
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