class Game {

  int id;
  String state;
  int start;
  int result;
  List<UserGame> users;

  Game(
    {
    required this.id,
    required this.state,
    required this.start,
    required this.result,
    required this.users,
    }
  );

  factory Game.fromJson(Map<String, dynamic> json) {

    List<UserGame> users = [];

    for (var jsonUser in json['users_in_match']) {
      users.add(
        UserGame.fromJson(jsonUser)
      );
    }

    return Game(
      id: int.parse(json['game_id']),
      start: json.containsKey('game_start') ? int.parse(json['game_start']) : 0,
      state: json['game_state'],
      result: json['game_result'],
      users: users,
    );
  }

}

class UserGame {

  String name;
  int team;
  String champ;
  
  String nameLol;
  int iconLol;
  double winrate;
  double kda;
  int level;
  double csm;
  String elo;
  String div;
  int lp;

  UserGame(
     {
      required this.name,
      required this.team,
      required this.champ,
      
      required this.nameLol,
      required this.iconLol,
      required this.winrate,
      required this.level,
      required this.kda,
      required this.csm,
      required this.elo,
      required this.div,
      required this.lp,
     }
  );

  factory UserGame.fromJson(Map<String,dynamic> json) {
    return UserGame(
      name: json['user_name'],
      team: json['player_team'],
      champ: json['champion_name'],

      nameLol: json['riot_data']['rd_tagline'],
      iconLol: json['riot_data']['rd_icon'],
      level: json['riot_data']['rd_level'],
      winrate: double.parse(json['riot_data']['rd_winrate']),
      kda: double.parse(json['riot_data']['rd_kda']),
      csm: double.parse(json['riot_data']['rd_csm']),
      elo: json['riot_data']['rd_elo'],
      div: json['riot_data']['rd_div'],
      lp: json['riot_data']['rd_lp'],
    );
  }

}