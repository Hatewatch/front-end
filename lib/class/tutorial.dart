

import 'package:hate_watch/api/data.dart';

class Tutorial {

  bool alreadyDid = false;

  void setDid() {
    saveData('tutorial', true.toString());
  }

  void loadDid() {
    var data = getData('tutorial');

    if (data == null) return;

    alreadyDid = bool.parse(data);
  }

  void init() {
    loadDid();
  }

}