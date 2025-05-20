import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/loading.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

// ignore: must_be_immutable
class CreateRiotAccountLink extends StatelessWidget with ChangeNotifier {
  CreateRiotAccountLink({super.key});

  final TextEditingController nameCont = TextEditingController();

  final FocusNode focusCode = FocusNode();


  final ValueNotifier<bool> canLoad = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final GlobalKey keyButton = GlobalKey();

  bool firstFrame = true;

  bool validateInputs() {
    return nameCont.text.isNotEmpty;
  }

  Future onSubmit(BuildContext context) async {

    try {
    
      isLoading.value = true;
      isLoading.notifyListeners();

      List<String> strings = nameCont.text.split("#");

      if (strings.length <= 1) {
        AlertInfo.show(
          // ignore: use_build_context_synchronously
          context: context,
          text: 'create_riot_not_valid'.tr,
          
          typeInfo: TypeInfo.error,
          position: MessagePosition.top,
          action: null,
        );
        return;
      }

      var rep = await postCallApiBody(
        "api/riot/create",
        {
          'name': strings[0],
          'tagline' : strings[1],
        }
      );

      print(rep);

      if (rep is Map && rep.containsKey("message")) {
        
        switch(rep["message"]) {
          case 'Riot data created successfully':
            AlertInfo.show(
              // ignore: use_build_context_synchronously
              context: context,
              text: 'create_riot_success'.tr,
              
              typeInfo: TypeInfo.success,
              position: MessagePosition.top,
              action: null,
            );
            User.instance.getInfosUser();
            // ignore: use_build_context_synchronously
            Navigator.maybePop(context);
            break;
          default:
            AlertInfo.show(
              // ignore: use_build_context_synchronously
              context: context,
              text: 'create_riot_error'.tr,
              
              typeInfo: TypeInfo.error,
              position: MessagePosition.top,
              action: null,
            );
            break;
        }
      } 
    }
    // ignore: empty_catches
    catch (e) {
    }

    isLoading.value = false;
    isLoading.notifyListeners();

  }

  @override
  Widget build(BuildContext context) {

    if (firstFrame) {
      focusCode.requestFocus();
      firstFrame = false;
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
              HTitle(end: 'create_riot'.tr,),
              
              HintText(text: 'create_riot_hint'.tr),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                WForm(
                  title: 'create_riot_field'.tr, 
                  hintText: 'Jon#EUW',
                  controller: nameCont,
                  focus: focusCode,
                  onSubmit: (value) {
                    onSubmit(context);
                  },
                  onChanged: (value) {
                    canLoad.value = validateInputs();
                    canLoad.notifyListeners();
                  },
                ),
              ],),

              ValueListenableBuilder(valueListenable: canLoad, builder: (context, value, child) {
                return
                  ValueListenableBuilder(valueListenable: isLoading, builder: (context, loading, child) {
                    Size size = Size.zero;
                    RenderBox? box = keyButton.currentContext?.findRenderObject() as RenderBox?;
                    if (box != null) {
                      size = box.size;
                    }
                    
                    return loading ?
                    Loading(size: size)
                    : WTextButton(
                      key: keyButton,
                      text: 'create_riot'.tr,
                      fontSize: 28,
                      horizontal: 60,
                      vertical: 15,
                      onTap: value ? () {
                        onSubmit(context);
                      } : null,
                      activated: value,
                    );
                });
              }),
            ],
          ),
      ),
    );
  }

}