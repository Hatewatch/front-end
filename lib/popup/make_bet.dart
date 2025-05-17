import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/prop.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

// ignore: must_be_immutable
class MakeBet extends StatelessWidget with ChangeNotifier {
  MakeBet({super.key, required this.bet});

  final ValueNotifier<bool> canLoad = ValueNotifier(true);
  final ValueNotifier<bool> valid = ValueNotifier(true);

  final TextEditingController add = TextEditingController(text: "10");

  final Prop bet;

  final ValueNotifier<bool> canRequest = ValueNotifier(true);

  bool validateInputs() {
    return add.text.isNotEmpty;
  }

  Future onSubmit(BuildContext context) async {
    //print("Submit");

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
      'api/bets/bet', 
      {
        'proposalId' : bet.id,
        'betAmount' : double.parse(add.text),
      }
    );

    // print(rep);

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

  @override
  Widget build(BuildContext context) {
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

              HintTextNoAnim(
                text: "${bet.player} ${bet.title}",
                color: HColors.four,
                fontSize: 30,
                textAlign: TextAlign.center,
              ),

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

                  ValueListenableBuilder(valueListenable: canLoad, builder: (context, value, child) {
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
                            text: bet.odds.toString(),
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
                            text: add.text == "" ? "0" : (bet.odds * double.parse(add.text)).toString(),
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
                  })
              ],),


              // ValueListenableBuilder(valueListenable: valid, builder: (context, value, child) {
              //   return Row(
              //     spacing: 20,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       WTextButton(
              //         key: UniqueKey(),
              //         text: "Oui",
              //         fontSize: 28,
              //         horizontal: 30,
              //         vertical: 15,
              //         colorBox: HColors.sec,
              //         filled: value,
              //         colorText: value ? HColors.back : HColors.four,
              //         onTap: () {
              //           setValid(true);
              //         }
              //       ).applyIf(value, (child) => child.roulette(spins: 1)),

              //       WTextButton(
              //         key: UniqueKey(),
              //         text: "Non",
              //         fontSize: 28,
              //         horizontal: 30,
              //         vertical: 15,
              //         colorBox: HColors.five,
              //         filled: !value,
              //         onTap: () {
              //           setValid(false);
              //         }
              //       ).applyIf(!value, (child) => child.roulette(spins: 1)),
              //     ],
              //   );
              // }),
              
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