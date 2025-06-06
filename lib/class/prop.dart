
import 'package:hate_watch/class/bet.dart';
import 'package:hate_watch/class/user.dart';

class Prop {

  Prop({
    required this.id,
    required this.oddsWin,
    required this.oddsLose,
    required this.player,
    required this.title,
    required this.timeCreation,
    required this.state,
    required this.total,
    required this.totalUsers,
    required this.champ,
    required this.epoch,
  });

  factory Prop.fromJson(Map<String, dynamic> json) {
    return Prop(
      id: json['prop_id'] as int,
      oddsWin: double.parse(json['prop_odds_win']),
      oddsLose: double.parse(json['prop_odds_lose']),
      player: json['prop_player'] as String,
      title: json['prop_title'] as String,
      timeCreation: DateTime.parse(json['prop_creation']),
      total: double.parse(json['prop_total_amount']),
      state: json['prop_state'],
      totalUsers: json['prop_nbPeople'],
      champ: json['prop_champion'],
      epoch: json.containsKey('prop_matchstart') ? json['prop_matchstart'] : 0,
    );
  }

  int id;
  String state;
  String player;
  String title;
  double totalUsers;
  double oddsWin;
  double oddsLose;
  double total;
  int epoch;
  DateTime timeCreation;
  String? champ;

}

class PropHelper {
  static double getAllBetsForId(int id) {
    double total = 0;

    for (Bet bet in User.instance.betsUser) {
      if (bet.propId == id) total += bet.amount;
    }
    
    return total;
  }
}