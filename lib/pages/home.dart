import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hate_watch/class/app.dart';
import 'package:hate_watch/class/bet.dart';
import 'package:hate_watch/class/tutorial.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/popup/code_claim.dart';
import 'package:hate_watch/popup/create_prop.dart';
import 'package:hate_watch/popup/create_riot_account_link.dart';
import 'package:hate_watch/popup/disconnect.dart';
import 'package:hate_watch/popup/sign_in.dart';
import 'package:hate_watch/utils/bet_card.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/card.dart';
import 'package:hate_watch/utils/double_helper.dart';
import 'package:hate_watch/utils/game_card.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/leaderboard_card.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/pari_card.dart';
import 'package:hate_watch/utils/roman.dart';
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
    Tutorial.showTutorial(context, keyHello, keyStats, keyPari);
  }

  @override
  Widget build(BuildContext context) {

    // Start welcome if he didnt
    if (!App.instance.hasDoneTutorial()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Tutorial.showWelcome(context, keyHello, keyStats, keyPari);
      });
    }

    double sizeTitle = 40;
    bool resized = false;

    if (MediaQuery.sizeOf(context).width < 600) {
      sizeTitle = 28;
      resized = true;
    }

    return Scaffold(

      body: Row(
      children: [
        // Sidebar
        ValueListenableBuilder(valueListenable: User.instance.notif, builder: (context, value, child) {
          return
        SidebarX(
          
          showToggleButton: false,
          theme: SidebarXTheme(
            width: resized ? 50 : 70,
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
                        size: sizeTitle-10,
                      ),
                      Text(
                        value.getStringDaily(),
                        style: TextStyle(
                          fontSize: resized ? 9 : 15,
                          color: User.instance.isNowDaily() ? HColors.sec : HColors.five
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
            ),
            if (User.instance.isConnected())
            SidebarXItem(
              icon: Pixel.gift, label: 'Search',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: HColors.back,
                    child: 
                      CodeClaim().bounceInUp(),
                  ),
                );
              }
            ),

            if (User.instance.isConnected())
            SidebarXItem(
              icon: Pixel.keyboard, label: 'Search',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: HColors.back,
                    child: 
                      CreateRiotAccountLink().bounceInUp(),
                  ),
                );
              }
            ),
            
          ],
          footerBuilder: (context, extended) {
            return 
            
              Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [

                IconButton(onPressed: () {
                    showTutorial(context);
                  }, icon: Icon(Pixel.infobox, size: sizeTitle-10, color: HColors.four,)),


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
                    icon: Icon(Pixel.logout, color: HColors.five, size: sizeTitle-10,),
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
                padding: EdgeInsets.all(resized ? 10 : 20),
                child: Column(
                  children: [
                    // Header Row
                    SizedBox(
                      width: double.infinity,
                      child: 
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      fontSize: sizeTitle,
                                    ),
                                  ),
                                  TextSpan(
                                    text: value!.pseudo,
                                    style: TextStyle(
                                      color: HColors.prim,
                                      fontFamily: 'Jersey',
                                      fontSize: sizeTitle,
                                    ),
                                  ),
                                ],
                              ),
                            ),


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
                                      fontSize: sizeTitle,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Po',
                                    style: TextStyle(
                                      color: HColors.third,
                                      fontFamily: 'Jersey',
                                      fontSize: sizeTitle-12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],),

                          if (value.icon != 0 && value.level != 0 && value.isConnected())
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 10,
                            children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  Text(
                                    value.nameLol,
                                    style: 
                                      TextStyle(
                                        color: HColors.four,
                                        fontSize: sizeTitle-10,
                                      ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/ranks/${value.rank.toLowerCase()}.svg",
                                    width: 20,
                                    height: 20,
                                    errorBuilder: (context, error, stackTrace) {
                                      return SvgPicture.asset("assets/ranks/unranked.svg");
                                    },
                                  ),
                                  Text(
                                    value.div, 
                                    style: 
                                      TextStyle(
                                        color: HColors.four,
                                        fontSize: sizeTitle,
                                      ),
                                  ),
                                  RichText(
                                    textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false,
                                      applyHeightToLastDescent: false,
                                    ),
                                    text: TextSpan(
                                      
                                      children: [
                                        TextSpan(
                                          text: value.lp.toString(),
                                          style: TextStyle(
                                            fontFamily: 'Jersey',
                                            color: HColors.sec,
                                            fontSize: sizeTitle,
                                            
                                          ),
                                        ),
                                        TextSpan(
                                          text: " LP",
                                          style: TextStyle(
                                            fontFamily: 'Jersey',
                                            fontSize: sizeTitle-20,
                                            color: HColors.third
                                          )
                                        ),
                                      ]
                                    )
                                  ),
                              ],),
                              Text(
                                "Level ${value.level}",
                                style: TextStyle(
                                  fontSize: sizeTitle - 15
                                ),
                              ),
                            ]),
                            
                            ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: 
                              CachedNetworkImage(
                                height: 60,
                                width: 60,
                                imageUrl: "https://ddragon.leagueoflegends.com/cdn/15.10.1/img/profileicon/${value.icon}.png"
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
                                      ? CreateProp().bounceInUp()
                                      : SignIn().bounceInUp(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
                                InfoCard(title: "last_po_win".tr, value: value.lastBetGainOrLoss == null ? "No bets" : formatSmartClean(value.lastBetGainOrLoss!)),
                                InfoCard(title: "average_bet_amount".tr, value: formatSmartClean(BetHelper.getAverageBetAmount(value.betsUser))),
                                InfoCard(title: "average_bet_odds".tr, value: formatSmartClean(BetHelper.getAverageBetOdds(value.betsUser))),
                                InfoCard(title: "average_bet_player".tr, value: BetHelper.getAverageBetPlayer(value.betsUser)),
                                InfoCard(title: "bet_best_winrate_player".tr, value: BetHelper.getBestBetPlayerWinrate(value.betsUser)),
                                InfoCard(title: "bet_best_amount".tr, value: formatSmartClean(BetHelper.getBestBetWin(value.betsUser))),
                                // InfoCard(title: "Paris Crée", value: "10"),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            Row(
                              spacing: 10,
                              children: [
                                HTitle(start: '${'last_bets'.tr.split(" ")[0]} ', end: 'last_bets'.tr.split(" ")[1]),
                                IconButton(
                                  onPressed: () async {
                                    await value.getAllBetsWeb();
                                    AlertInfo.show(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      text: 'reload_last_bets'.tr,
                                      
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
                                if (!value.loadedBets)
                                CardLoading(
                                  width: 350,
                                  height: 120,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  margin: EdgeInsets.only(bottom: 10),
                                  cardLoadingTheme: CardLoadingTheme(colorOne: HColors.back, colorTwo: HColors.up),
                                ),

                                ...List.generate(value.betsAllWeb.length, (i) {
                                  return BetCard(bet: value.betsAllWeb[i],).fadeIn();
                                })

                                // for (Bet bet in value.bets)
                                // PariCard(odd: bet.odds, person: bet.player, desc: bet.title, total: 400).fadeIn(),
                              ],
                            ),

                            
                            const SizedBox(height: 20),
                            Row(
                              spacing: 10,
                              children: [
                                HTitle(start: '${'all_bets'.tr.split(" ")[0]} ', end: 'all_bets'.tr.split(" ")[1]),
                                IconButton(
                                  onPressed: () async {
                                    await value.getGames();
                                    AlertInfo.show(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      text: 'reload_all_props'.tr,
                                      
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
                                if (value.games.isEmpty)
                                PariCardNone(key: keyPari),

                                if (!value.loadedBets)
                                CardLoading(
                                  width: 500,
                                  height: 120,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  margin: EdgeInsets.only(bottom: 10),
                                  cardLoadingTheme: CardLoadingTheme(colorOne: HColors.back, colorTwo: HColors.up),
                                ),

                                // ...List.generate(value.props.length, (i) {
                                //   if (i == 0){
                                //     return PariCard(key: keyPari, prop: value.props[i],).fadeIn();
                                //   }

                                //   return PariCard(prop: value.props[i],).fadeIn();
                                // })
                                
                                ...List.generate(value.games.length, (i) {
                                  if (i == 0){
                                    return GameCard(key: keyPari, game: value.games[i],).fadeIn();
                                  }

                                  return GameCard(game: value.games[i],).fadeIn();
                                })

                                // for (Bet bet in value.bets)
                                // PariCard(odd: bet.odds, person: bet.player, desc: bet.title, total: 400).fadeIn(),
                              ],
                            ),

                            const SizedBox(height: 20),
                            Row(
                              spacing: 10,
                              children: [
                                HTitle(start: '${'done_bets'.tr.split(" ")[0]} ', end: 'done_bets'.tr.split(" ")[1]),
                                IconButton(
                                  onPressed: () async {
                                    await value.getBetsUser();
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

                                if (!value.loadedBets)
                                CardLoading(
                                  width: 350,
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
                                  // print(i);

                                  return BetCard(bet: value.betsUser[i],).fadeIn();
                                })

                                // for (Bet bet in value.bets)
                                // PariCard(odd: bet.odds, person: bet.player, desc: bet.title, total: 400).fadeIn(),
                              ],
                            ),

                            const SizedBox(height: 20),
                            Row(
                              spacing: 10,
                              children: [
                                HTitle(start: '${'leaderboard_server'.tr.split(" ")[0]} ', end: 'leaderboard_server'.tr.split(" ")[1]),
                                IconButton(
                                  onPressed: () async {
                                    await value.getLeaderboard();
                                    AlertInfo.show(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      text: 'reload_leaderboard'.tr,
                                      
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
                            Column(
                              spacing: 10,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                if (!value.loadedBets)
                                CardLoading(
                                  width: 350,
                                  height: 50,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  margin: EdgeInsets.only(bottom: 10),
                                  cardLoadingTheme: CardLoadingTheme(colorOne: HColors.back, colorTwo: HColors.up),
                                ),

                                if (value.leaderboard.isNotEmpty)
                                ...List.generate(value.leaderboard.length, (i) {
                                  return LeaderboardCard(lead: value.leaderboard[i], pos: i+1,).fadeIn();
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