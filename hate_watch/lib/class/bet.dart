class Bet {

  Bet({
    required this.id,
    required this.result,
    required this.state,
    required this.propOdds,
    required this.propPlayer,
    required this.propTitle,
    required this.amount,
    required this.propId,
  });

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
      id: json['bet_id'] as int,
      propPlayer: json['prop_player'] as String,
      propOdds: double.parse(json['prop_odds']),
      propTitle: json['prop_title'] as String,
      result: json['bet_result'] as String,
      state: json['bet_state'] as String,
      amount : double.parse(json['bet_amount']),
      propId: json['prop_id'],
    );
  }

  int id;
  String result;
  String? state;
  double amount;

  int propId;
  String propTitle;
  String propPlayer;
  double propOdds;

}