// ignore_for_file: non_constant_identifier_names

class Team {
    final String commonName;
    final int season;
    final int matches_played;
    final int matches_played_home;
    final int matches_played_away;
    final int wins;
    final int wins_home;
    final int wins_away;
    final int draws;
    final int draws_home;
    final int draws_away;
    final int losses;
    final int losses_home;
    final int losses_away;
    final int league_position;
    final int goals_scored;
    final int goals_conceded;
    final int goals_difference;
    final int total_goal_count;
    final int corners_total;
    final int corners_total_home;
    final int corners_total_away;
    final int cards_total;
    final int cards_total_home;
    final int cards_total_away;
  
  Team({
    required this.commonName,
    required this.season,
    required this.matches_played,
    required this.matches_played_home,
    required this.matches_played_away,
    required this.wins,
    required this.wins_home,
    required this.wins_away,
    required this.draws,
    required this.draws_home,
    required this.draws_away,
    required this.losses,
    required this.losses_home,
    required this.losses_away,
    required this.league_position,
    required this.goals_scored,
    required this.goals_conceded,
    required this.goals_difference,
    required this.total_goal_count,
    required this.corners_total,
    required this.corners_total_home,
    required this.corners_total_away,
    required this.cards_total,
    required this.cards_total_home,
    required this.cards_total_away,
  });
}
