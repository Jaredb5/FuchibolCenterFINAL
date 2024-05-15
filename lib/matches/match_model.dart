class Match {
  final String dateGMT;
  final String homeTeam;
  final String homeTeamCorner;
  final String homeTeamYellowCards;
  final String homeTeamRedCards;
  final String homeTeamGoal;
  final String awayTeam;
  final String awayTeamCorner;
  final String awayTeamYellowCards;
  final String awayTeamRedCards;
  final String awayTeamGoal;
  final String stadiumName;

  Match({
    required this.dateGMT,
    required this.homeTeam,
    required this.homeTeamCorner,
    required this.homeTeamYellowCards,
    required this.homeTeamRedCards,
    required this.homeTeamGoal,
    required this.awayTeam,
    required this.awayTeamCorner,
    required this.awayTeamYellowCards,
    required this.awayTeamRedCards,
    required this.awayTeamGoal,
    required this.stadiumName,
  });
}
