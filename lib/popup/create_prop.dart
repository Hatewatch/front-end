import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

// ignore: must_be_immutable
class CreateProp extends StatelessWidget with ChangeNotifier {
  CreateProp({super.key});

  final TextEditingController person = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController odd = TextEditingController();

  final FocusNode personFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode oddFocus = FocusNode();

  bool firstFrame = true;

  final ValueNotifier<bool> canCreate = ValueNotifier(false);

  bool validateInputs() {
    return person.text.isNotEmpty && desc.text.isNotEmpty && odd.text.isNotEmpty;
  }

  Future onSubmit(BuildContext context) async {

    var rep = await postCallApiBody(
      'api/proposals/create',
      {
        'prop_player' : person.text.toUpperCase(),
        'prop_title' : desc.text,
        'prop_odds' : double.parse(odd.text),
      }
    );

    print(rep);

    if (rep is Map && rep.containsKey("message")){
      switch (rep['message']) {
        case 'Proposal created':
          AlertInfo.show(
            // ignore: use_build_context_synchronously
            context: context,
            text: 'edit_prop_close_success'.tr,
            
            typeInfo: TypeInfo.success,
            position: MessagePosition.top,
            action: null,
          );
          break;
        default:
          AlertInfo.show(
            // ignore: use_build_context_synchronously
            context: context,
            text: 'edit_prop_close_error'.tr,
            
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

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: 
      Padding(
        padding: EdgeInsets.all(20),
        child:
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: 
            [
              HTitle(end: 'create_bet'.tr,),
              
              HintText(text: 'new_bet_title'.tr),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                WForm(
                  focus: personFocus,
                  title: 'bet_username_target'.tr, 
                  controller: person,
                  onChanged: (value) {
                    canCreate.value = validateInputs();
                    canCreate.notifyListeners();
                  },
                  onSubmit: (value) {
                    descFocus.requestFocus();
                  },
                ),

                WForm(
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
                  onSubmit: (value) {
                    oddFocus.requestFocus();
                  },
                ),
              ],),

              WForm(
                focus: oddFocus,
                title: 'create_bet_odd'.tr,
                width: 200,
                textFontSize: 50,
                maxLength: 4,
                hintText: '1.0',
                controller: odd,
                onlyNumbers: true,
                onChanged: (value) {
                  canCreate.value = validateInputs();
                  canCreate.notifyListeners();
                  //print(canCreate.value);
                },
              ),

              ValueListenableBuilder(valueListenable: canCreate, builder: (context, value, child) {
                return WTextButton(
                  text: 'create_the_bet'.tr,
                  fontSize: 28,
                  horizontal: 60,
                  vertical: 15,
                  onTap: value ? () {
                    onSubmit(context);
                  } : null
                );
              })
              

            ],
          ),
      ),
    );
  }
  
}