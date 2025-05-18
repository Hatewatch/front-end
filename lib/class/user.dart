import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hate_watch/api/api.dart';
import 'package:hate_watch/api/data.dart';
import 'package:hate_watch/class/bet.dart';
import 'package:hate_watch/class/prop.dart';
import 'package:hate_watch/utils/localization.dart';

class User with ChangeNotifier {

  static User instance = User();

  ValueNotifier<User?> notif = ValueNotifier(null);

  String? pseudo = "guest".tr;
  int id = 0;
  double balance = 0;
  String token = "";
  int totalBets = 0;
  int totalWins = 0;
  double? lastBetGainOrLoss;
  DateTime creation = DateTime.now();
  String role = "none";

  DateTime? dateDaily;

  ValueNotifier<List<int>> timeNextDaily = ValueNotifier([0,0]);

  dynamic dataBets;
  List<Prop> props = [];
  List<Bet> betsUser = [];
  List<Bet> betsAllWeb = [];

  Timer? timer;

  bool loadedBets = false;

  void init() async {
    notif.value = User.instance;
    notif.notifyListeners();
    
    getAllProps();
    getAllBetsWeb();
    initUser();

    timer = Timer.periodic(
      Duration(seconds: 1), 
      (timer) {
        getTimeBeforeNextDaily();
      }
    );
  }

  Future reset() async {
    pseudo = "guest".tr;
    id = 0;
    balance = 0;
    token = "";
    role = "none";
    totalBets = 0;
    totalWins = 0;
    lastBetGainOrLoss = null;
    timeNextDaily.value = [0,0];
    dateDaily = null;
    betsUser.clear();

    setToken("");

    notify();
  }

  Future getAllProps() async {
    var rep = await getCallHw("api/proposals/getAll");

    props.clear();

    if (rep is List) {
      for (int i = 0; i < rep.length; i++) {
        props.add(
          Prop.fromJson(rep[i])
        );
      }
    }

    loadedBets = true;
    notify();

    // print(rep);
    // print(bets);
  }

  Future getAllBetsWeb() async {
    var rep = await getCallHw("api/bets/last");
    
    print(rep);
  }

  Future getBetsUser() async {
    if (token.isEmpty) return;

    var rep = await getCallHw("api/users/getBets");

    betsUser.clear();

    // print(rep);

    if (rep is List) {
      for (int i = 0; i < rep.length; i++) {
        betsUser.add(
          Bet.fromJson(rep[i])
        );
      }
    }

    betsUser = betsUser.reversed.toList();
    loadedBets = true;
    notify();

    // print(rep);
    // print(bets);
  }

  Future setToken(String newToken) async { 
    token = newToken; 
    saveData('user', jsonEncode(token));
  }
  String getToken() { return token; }

  Future loadToken() async {
    dynamic load = getData('user');

    if (load == null) return;

    setToken(await jsonDecode(load));
  }

  Future initUser() async {
    await loadToken();

    if (token.isEmpty) return;

    await getInfosUser();
    await getBetsUser();
  }

  void notify() {
    notif.value = User.instance;
    notif.notifyListeners();
  }

  bool isConnected() { return id != 0; }

  Future getAllInfosUser() async {
    await getInfosUser();
    await getBetsUser();
    await getAllProps();
  }

  Future getInfosUser() async {
    var rep = await getCallHw("api/users/profile");

    // print(rep);

    if (rep is Map && rep.containsKey('username')) {
      id = rep['id'];
      balance = double.parse(rep['balance']);
      pseudo = rep['username'];
      role = rep['role'];
      totalBets = rep['totalBets'];
      totalWins = int.parse(rep['totalWins']);
      creation = DateTime.parse(rep['creation']);
      dateDaily = rep['daily_time'] == null ? DateTime.now().subtract(Duration(days: 2)) : DateTime.parse(rep['daily_time']);
      if (rep['lastBetGainOrLoss'] != 'No Bet') lastBetGainOrLoss = double.parse(rep['lastBetGainOrLoss']);
    }

    getTimeBeforeNextDaily();

    notif.value = User.instance;
    notif.notifyListeners();

  }

  Future<dynamic> claimDaily() async {
    var rep = await postCallApiBody("api/users/dailyReward", {});

    // print(rep);

    getInfosUser();

    return rep;
  }

  String getTimeBeforeNextDaily() {

    if (dateDaily == null) return "";

    DateTime dateDaily2 = dateDaily!.add(Duration(days: 1));
    DateTime now = DateTime.now();

    Duration diff = dateDaily2.difference(now);

    int hours = diff.inHours;
    int minutes = diff.inMinutes.remainder(60);

    // print("Temps restant : $hours h $minutes min");
    // print(dateDaily2);
    // print(dateDaily);

    timeNextDaily.value[0] = hours;
    timeNextDaily.value[1] = minutes;

    if(hours == 0 && minutes == 0) {
      timer!.cancel();
    }

    timeNextDaily.notifyListeners();

    return getStringDaily();
  }

  void activateTimer() {
    timer = Timer.periodic(
      Duration(seconds: 1), 
      (timer) {
        getTimeBeforeNextDaily();
      }
    );
  }

  String getStringDaily() {
    if (dateDaily == null) return '';

    String time = "";
    

    if (timeNextDaily.value[0] != 0) time += "${timeNextDaily.value[0]}h";
    if (timeNextDaily.value[1] != 0) time += "${timeNextDaily.value[1]}m";

    if (timeNextDaily.value[0] <= 0 && timeNextDaily.value[1] <= 0) {
      time = "NOW";
    }


    return time;
  }

  bool isNowDaily() {
    if (dateDaily == null) return false;

    DateTime dateDaily2 = dateDaily!.add(Duration(days: 1));
    DateTime now = DateTime.now();

    Duration diff = dateDaily2.difference(now);

    int hours = diff.inHours;
    int minutes = diff.inMinutes.remainder(60);

    // print(hours <= 0);
    // print(minutes <= 0);
    // print(hours <= 0 && minutes <= 0);

    return hours <= 0 && minutes <= 0;
  }

}