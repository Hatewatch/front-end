

import 'package:alert_info/alert_info.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/class/prop.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

// ignore: must_be_immutable
class EditProp extends StatelessWidget with ChangeNotifier {
  EditProp({super.key, required this.prop});

  final Prop prop;

  final ValueNotifier<bool> win = ValueNotifier(true);

  Future onSubmitClose(BuildContext context) async {

    // TODO : call fermer pari

  }

  Future onSubmitEnd(BuildContext context) async {

    // TODO : call end pari

    var rep = await postCallApiBody('api/proposals/finish', 
      {
        'proposalId' : prop.id,
        'result' : win.value ? 'WIN' : 'LOSE',   
      }
    );

    if (rep is Map && rep.containsKey("message")){
      switch (rep['message']) {
        case 'Proposal finished and payouts processed':
          AlertInfo.show(
            // ignore: use_build_context_synchronously
            context: context,
            text: 'edit_prop_end_success'.tr,
            
            typeInfo: TypeInfo.success,
            position: MessagePosition.top,
            action: null,
          );
          break;
        default:
          AlertInfo.show(
            // ignore: use_build_context_synchronously
            context: context,
            text: 'edit_prop_end_error'.tr,
            
            typeInfo: TypeInfo.error,
            position: MessagePosition.top,
            action: null,
          );
          break;
          
      }
    }

    // print(rep);
    User.instance.getAllProps();
    User.instance.getBetsUser();
    Navigator.maybePop(context);
  }

  void setWin(bool value) {
    win.value = value;
    win.notifyListeners();
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
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: 
            [
              HTitle(end: 'edit_prop'.tr,),
              
              HintText(text: 'edit_prop_hint'.tr),

              SizedBox(height: 20,),

              WTextButton(
                text: 'edit_prop_close'.tr,
                fontSize: 28,
                horizontal: 60,
                vertical: 15,
                onTap: () {
                  onSubmitClose(context);
                }
              ),

              ValueListenableBuilder(valueListenable: win, builder: (context, value, child) {
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
                        setWin(true);
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
                        setWin(false);
                      }
                    ).applyIf(!value, (child) => child.roulette(spins: 1)),
                  ],
                );
              }),

              WTextButton(
                text: 'edit_prop_end'.tr,
                fontSize: 28,
                horizontal: 60,
                vertical: 15,
                onTap: () {
                  onSubmitEnd(context);
                }
              ),
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