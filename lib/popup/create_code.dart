import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/form.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/hradius.dart';
import 'package:hate_watch/utils/loading.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

// ignore: must_be_immutable
class CreateCode extends StatelessWidget with ChangeNotifier {
  CreateCode({super.key});

  final TextEditingController codeCont = TextEditingController();
  final TextEditingController amountCont = TextEditingController();

  final FocusNode focusCode = FocusNode();
  final FocusNode focusAmount = FocusNode();


  final ValueNotifier<bool> canLoad = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final GlobalKey keyButton = GlobalKey();

  bool firstFrame = true;

  bool validateInputs() {
    return codeCont.text.isNotEmpty && amountCont.text.isNotEmpty;
  }

  Future onSubmit(BuildContext context) async {

    try {
    
      isLoading.value = true;
      isLoading.notifyListeners();

      var rep = await postCallApiBody(
        "api/codes/add",
        {
          'code_string': codeCont.text,
          'code_reward' : double.parse(amountCont.text),
        }
      );

      print(rep);

      if (rep is Map && rep.containsKey("message")) {
        
        switch(rep["message"]) {
          
          case 'Code added successfully.':
            AlertInfo.show(
              // ignore: use_build_context_synchronously
              context: context,
              text: 'create_code_success'.tr,
              
              typeInfo: TypeInfo.success,
              position: MessagePosition.top,
              action: null,
            );
            // ignore: use_build_context_synchronously
            Navigator.maybePop(context);
            break;
          case 'Code already exists.':
            AlertInfo.show(
              // ignore: use_build_context_synchronously
              context: context,
              text: 'create_code_already'.tr,
              
              typeInfo: TypeInfo.error,
              position: MessagePosition.top,
              action: null,
            );
            break;

          default:
            AlertInfo.show(
              // ignore: use_build_context_synchronously
              context: context,
              text: 'create_code_error'.tr,
              
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
              HTitle(end: 'create_code'.tr,),
              
              HintText(text: 'create_code_hint'.tr),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                WForm(
                  title: 'create_code_code'.tr, 
                  hintText: 'code',
                  controller: codeCont,
                  focus: focusCode,
                  onSubmit: (value) {
                    focusAmount.requestFocus();
                  },
                  onChanged: (value) {
                    canLoad.value = validateInputs();
                    canLoad.notifyListeners();
                  },
                ),

                SizedBox(
                  width: 200,
                  child:  
                  WForm(
                    title: 'create_code_amount'.tr, 
                    hintText: '1.0',
                    maxLength: 5,
                    controller: amountCont,
                    focus: focusAmount,
                    onlyNumbers: true,
                    onSubmit: (value) {
                      onSubmit(context);
                    },
                    onChanged: (value) {
                      canLoad.value = validateInputs();
                      canLoad.notifyListeners();
                    },
                  ),
                )
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
                      text: 'create_code'.tr,
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