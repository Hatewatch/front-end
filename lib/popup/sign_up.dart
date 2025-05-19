import 'package:alert_info/alert_info.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/general/key.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget with ChangeNotifier {
  SignUp({super.key});

  final TextEditingController pseudoCont = TextEditingController();
  final TextEditingController mdpCont = TextEditingController();

  final ValueNotifier<bool> obscure = ValueNotifier(true);

  final ValueNotifier<bool> canLoad = ValueNotifier(false);

  final FocusNode focusName = FocusNode();
  final FocusNode focusMdp = FocusNode();

  bool validateInputs() {
    return pseudoCont.text.isNotEmpty && mdpCont.text.isNotEmpty;
  }

  bool firstFrame = true;

  Future onSubmit(BuildContext context) async {

    try {
      String hash = BCrypt.hashpw(
        mdpCont.text,
        hkey);


      var rep = await postCallApiBody(
        "api/auth/register",
        {
          'username': pseudoCont.text,
          'password': hash,
          'balance' : 50,
        }
      );

      // print(rep);

      if (rep is Map && rep.containsKey("token")) {
        
        User.instance.setToken(rep["token"]);
        User.instance.getInfosUser();
        AlertInfo.show(
          // ignore: use_build_context_synchronously
          context: context,
          text: 'creation_account_success'.tr,
          
          typeInfo: TypeInfo.success,
          position: MessagePosition.top,
          action: null,
        );
        // ignore: use_build_context_synchronously
        Navigator.maybePop(context);


      } else if (rep is Map && rep.containsKey("message")) {
        String reason = "";

        switch(rep["message"]) {
          case 'Invalid credentials':
            reason = 'invalid_credentials'.tr;
            break;
        }

        AlertInfo.show(
          // ignore: use_build_context_synchronously
          context: context,
          text: reason,
          
          typeInfo: TypeInfo.error,
          position: MessagePosition.top,
          action: null,
        );
      }
    } 
    catch (e) {
      AlertInfo.show(
        // ignore: use_build_context_synchronously
        context: context,
        text: 'creation_account_error'.tr,
        
        typeInfo: TypeInfo.error,
        position: MessagePosition.top,
        action: null,
      );
    }


  }

  @override
  Widget build(BuildContext context) {

    if (firstFrame) {
      focusName.requestFocus();
      firstFrame = false;
    }

    double fontSize = 26;

    if (MediaQuery.sizeOf(context).width < 600) {
      fontSize = 20;
    }

    return 
    SizedBox(
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
              HTitle(end: "create_account".tr,),
              
              HintText(text: 'creation_account_title'.tr),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WForm(
                    textFontSize: fontSize+2,
                    fontSizeTitle: fontSize,
                    title: "username".tr, 
                    controller: pseudoCont,
                    focus: focusName,
                    onSubmit: (value) {
                      focusName.unfocus();
                      focusMdp.requestFocus();
                    },
                    onChanged: (value) {
                      canLoad.value = validateInputs();
                      canLoad.notifyListeners();
                    },
                  ),

                  WFormMdp(
                    fontSizeTitle: fontSize,
                    fontSizeHint: fontSize+2,
                    title: 'password'.tr, 
                    focus: focusMdp,
                    controller: mdpCont,
                    onChanged: (value) {
                      canLoad.value = validateInputs();
                      canLoad.notifyListeners();
                    },
                  ),
              ],),

              ValueListenableBuilder(valueListenable: canLoad, builder: (context, value, child) {
                return WTextButton(
                  text: 'create_account'.tr,
                  fontSize: 28,
                  horizontal: 60,
                  vertical: 15,
                  onTap: value ? () {
                    onSubmit(context);
                  } : null,
                  activated: value,
                );
              }),
            ],
          ),
      ),
    );
  }

}