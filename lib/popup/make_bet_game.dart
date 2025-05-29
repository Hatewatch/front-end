import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/game.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/double_helper.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// ignore: must_be_immutable
class MakeBetGame extends StatelessWidget with ChangeNotifier {
  MakeBetGame({super.key, required this.game, required this.dataOptions});

  final ValueNotifier<bool> canLoad = ValueNotifier(true);
  final ValueNotifier<bool> valid = ValueNotifier(true);

  final TextEditingController add = TextEditingController(text: "10");

  final Game game;

  final dynamic dataOptions;

  ValueNotifier<int> selected = ValueNotifier(0);

  bool firstFrame = true;

  final ValueNotifier<bool> canRequest = ValueNotifier(true);

  bool validateInputs() {
    return add.text.isNotEmpty;
  }

  Future onSubmit(BuildContext context) async {
    //print("Submit");

    if (dataOptions[selected.value]['state'] == "CLOSED") {
      AlertInfo.show(
        // ignore: use_build_context_synchronously
        context: context,
        text: "L'option que t'as sélectionné est close (bouffon)",
        typeInfo: TypeInfo.error,
        position: MessagePosition.top,
        action: null,
      );
      return;
    }

    if (User.instance.balance < double.parse(add.text)) {
      AlertInfo.show(
        // ignore: use_build_context_synchronously
        context: context,
        text: 'make_bet_not_enough'.tr,
        typeInfo: TypeInfo.error,
        position: MessagePosition.top,
        action: null,
      );
      return;
    }

    canRequest.value = false;
    canRequest.notifyListeners();

    var rep = await postCallApiBody(
      'api/bet/bet', 
      {
        'optionId' : dataOptions[selected.value]['bo_id'],
        'betSide' : valid.value ? 'WIN' : 'LOSE',
        'betAmount' : double.parse(add.text),
      }
    );

    print(rep);

    if (rep is Map && rep.containsKey('message') && rep["message"] == "Bet placed successfully") {
      AlertInfo.show(
        // ignore: use_build_context_synchronously
        context: context,
        text: 'make_bet_success'.tr,
        typeInfo: TypeInfo.success,
        position: MessagePosition.top,
        action: null,
      );

      User.instance.getAllInfosUser();
    }

    if (rep is Map && rep.containsKey('message')) {
      switch(rep['message']) {
        case 'Betting option is not open for betting':
          AlertInfo.show(
            // ignore: use_build_context_synchronously
            context: context,
            text: 'make_bet_not_open_option'.tr,
            typeInfo: TypeInfo.error,
            position: MessagePosition.top,
            action: null,
          );
          return;
      }
    }

    if (rep is Map && rep.containsKey('error')){
      AlertInfo.show(
        // ignore: use_build_context_synchronously
        context: context,
        text: 'make_bet_error'.tr,
        typeInfo: TypeInfo.error,
        position: MessagePosition.top,
        action: null,
      );
    }

    Navigator.maybePop(context);

  }

  void setValid(bool value) {
    valid.value = value;
    valid.notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void init() async {
    int now = DateTime.now().millisecondsSinceEpoch;

    int elapsedMillis = now - game.start;
    Duration elapsed = Duration(milliseconds: elapsedMillis);

    if (int.parse(formatDuration(elapsed).split(":")[0]) >= 3 && dataOptions[0]["bo_state"] == "OPEN")
    {
      try {
        var rep = await postCallApiBody('api/betoption/close', 
          {
            'betOptionId' : dataOptions[0]['bo_id'],
          }
        );
        print(rep);
      // ignore: empty_catches
      } catch (e) {
        
      }
      
    }
  }


  @override
  Widget build(BuildContext context) {

    if (firstFrame) {
      init();
      firstFrame = false;
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: 
      Padding(
        padding: EdgeInsets.all(20),
        child:
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 30,
            children: 
            [
              HTitle(end: "make_bet".tr,),
              
              HintText(
                text: 'make_bet_title'.tr,
                textAlign: TextAlign.center
              ),

              ValueListenableBuilder(valueListenable: selected, builder: (context, value, child) {
                //print(dataOptions);
                return CustomPopup(
                  backgroundColor: HColors.up,
                  arrowColor: HColors.up,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < dataOptions.length; i++)
                      GestureDetector(
                        onTap: () {
                          if (dataOptions[i]['bo_state'] == 'CLOSED') {
                            AlertInfo.show(
                              context: context,
                              text: "Cette option est closed !",
                              typeInfo: TypeInfo.error,
                              position: MessagePosition.top,
                              action: null,
                            );
                            return;
                          }
                          // print('hello');
                          selected.value = i;
                          selected.notifyListeners();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          children: [

                            ClipRRect(
                              borderRadius: HBorder.borderRadius,
                              child: ColoredBox(
                                color: i == value ? dataOptions[i]['bo_state'] == 'CLOSED' ? HColors.seven : HColors.prim : HColors.third,
                                child: SizedBox(width: 10, height: 30,)
                                ),
                            ),

                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${game.users.first.name} ",
                                   style: TextStyle(
                                    fontFamily: 'Jersey',
                                    color: dataOptions[i]['bo_state'] == 'CLOSED' ? HColors.seven : HColors.prim,
                                    fontSize: 30
                                  )
                                ),
                                TextSpan(
                                  text: dataOptions[i]['bo_title'],
                                  style: TextStyle(
                                    fontFamily: 'Jersey',
                                    color: dataOptions[i]['bo_state'] == 'CLOSED' ? HColors.third : HColors.four,
                                    fontSize: 30
                                  )
                                ),
                              ]
                            )
                          ),
                          RichText(
                        text:
                          TextSpan(children: [
                            TextSpan(
                              text: 'x',
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: dataOptions[i]['odd_win'].toString(),
                              style: TextStyle(
                                color: HColors.sec,
                                fontFamily: 'Jersey',
                                fontSize: 30,
                              )
                            ),
                            TextSpan(
                              text: ' | ',
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 30,
                              ),
                            ),
                            TextSpan(
                              text: 'x',
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: dataOptions[i]['odd_lose'].toString(),
                              style: TextStyle(
                                color: HColors.five,
                                fontFamily: 'Jersey',
                                fontSize: 30,
                              )
                            ),
                          ]
                        )
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
                                dataOptions[i]['coins_bet'].toString(),
                                style: TextStyle(
                                  color: HColors.prim,
                                  fontSize: 30
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
                                  applyHeightToLastDescent: false,
                                ),
                              ),

                              Text(
                              "|",
                              style: TextStyle(
                                color: HColors.third,
                                fontSize: 20,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: true,
                              ),
                            ),

                            Text(
                              dataOptions[i]['users_bet'].toString(),
                              style: TextStyle(
                                color: HColors.prim,
                                fontSize: 20,
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
                        ],),
                      ),
                    ],
                  ), 
                  child:
                  Container(
                    decoration: BoxDecoration(
                      color: HColors.up,
                      borderRadius: HBorder.borderRadius,
                      border: Border.all(
                        width: 3,
                        color: dataOptions[selected.value]['bo_state'] == 'CLOSED' ? HColors.seven : HColors.sec
                      )
                    ),
                    child:  
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15, 
                        vertical: 5
                      ),
                      child:
                        RichText(text: TextSpan(
                          children: [
                            TextSpan(
                              text: game.users.first.name,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Jersey',
                                color: dataOptions[selected.value]['bo_state'] == 'CLOSED' ? HColors.seven : HColors.sec
                              )
                            ),
                            TextSpan(
                              text: " ${dataOptions[value]['bo_title']}",
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Jersey',
                                color: dataOptions[selected.value]['bo_state'] == 'CLOSED' ? HColors.third : HColors.four
                              )
                            ),
                          ]
                        )) 
                        // Text(
                        //   "${game.users.first.name} ${dataOptions[value]['bo_title']}",
                        //   style: TextStyle(
                        //     fontSize: 30
                        //   ),
                        // ),
                    ),
                  )
                );
                // return GestureDetector(
                //   child: SizedBox(
                //     width: 400,
                //     child: Text(
                //       dataOptions[value]['bo_title']
                //     ),
                //   ),
                // );
              }),

              // HintTextNoAnim(
              //   text: "${game.users.first.name} ${bet.title}",
              //   color: HColors.four,
              //   fontSize: 30,
              //   textAlign: TextAlign.center,
              // ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WForm(
                    width: 200,
                    textFontSize: 50,
                    maxLength: 10,
                    hintText: '10',
                    controller: add,
                    onlyNumbers: true,
                    onChanged: (value) {
                      canLoad.value = validateInputs();
                      canLoad.notifyListeners();
                    },
                  ),

                  ValueListenableBuilder(valueListenable: canLoad, builder: (context, valueLoad, childLoad) {
                    return ValueListenableBuilder(valueListenable: valid, builder: (context, value, child) {
                      return RichText(
                        text:
                          TextSpan(children: [
                            TextSpan(
                              text: 'x',
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 40,
                              ),
                            ),
                            TextSpan(
                              text: value ? dataOptions[selected.value]['odd_win'].toString() : dataOptions[selected.value]['odd_lose'].toString(),
                              style: TextStyle(
                                color: HColors.five,
                                fontFamily: 'Jersey',
                                fontSize: 50,
                              )
                            ),
                            TextSpan(
                              text: ' = ',
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 50,
                              )
                            ),
                            TextSpan(
                              text: add.text == "" ? "0" : formatSmartClean((value ? dataOptions[selected.value]['odd_win'] : dataOptions[selected.value]['odd_lose']) * double.parse(add.text)),
                              style: TextStyle(
                                color: HColors.prim,
                                fontFamily: 'Jersey',
                                fontSize: 50,
                              )
                            ),
                            TextSpan(
                              text: 'Po',
                              style: TextStyle(
                                color: HColors.third,
                                fontFamily: 'Jersey',
                                fontSize: 40,
                              )
                            ),
                          ]
                        )
                      );
                    });
                  })
              ],),


              ValueListenableBuilder(valueListenable: valid, builder: (context, value, child) {
                return Row(
                  spacing: 20,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WTextButton(
                      key: UniqueKey(),
                      text: "Oui",
                      fontSize: 28,
                      horizontal: 30,
                      vertical: 15,
                      colorBox: HColors.sec,
                      filled: value,
                      colorText: value ? HColors.back : HColors.four,
                      onTap: () {
                        setValid(true);
                      }
                    ).applyIf(value, (child) => child.roulette(spins: 1)),

                    WTextButton(
                      key: UniqueKey(),
                      text: "Non",
                      fontSize: 28,
                      horizontal: 30,
                      vertical: 15,
                      colorBox: HColors.five,
                      filled: !value,
                      onTap: () {
                        setValid(false);
                      }
                    ).applyIf(!value, (child) => child.roulette(spins: 1)),
                  ],
                );
              }),
              
              ValueListenableBuilder(valueListenable: canLoad, builder: (context, value, child) {
                return 
                ValueListenableBuilder(valueListenable: canRequest, builder: (context, valueReq, child) {
                  return WTextButton(
                    text: "make_bet_short".tr,
                    fontSize: 28,
                    horizontal: 100,
                    vertical: 15,
                    onTap: value ? () {
                      onSubmit(context);
                    } : null
                  );
                });
              }),
            ],
          ),
      ),
    );
  }
  
}

extension WidgetModifier on Widget {
  Widget applyIf(bool condition, Widget Function(Widget) transformer) {
    return condition ? transformer(this) : this;
  }
}