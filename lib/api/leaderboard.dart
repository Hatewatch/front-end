
class Leaderboard {

  Leaderboard({
    required this.name,
    required this.amount,
    required this.totalBets,
    required this.percent,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      name: json['user_name'] as String,
      amount: double.parse(json['user_coins']),
      totalBets: json['total_bets'] as int,
      percent: double.parse(json['winrate']),
    );
  }

  String name;
  double amount;
  int totalBets;
  double percent;

}