
import 'package:hate_watch/class/bet.dart';
import 'package:hate_watch/class/user.dart';

class Prop {

  Prop({
    required this.id,
    required this.odds,
    required this.player,
    required this.title,
    required this.timeCreation,
    required this.available,
    required this.total,
    required this.totalUsers,
  });

  factory Prop.fromJson(Map<String, dynamic> json) {
    return Prop(
      id: json['prop_id'] as int,
      odds: double.parse(json['prop_odds']),
      player: json['prop_player'] as String,
      title: json['prop_title'] as String,
      timeCreation: DateTime.parse(json['prop_creation']),
      total: double.parse(json['prop_total_amount']),
      available: json['prop_available'],
      totalUsers: json['prop_nbPeople'],
    );
  }

  int id;
  int available;
  String player;
  String title;
  double totalUsers;
  double odds;
  double total;
  DateTime timeCreation;

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