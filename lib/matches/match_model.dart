import 'package:intl/intl.dart';

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
  final String homeTeamShots;
  final String awayTeamShots;
  final String homeTeamShotsOnTarget;
  final String awayTeamShotsOnTarget;
  final String homeTeamFouls;
  final String awayTeamFouls;
  final String homeTeamPossession;
  final String awayTeamPossession;

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
    required this.homeTeamShots,
    required this.awayTeamShots,
    required this.homeTeamShotsOnTarget,
    required this.awayTeamShotsOnTarget,
    required this.homeTeamFouls,
    required this.awayTeamFouls,
    required this.homeTeamPossession,
    required this.awayTeamPossession,
  });

  int get year {
    final date = DateFormat('MMM dd yyyy - hh:mma').parse(dateGMT, true);
    return date.year;
  }
}
