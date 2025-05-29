import 'dart:async';
import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/game.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/popup/make_bet_game.dart';
import 'package:hate_watch/popup/prop_edit.dart';
import 'package:hate_watch/popup/sign_in.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:pixelarticons/pixel.dart';

// ignore: must_be_immutable
class GameCard extends StatelessWidget with ChangeNotifier {
  GameCard({super.key, required this.game});

  final Game game;

  final ValueNotifier<bool> inWidget = ValueNotifier(false);
  final ValueNotifier<String> timerValue = ValueNotifier("00:00");
  bool firstFrame = true;
  bool request = true;

  void onTap(BuildContext context) async {

    var rep;
    if (game.state == "OPEN") rep = await User.instance.getInfoGame(game.id);

    game.state == "OPEN" ?
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: HColors.back,
        child: User.instance.isConnected()
            ? MakeBetGame(game: game,dataOptions: rep).bounceInUp()
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

  Color getColorForStatus(Game game) {
    switch(game.state) {
      case 'ONGOING':
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

    Timer.periodic(Duration(seconds: 1), (timer) async {
      int now = DateTime.now().millisecondsSinceEpoch;

      int elapsedMillis = now - startEpochMillis;
      Duration elapsed = Duration(milliseconds: elapsedMillis);

      // print(formatDuration(elapsed)); // e.g. 00:01, 00:02, etc.
      timerValue.value = formatDuration(elapsed);
      timerValue.notifyListeners();

      if (int.parse(formatDuration(elapsed).split(":")[0]) >= 3 && game.state == "OPEN" && request)
      {
        request = false;
        try {
          await postCallApiBody('api/proposals/close', 
            {
              'proposalId' : game.id,
            }
          );
        // ignore: empty_catches
        } catch (e) {
          
        }
        
        request = false;
      }
    });
  }

  AutoSizeText textWithInfo(double firstText, String subtext, {String firstTextSign = ""}) {
    
    Color colorText = HColors.getColorFromX(firstText);

    switch(subtext) {
      case "WIN":
        colorText = HColors.getColorFromWinrate(firstText);
        break;
      case "KDA":
        colorText = HColors.getColorFromKda(firstText);
        break;
      case "CS/MIN":
        colorText = HColors.getColorFromCs(firstText);
        break;
    }
    
    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstText.toString() + firstTextSign,
            style: TextStyle(
              color: colorText,
              fontFamily: 'Jersey',
              fontSize: 27
            ),
          ),
          TextSpan(
            text: subtext,
            style: TextStyle(
              color: HColors.third,
              fontFamily: 'Jersey',
              fontSize: 17
            ),
          )
        ]
      )
    );
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

    // print(game.users[0].champ);

    if (MediaQuery.sizeOf(context).width < 600) {
      sizeText = 30;
      resized = true;
    }


    if (firstFrame) {
      startMatchTimer(game.start);
      firstFrame = false;
    }

    TextStyle textInfoStyle = 
      TextStyle(
        fontSize: sizeText-10,
        color: HColors.third,
      );

    return 
    MouseRegion(
      cursor: game.state == "CLOSED" ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
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
            // width: 700,
            child: 
              DecoratedBox(
                decoration: BoxDecoration(
                  color: HColors.up,
                  border: value ? Border.all(
                    width: 4,
                    color: getColorForStatus(game),
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
                                children: [
                                  Wrap(children: [
                                    for(var user in game.users)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                      CachedNetworkImage(
                                        width: resized ? 40 : 75,
                                        height: resized ? 40 : 75,
                                        imageUrl: 'https://ddragon.leagueoflegends.com/cdn/15.10.1/img/champion/${user.champ}.png',
                                        errorWidget: (context, url, error) {
                                          return SizedBox();
                                        },
                                      ),
                                      Text(
                                        user.nameLol,
                                        style: TextStyle(
                                          fontSize: sizeText/2,
                                          color: HColors.third
                                        ),
                                        ),
                                    ],)
                                  ],),

                                ],
                              ),
                          
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: 
                                    [
                                      if (game.state == "ONGOING")
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


                                    ],
                                  ),
                                  
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 5,
                                    children: [
                                    Text(
                                      game.users.first.name,
                                      style: TextStyle(
                                        fontSize: sizeText,
                                        color: HColors.four,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    //Expanded(child: SizedBox()),
                                    SvgPicture.asset(
                                      "assets/ranks/${game.users.first.elo.toLowerCase()}.svg",
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) {
                                        return SvgPicture.asset("assets/ranks/unranked.svg");
                                      },
                                    ),
                                    Text(
                                      game.users.first.elo,
                                      style: textInfoStyle,
                                    ),
                                    Text(
                                      game.users.first.div.length.toString(),
                                      style: textInfoStyle,
                                    ),
                                    SizedBox(),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: game.users.first.lp.toString(),
                                            style: textInfoStyle.copyWith(
                                              fontFamily: 'Jersey',
                                              color: HColors.sec
                                            )
                                          ),
                                          TextSpan(
                                            text: " LP",
                                            style: textInfoStyle.copyWith(
                                              fontFamily: 'Jersey',
                                              fontSize: sizeText-15
                                            )
                                          ),
                                        ]
                                      )
                                    ),
                                    // Text(
                                    //   "${game.users.first.lp} Lp",
                                    //   style: textInfoStyle,
                                    // ),
                                    // Text(
                                    //   "|",
                                    //   style: textInfoStyle,
                                    // ),
                                    // Text(
                                    //   "Level ${game.users.first.level}",
                                    //   style: textInfoStyle,
                                    // ),
                                  ],),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 10,
                                    children: [
                                    textWithInfo(game.users.first.winrate, 'WIN', firstTextSign: '%'),
                                    textWithInfo(game.users.first.kda, 'KDA'),
                                    textWithInfo(game.users.first.csm, 'CS/MIN'),
                                  ],)

                              ],),

                                SizedBox(
                                  child:
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                              ValueListenableBuilder(valueListenable: timerValue, builder: (context, value, child) {
                                return 
                                SizedBox(
                                  width: 75,
                                  child: 
                                    Text(
                                      value,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: HColors.third,
                                        fontSize: sizeText-5,
                                      ),
                                    ),
                                );
                              }),
                            ],
                          ),
                      )
                  ]),
            )
          ).fadeIn(
            duration: Duration(milliseconds: 300)
        )));
      })
    );
  }
}