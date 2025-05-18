import 'package:flutter/material.dart';
import 'package:hate_watch/api/data.dart';

class App with ChangeNotifier {

  static App instance = App();
  ValueNotifier<App?> notif = ValueNotifier(null);

  

  bool doneTutorial = false;

  void init() {
    hasDoneTutorial();
  }

  bool hasDoneTutorial() {
    String? rep = getData('tutorial');

    if (rep == null) {
      saveData('tutorial', false.toString());
      rep = getData('tutorial');
    }

    doneTutorial = bool.parse(rep!);

    return doneTutorial;
  }  

  void tutorialDone() {
    saveData('tutorial', true.toString());

    notify();
  }

  void notify() {
    notif.value = instance;
    notif.notifyListeners();
  }

}