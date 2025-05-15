import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/popup/create_bet.dart';
import 'package:hate_watch/popup/disconnect.dart';
import 'package:hate_watch/popup/sign_in.dart';
import 'package:hate_watch/utils/bet_card.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/card.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/pari_card.dart';
import 'package:hate_watch/utils/title.dart';
import 'package:intl/intl.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';


// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

  final List<TargetFocus> targets = [];

  final GlobalKey keyButton = GlobalKey();
  final GlobalKey keyHello = GlobalKey();
  final GlobalKey keyStats = GlobalKey();
  final GlobalKey keyPari = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  void showTutorial(BuildContext context) {

    targets.clear();

    targets.add(
      TargetFocus(
        identify: "intro",
        targetPosition: TargetPosition(Size(10,10), Offset(MediaQuery.sizeOf(context).width*0.5, MediaQuery.sizeOf(context).height*0.5)),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'intro_start'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "hello",
        keyTarget: keyHello,
        // targetPosition: TargetPosition(Size(100,100),Offset(100, 10)),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            builder: (context, controller) {
              return Text(
                "intro_1".tr,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            },
          ),
        ]
      )
    );

    targets.add(
      TargetFocus(
        identify: "create",
        keyTarget: keyButton,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            builder: (context, controller) {
              return 
              Text(
                "intro_2".tr,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            },
          ),
        ]
      )
    );

    targets.add(
      TargetFocus(
        identify: "stats",
        keyTarget: keyStats,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            builder: (context, controller) {
              return 
              Text(
                "intro_3".tr,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            },
          ),
        ]
      )
    );

    targets.add(
      TargetFocus(
        identify: "pari",
        keyTarget: keyPari,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            builder: (context, controller) {
              return 
              Text(
                'intro_4'.tr,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            },
          ),
        ]
      )
    );

    targets.add(
      TargetFocus(
        identify: "end",
        targetPosition: TargetPosition(Size(10,10), Offset(MediaQuery.sizeOf(context).width*0.5, MediaQuery.sizeOf(context).height*0.5)),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'intro_end'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              );
            },
          )
        ],
      ),
    );

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textStyleSkip: TextStyle(fontSize: 45),
    )..show(context:context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Row(
      children: [
        // Sidebar
        ValueListenableBuilder(valueListenable: User.instance.notif, builder: (context, value, child) {
          return
        SidebarX(
          
          showToggleButton: false,
          theme: SidebarXTheme(
            iconTheme: IconThemeData(
              color: HColors.third
            ),
            decoration: BoxDecoration(
              color: HColors.up,
            ),
          ),
          controller: SidebarXController(selectedIndex: 0),
          items: [
            // SidebarXItem(icon: Pixel, label: 'Home'),
            // SidebarXItem(icon: Pixel.home, label: 'Home'),
            // SidebarXItem(
            //   icon: Pixel.avatar, label: 'ChangePseudo',
            //   // TODO : Changer Pseudo
            // ),
            // SidebarXItem(
            //   icon: Pixel.lock, label: 'Search',
            //   // TODO : Changer password
            // ),
            SidebarXItem(
              iconBuilder: (a,b) {
                return 
                ValueListenableBuilder(valueListenable: User.instance.timeNextDaily, builder: (context, valueTime, child) {
                  //print("reload");
                  return Column(
                    children: 
                    [
                      Icon(
                        Pixel.calendarcheck,
                        color: value.isNowDaily() ? HColors.four : HColors.third,
                        size: 30,
                      ),
                      Text(
                        value.getStringDaily(),
                        style: TextStyle(
                          fontSize: 16,
                          color: HColors.five
                        ),
                      ),
                    ],
                  );
                });
              } ,
              icon: Pixel.calendarcheck, label: 'Daily',
              onTap: 
              !value!.isConnected() ?
              () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: HColors.back,
                    child: 
                      SignIn().bounceInUp(),
                  ),
                );
              }
              :
              () async {
                var rep = await User.instance.claimDaily();

                if (rep is Map && rep.containsKey("message")) {
                  switch (rep['message']) {
                    case 'Daily reward claimed successfully':
                      AlertInfo.show(
                        // ignore: use_build_context_synchronously
                        context: context,
                        text: 'daily_reward_success'.tr,
                        
                        typeInfo: TypeInfo.success,
                        position: MessagePosition.top,
                        action: null,
                      );
                      break;
                    case 'Daily reward already claimed':
                      AlertInfo.show(
                        // ignore: use_build_context_synchronously
                        context: context,
                        text: 'daily_reward_success_already'.tr,
                        
                        typeInfo: TypeInfo.error,
                        position: MessagePosition.top,
                        action: null,
                      );
                      break;
                  }
                } else {
                  AlertInfo.show(
                    // ignore: use_build_context_synchronously
                    context: context,
                    text: 'daily_reward_error'.tr,
                    
                    typeInfo: TypeInfo.error,
                    position: MessagePosition.top,
                    action: null,
                  );
                }
                
              }
            )
          ],
          footerBuilder: (context, extended) {
            return 
            
              Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [

                IconButton(onPressed: () {
                    showTutorial(context);
                  }, icon: Icon(Pixel.infobox, size: 30, color: HColors.four,)),


                value.isConnected() ? Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: 
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: HColors.back,
                          child: 
                            Disconnect().bounceInUp(),
                        ),
                      );
                    },
                    icon: Icon(Pixel.logout, color: HColors.five, size: 30,),
                  ),
                ) : SizedBox(),
                
                
              ],);
              
            });
          },
        ),

        // Main content
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: User.instance.notif,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          children: [
                          RichText(
                            key: keyHello,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${"hello".tr} ",
                                  style: TextStyle(
                                    color: HColors.four,
                                    fontFamily: 'Jersey',
                                    fontSize: 40,
                                  ),
                                ),
                                TextSpan(
                                  text: value!.pseudo,
                                  style: TextStyle(
                                    color: HColors.prim,
                                    fontFamily: 'Jersey',
                                    fontSize: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),


                          // if (value.isConnected())
                          RichText(
                            textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: value.balance.toString(),
                                  style: TextStyle(
                                    color: HColors.sec,
                                    fontFamily: 'Jersey',
                                    fontSize: 40,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Po',
                                  style: TextStyle(
                                    color: HColors.third,
                                    fontFamily: 'Jersey',
                                    fontSize: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],),

                        if (User.instance.role == "none")
                        WTextButton(
                          key: keyButton,
                          text: 'signin'.tr,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: HColors.back,
                                child: 
                                  SignIn().bounceInUp(),
                              ),
                            );
                          },
                        ),

                        if (User.instance.role == "ADMIN")
                        WTextButton(
                          key: keyButton,
                          text: 'create_bet'.tr,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: HColors.back,
                                child: User.instance.isConnected()
                                    ? CreateBet().bounceInUp()
                                    : SignIn().bounceInUp(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Expanded scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            HTitle(start: "Stats".tr),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                InfoCard(key: keyStats,title: "bet_win".tr, value: "${value.totalWins} / ${value.totalBets}", subValue: value.totalBets == 0 ? "--%" : "${NumberFormat("0.#").format(value.totalWins/value.totalBets*100)}%"),
                                // InfoCard(title: "Po Gagnés", value: "3053"),
                                // InfoCard(title: "Meilleur Winrate sur", value: "Arthur"),
                                InfoCard(title: "last_po_win".tr, value: value.lastBetGainOrLoss == null ? "No bets" : value.lastBetGainOrLoss.toString()),
                                // InfoCard(title: "Paris Crée", value: "10"),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              spacing: 10,
                              children: [
                                HTitle(start: '${'all_bets'.tr.split(" ")[0]} ', end: 'all_bets'.tr.split(" ")[1]),
                                IconButton(
                                  onPressed: () async {
                                    await value.getAllProps();
                                    AlertInfo.show(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      text: 'reload_all_bets'.tr,
                                      
                                      typeInfo: TypeInfo.success,
                                      position: MessagePosition.top,
                                      action: null,
                                    );
                                  }, 
                                  icon: Icon(Pixel.reload, color: HColors.third, size: 30,),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                if (value.props.isEmpty)
                                PariCardNone(key: keyPari),

                                if (!value.loadedBets)
                                CardLoading(
                                  width: 400,
                                  height: 120,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  margin: EdgeInsets.only(bottom: 10),
                                  cardLoadingTheme: CardLoadingTheme(colorOne: HColors.back, colorTwo: HColors.up),
                                ),

                                ...List.generate(value.props.length, (i) {
                                  if (i == 0){
                                    return PariCard(key: keyPari, prop: value.props[i],).fadeIn();
                                  }

                                  return PariCard(prop: value.props[i],).fadeIn();
                                })

                                // for (Bet bet in value.bets)
                                // PariCard(odd: bet.odds, person: bet.player, desc: bet.title, total: 400).fadeIn(),
                              ],
                            ),

                            HTitle(start: '${'done_bets'.tr.split(" ")[0]} ', end: 'done_bets'.tr.split(" ")[1]),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [

                                if (!value.loadedBets)
                                CardLoading(
                                  width: 400,
                                  height: 120,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  margin: EdgeInsets.only(bottom: 10),
                                  cardLoadingTheme: CardLoadingTheme(colorOne: HColors.back, colorTwo: HColors.up),
                                ),

                                if (value.betsUser.isNotEmpty)
                                ...List.generate(value.betsUser.length, (i) {
                                // if (i == 0){
                                //   return PariCard(key: keyPari, bet: value.props[i],).fadeIn();
                                // }

                                  return BetCard(bet: value.betsUser[i],).fadeIn();
                                })

                                // for (Bet bet in value.bets)
                                // PariCard(odd: bet.odds, person: bet.player, desc: bet.title, total: 400).fadeIn(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    )
    );
  }

}