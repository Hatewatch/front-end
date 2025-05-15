import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:hate_watch/class/user.dart';
import 'package:hate_watch/utils/buttons.dart';
import 'package:hate_watch/utils/hcolors.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:hate_watch/utils/text.dart';
import 'package:hate_watch/utils/title.dart';

class Disconnect extends StatelessWidget {
  const Disconnect({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: 500,
      child: 
      Padding(
        padding: EdgeInsets.all(20),
        child: 
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 40,
            children: [
              HTitle(start: "disconnect".tr,),

              HintText(
                text: "disconnect_title".tr,
              ),

              WTextButton(
                text: "Se déconnecter",
                horizontal: 50,
                vertical: 15,
                colorBox: HColors.five,
                onTap: () async {
                  await User.instance.reset();
                  AlertInfo.show(
                    // ignore: use_build_context_synchronously
                    context: context,
                    text: "disconnect_success".tr,
                    typeInfo: TypeInfo.success,
                    position: MessagePosition.top,
                    action: null,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              )
            ],
          ),
      ),
    );
  }
  
}