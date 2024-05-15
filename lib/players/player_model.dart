// ignore_for_file: non_constant_identifier_names

class Player {
  final String fullName;
  final int age;
  final String league;
  final int season;
  final String position;
  final String currentClub;
  final String nationality;
  final int appearances_overall;
  final int goalsOverall;
  final int goalsHome;
  final int goalsAway;
  final int assistsOverall;
  final int assistsHome;
  final int assistsAway;
  final int yellowCardsOverall;
  final int redCardsOverall;

  Player({
    required this.fullName,
    required this.age,
    required this.league,
    required this.season,
    required this.position,
    required this.currentClub,
    required this.nationality,
    required this.appearances_overall,
    required this.goalsOverall,
    required this.goalsHome,
    required this.goalsAway,
    required this.assistsOverall,
    required this.assistsHome,
    required this.assistsAway,
    required this.yellowCardsOverall,
    required this.redCardsOverall,
  });

  get appearancesOverall => null;
}

