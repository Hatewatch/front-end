import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hate_watch/class/app.dart';
import 'package:hate_watch/utils/localization.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Tutorial {

  static late TutorialCoachMark tutorialCoachMark;
  static final List<TargetFocus> targets = [];

  static bool doing = false;

  static void showWelcome(
    BuildContext context,
    GlobalKey keyHello,
    GlobalKey keyStats,
    GlobalKey keyPari,
  ) 
  {
    if (doing) return;
    print(doing);
    print("DO");

    doing = true;

    targets.clear();

    List<String> trads = [
      'dialog_start'.tr,
      'dialog_1'.tr,
      'dialog_2'.tr
    ];

    for (int i = 0; i < trads.length; i++) {
      targets.add(
        TargetFocus(
          identify: trads[i],
          targetPosition: TargetPosition(Size(10,10), Offset(MediaQuery.sizeOf(context).width*0.5, MediaQuery.sizeOf(context).height*0.5)),
          contents: [
            // TargetContent(
            //   align: ContentAlign.bottom,
            //   padding: EdgeInsets.only(top: 100),
            //   builder: (context, controller) {
            //     return 
            //     Image.asset(
            //       "hw.png",
            //       width: 150,
            //       height: 150,
            //     );
            //   }
            // ),
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    trads[i],
                    style: TextStyle(color: Colors.white, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            )
          ],
        ),
      );
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      hideSkip: true,
      colorShadow: Colors.black,
      textStyleSkip: TextStyle(fontSize: 45),
      onFinish: () {
        doing = false;
        App.instance.tutorialDone();
        showTutorial(context, keyHello, keyStats, keyPari);
      },
    )..show(context:context);
  }

  static void showTutorial(
    BuildContext context,
    GlobalKey keyHello,
    GlobalKey keyStats,
    GlobalKey keyPari,
  ) 
  {
    if (doing) return;

    doing = true;

    targets.clear();

    targets.add(
      TargetFocus(
        identify: "intro",
        targetPosition: TargetPosition(Size(10,10), Offset(MediaQuery.sizeOf(context).width*0.5, MediaQuery.sizeOf(context).height*0.5)),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'intro_start'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "hello",
        keyTarget: keyHello,
        // targetPosition: TargetPosition(Size(100,100),Offset(100, 10)),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            builder: (context, controller) {
              return Text(
                "intro_1".tr,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            },
          ),
        ]
      )
    );

    targets.add(
      TargetFocus(
        identify: "stats",
        keyTarget: keyStats,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            builder: (context, controller) {
              return 
              Text(
                "intro_3".tr,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            },
          ),
        ]
      )
    );

    Offset pos = Offset.zero;
    RenderBox? box = keyPari.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      pos = box.localToGlobal(Offset.zero);
      pos = pos + Offset(200/2,-80);
    }

    targets.add(
      TargetFocus(
        identify: "pari",
        targetPosition: TargetPosition(Size(300,300), pos),
        keyTarget: pos == Offset.zero ? keyPari : null,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            builder: (context, controller) {
              return 
              Text(
                'intro_4'.tr,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            },
          ),
        ]
      )
    );

    targets.add(
      TargetFocus(
        identify: "end",
        targetPosition: TargetPosition(Size(10,10), Offset(MediaQuery.sizeOf(context).width*0.5, MediaQuery.sizeOf(context).height*0.5)),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'intro_end'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              );
            },
          )
        ],
      ),
    );

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      textSkip: "SKIP TUTORIAL",
      colorShadow: Colors.black,
      textStyleSkip: TextStyle(fontSize: 45),
      onFinish: () {
        doing = false;
      },
    )..show(context:context);
  }

}