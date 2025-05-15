
String local = "fr";

Map<String, String> fr = {
  "hello" : "Hello",
  "create_bet" : "Créer un pari",
  "stats" : "Stats",
  "bet_win" : "Paris Gagnés",
  "last_po_win" : "Dernier Po Gagnés",
  "all_bets" : "Paris Disponibles",
  "total" : "Total",
  "reload_all_props" : 'Reload des paris disponibles',
  "reload_all_bets" : 'Reload des paris faits',
  "guest" : "Invité",
  "lose_first_bet" : "Perd son premier pari !",

  'username' : "Pseudo",
  'password' : "Mot de passe",

  // INTRO
  'intro_start' : "Bienvenue ! Voici comment utiliser l'application.",
  'intro_1' : "Ici, tu as ton pseudo et ton nombre de Po !",
  'intro_2' : "Ici, tu peux créer un pari sur n'importe quoi !",
  'intro_3' : "Ici, tu as toutes les stats en tant que joueur",
  'intro_4' : "C'est la carte des paris.\n Tu as la côte, le pseudo de la personne concernée et le total des sommes pariées dessus",
  'intro_end' : "J'espère que tu vas passer un super moment sur le site (parie à mort stp)",

  // DISCONNECT POPUP
  'disconnect' : "Se déconnecter",
  'disconnect_title' : "Tu es sûr de vouloir te déconnecter de cette plateforme superbe ???????????",
  'disconnect_success' : 'Déconnexion réussie',

  // SIGN UP POPUP
  'creation_account_success' : "Création et connexion réussie",
  'invalid_credentials' : "Pseudo ou Mot de passe incorrect",
  'creation_account_error' : "Une erreur est survenue lors de l'inscription",
  'create_account' : "Créer un Compte",
  'creation_account_title' : "Ici, tu peux créer un compte, tu peux utiliser un pseudo pour l’anonymat. Aussi oublie pas de garder ton mot de passe",
  
  // SIGN IN POPUP
  'signin_success' : "Connexion réussie",
  'signin_error' : "Une erreur est survenue lors de la connexion",
  'signin' : "Se connecter",
  'signin_title' : "J’espère que tu n’as pas oublié ton mot de passe (100 Po par mot de passe oublié)",
  'no_account_go_create' : "Pas de compte ? Appuie ici pour en créer un !",

  // CREATE A BET
  'create_the_bet' : "Créer le pari",
  'new_bet_title' : "Tu peux créer un pari sur n’importe quoi, il faut juste que la source soit vérifiable !",
  'bet_username_target' : "Pseudo cible",
  "condition" : 'Condition',
  'new_bet_hint' : 'Perd sa lane à 5 minutes',

  // MAKE A BET
  'make_bet' : "Miser sur un Pari",
  'make_bet_error' : "Erreur pendant la mise sur le pari",
  'make_bet_title' : "Tu veux miser sur un pari ? Tu penses gagner ? Gamble tout et met tout c’est plus simple",
  'make_bet_short' : "Miser",
  'make_bet_success' : "Ta mise sur le pari a été éxécuté !",
  'make_bet_closed' : "Ce pari est fermée (malheuresement)",
  'make_bet_not_enough' : "T'as pas assez de po chef (essaye pas de douiller le système)",

  'done_bets' : "Paris faits",

  'daily_reward_success' : "Récompense journalière récupérée",
  'daily_reward_success_already' : "Récompense journalière déjà récupérée",
  'daily_reward_error' : "Une erreur est survenue pendant la récupération de la récompense journalière",

  'placed_bet' : "Ouvert",
  'win_bet' : 'Gagné',
  'lose_bet' : 'Perdu',
  'ongoing' : 'En cours'

};

Map<String, String> en = {
  "hello" : "Hello",
  "create_bet" : "Create a bet",
  "stats" : "Stats",
  "bet_win" : "Bets Won",
  "last_po_win" : "Last Po Won",
  "all_bets" : "All Bets",
  "total" : "Total",
  "reload_all_bets" : 'Reload all bets',
  "guest" : "Guest",
  "lose_first_bet" : "Loses his first bet!",

  'username' : "Username",
  'password' : "Password",

  // INTRO
  'intro_start' : "Welcome! Here's how to use this app.",
  'intro_1' : "Here, you have your username and po!",
  'intro_2' : "Here, you can create a bet on anything!",
  'intro_3' : "Here, you have all your stats as a player",
  'intro_4' : "It's the bet card.\n You have the odd, the username of the person and the total of the bets on this bet",
  'intro_end' : "I hope you will have a great experience on this app (goon to the bets bro pls)",

  // DISCONNECT POPUP
  'disconnect' : "Disconnect",
  'disconnect_title' : "Are you sure you want to disconnect from this amazing app???????????",
  'disconnect_success' : 'Disconnect success',

  // SIGN UP POPUP
  'creation_account_success' : "Creation and connexion successful",
  'invalid_credentials' : "Username or Password incorrect",
  'creation_account_error' : "An error happened when creating your account",
  'create_account' : "Sign Up",
  'creation_account_title' : "Here, you can create an account on this amazing app, you can use a username to be anonymous. Also, don't forget you password pls",
  
  // SIGN IN POPUP
  'signin_success' : "Connexion successful",
  'signin_error' : "An error happened on sign in",
  'signin' : "Sign in",
  'signin_title' : "I hope you don't forget you password (100po for each forgotten passwords)",
  'no_account_go_create' : "No account ? Click here to create one!",

};

String getTraduction(String key) {
  String? value;
  
  switch(local) {
    case 'fr': value = fr[key];
    case 'en': value = en[key];
  }

  value ??= "NOT FOUND";

  return value;
}


extension StringExtensions on String {
  String get tr {
    
    return getTraduction(toLowerCase());

  }
}