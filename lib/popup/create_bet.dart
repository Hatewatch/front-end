import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

// ignore: must_be_immutable
class CreateBet extends StatelessWidget with ChangeNotifier {
  CreateBet({super.key});

  final TextEditingController person = TextEditingController();
  final TextEditingController desc = TextEditingController();

  final ValueNotifier<bool> canCreate = ValueNotifier(false);

  bool validateInputs() {
    return person.text.isNotEmpty && desc.text.isNotEmpty;
  }

  Future onSubmit(BuildContext context) async {

    // var rep = await postCallApi(
    //   'api/bets/bet',
    //   {

    //   }
    // );

    //print(rep);

    User.instance.getAllProps();
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
            spacing: 20,
            children: 
            [
              HTitle(end: 'create_bet'.tr,),
              
              HintText(text: 'new_bet_title'.tr),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                WForm(
                  title: 'bet_username_target'.tr, 
                  controller: person,
                  onChanged: (value) {
                    canCreate.value = validateInputs();
                    canCreate.notifyListeners();
                  },
                ),

                WForm(
                  title: "condition".tr,
                  controller: desc,
                  hintText: 'new_bet_hint'.tr,
                  maxLength: 200,
                  maxLines: null,
                  onChanged: (value) {
                    canCreate.value = validateInputs();
                    canCreate.notifyListeners();
                  },
                ),
              ],),

              ValueListenableBuilder(valueListenable: canCreate, builder: (context, value, child) {
                return WTextButton(
                  text: 'create_the_bet'.tr,
                  fontSize: 28,
                  horizontal: 60,
                  vertical: 15,
                  onTap: value ? () {

                  } : null
                );
              })
              

            ],
          ),
      ),
    );
  }
  
}