import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';
import 'package:flutter_popup/flutter_popup.dart';
// import 'package:pixelarticons/pixel.dart';

// ignore: must_be_immutable
class CreateProp extends StatelessWidget with ChangeNotifier {
  CreateProp({super.key});

  final TextEditingController person = TextEditingController();
  final TextEditingController champ = TextEditingController();
  final TextEditingController desc = TextEditingController();
  // final TextEditingController odd = TextEditingController();

  final FocusNode personFocus = FocusNode();
  final FocusNode champFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  // final FocusNode oddFocus = FocusNode();

  bool firstFrame = true;

  final ValueNotifier<bool> canCreate = ValueNotifier(false);

  bool validateInputs() {
    return person.text.isNotEmpty && desc.text.isNotEmpty && champ.text.isNotEmpty;
  }

  Future onSubmit(BuildContext context) async {

    var rep = await postCallApiBody(
      'api/proposals/create',
      {
        'prop_player' : person.text.toUpperCase(),
        'prop_title' : desc.text,
        //'prop_odds' : double.parse(odd.text),
        'prop_champion' : champ.text,
      }
    );

    print(rep);

    if (rep is Map && rep.containsKey("message")){
      switch (rep['message']) {
        case 'Proposal created':
          AlertInfo.show(
            // ignore: use_build_context_synchronously
            context: context,
            text: 'create_bet_success'.tr,
            
            typeInfo: TypeInfo.success,
            position: MessagePosition.top,
            action: null,
          );
          break;
        default:
          AlertInfo.show(
            // ignore: use_build_context_synchronously
            context: context,
            text: 'create_bet_error'.tr,
            
            typeInfo: TypeInfo.error,
            position: MessagePosition.top,
            action: null,
          );
          break;
          
      }
    }

    User.instance.getAllProps();
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {

    if (firstFrame) {
      personFocus.requestFocus();
      firstFrame = false;
    }

    double fontSize = 26;
    bool resized = false;

    if (MediaQuery.sizeOf(context).width < 600) {
      fontSize = 18;
      resized = true;
    }


    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: 
      Padding(
        padding: EdgeInsets.all(20),
        child:
          SingleChildScrollView(
            child: 
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: fontSize - 6,
              children: 
              [
                HTitle(end: 'create_bet'.tr,),
                
                HintText(
                  text: 'new_bet_title'.tr,
                  fontSize: fontSize-6,
                ),

                

                // WTextButton(
                //   text: 'Presets',
                //   onTap: () {
                    
                //   },
                // ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  WForm(
                    height: resized ? 60 : null,
                    fontSizeTitle: fontSize,
                    textFontSize: fontSize+2,
                    focus: personFocus,
                    title: 'bet_username_target'.tr, 
                    controller: person,
                    onChanged: (value) {
                      canCreate.value = validateInputs();
                      canCreate.notifyListeners();
                    },
                    onSubmit: (value) {
                      champFocus.requestFocus();
                    },
                  ),

                  WForm(
                    height: resized ? 60 : null,
                    fontSizeTitle: fontSize,
                    textFontSize: fontSize+2,
                    focus: champFocus,
                    title: 'create_bet_champ'.tr, 
                    controller: champ,
                    onChanged: (value) {
                      canCreate.value = validateInputs();
                      canCreate.notifyListeners();
                    },
                    onSubmit: (value) {
                      descFocus.requestFocus();
                    },
                  ),

                  CustomPopup(
                  backgroundColor: HColors.up,
                  content: 
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: 
                      [
                        GestureDetector(
                          onTap: () {
                            desc.text = "Gagne sa game";
                            //odd.text = "2";
                            canCreate.value = validateInputs();
                            canCreate.notifyListeners();
                          },
                          child: Text("Gagne sa game"),
                        ),
                        GestureDetector(
                          onTap: () {
                            desc.text = "Perd sa game";
                            //odd.text = "2";
                            canCreate.value = validateInputs();
                            canCreate.notifyListeners();
                          },
                          child: Text("Perd sa game"),
                        ),
                      ],
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: HColors.third
                      ),
                      borderRadius: HBorder.borderRadius,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10, 
                        vertical: 5
                      ),
                      child: 
                        Text("Presets", style: TextStyle(fontSize: fontSize),),
                    ),
                  ),
                ),

                WForm(
                    fontSizeTitle: fontSize,
                    textFontSize: fontSize+2,
                    focus: descFocus,
                    title: "condition".tr,
                    controller: desc,
                    hintText: 'new_bet_hint'.tr,
                    maxLength: 200,
                    maxLines: null,
                    onChanged: (value) {
                      canCreate.value = validateInputs();
                      canCreate.notifyListeners();
                    },
                    // onSubmit: (value) {
                    //   oddFocus.requestFocus();
                    // },
                  ),
                ],),

                // WForm(
                //   height: resized ? 70 : null,
                //   fontSizeTitle: fontSize,
                //   textFontSize: fontSize+15,
                //   focus: oddFocus,
                //   title: 'create_bet_odd'.tr,
                //   width: 200,
                //   //textFontSize: 50,
                //   maxLength: 4,
                //   hintText: '1.0',
                //   controller: odd,
                //   onlyNumbers: true,
                //   onChanged: (value) {
                //     canCreate.value = validateInputs();
                //     canCreate.notifyListeners();
                //     //print(canCreate.value);
                //   },
                // ),

                ValueListenableBuilder(valueListenable: canCreate, builder: (context, value, child) {
                  return WTextButton(
                    text: 'create_the_bet'.tr,
                    fontSize: 28,
                    horizontal: 60,
                    vertical: 15,
                    onTap: value ? () {
                      onSubmit(context);
                    } : null,
                    activated: value,
                  );
                })
                

              ],
            ),
        ),
      )
    );
  }
  
}