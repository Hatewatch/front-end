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
    required this.betPlayer,
    required this.betOdds,
    required this.betSide,
  });

  factory Bet.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Bet(
      id: json['bet_id'] != null ? json['bet_id'] as int : null,
      propPlayer: json['players_in_game'] as String,
      propOdds: double.parse(json['bet_odd']),
      propTitle: json['bo_title'] as String,
      result: "WIN",
      //result: json['bet_result'] == null ? "" : json['bet_result'] as String,
      state: json.containsKey('bet_state') ? json['bet_state'] as String : null,
      amount : double.parse(json['bet_amount']),
      //propId: json['prop_id'],
      propId: 0,
      betPlayer: json.containsKey('bettor_name') ? json['bettor_name'] : null,
      //betOdds: double.parse(json['bet_odd']),
      betOdds: 0.0,
      betSide: json['bet_side'] == 1 ? "WIN" : "LOSE",
    );
  }

  double getAmountWithResult() {
    if (result != "WIN" && result != "LOSE") return 0;


    return result == 'WIN' ? amount : -amount;
  }

  bool hasWinOrLose() {
    return result == "WIN" || result == "LOSE";
  }

  bool hasWin() {
    return result == "WIN";
  }

  int? id;
  String result;
  String? state;
  double amount;
  String? betPlayer;
  double betOdds;
  String betSide;

  int propId;
  String propTitle;
  String propPlayer;
  double propOdds;

}

class BetHelper {

  static double getAverageBetAmount(List<Bet> bets) {
    double total = 0;

    int max = bets.length;

    for (Bet bet in bets) {
      total += bet.amount;
    }

    if (total == 0) return 0;

    return total/max;
  }

  static double getAverageBetOdds(List<Bet> bets) {
    double total = 0;

    int max = bets.length;

    for (Bet bet in bets) {
      total += bet.propOdds;
    }

    if (total == 0) return 0;

    return total/max;
  }

  static double getBestBetWin(List<Bet> bets) {
    double best = 0;

    for (Bet bet in bets) {
      if (bet.amount * bet.propOdds > best && bet.hasWin()) best = bet.amount * bet.propOdds; 
    }

    return best;
  }

  static String getAverageBetPlayer(List<Bet> bets) {

    Map<String, int> map = {};

    for (Bet bet in bets) {
      if (map.containsKey(bet.propPlayer)) {
        map[bet.propPlayer] = map[bet.propPlayer]! + 1;
      } else {
        map[bet.propPlayer] = 1;
      }
    }

    String total = "";
    int totalInt = 0;
    for (var key in map.keys) {
      if (map[key]! > totalInt) {
        total = key;
        totalInt = map[key]!;
      }
    }

    if (total == "") return "NONE";

    return total;
  }

  static String getBestBetPlayerWinrate(List<Bet> bets) {

    Map<String, int> map = {};

    for (Bet bet in bets) {
      if (map.containsKey(bet.propPlayer)) {
        if (bet.hasWinOrLose()) {
          map[bet.propPlayer] = map[bet.propPlayer]! + (bet.hasWin() ? 1 : -1);
        }
      } else {
        if (bet.hasWinOrLose()) {
          map[bet.propPlayer] = bet.hasWin() ? 1 : -1;
        }
      }
    }

    String total = "";
    int totalInt = 0;
    for (var key in map.keys) {
      if (map[key]! > totalInt) {
        total = key;
        totalInt = map[key]!;
      }
    }

    if (total == "") return "NONE";

    return total;
  }

}