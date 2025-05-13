import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/teams/teams_model.dart';
import 'package:flutter_application_2/teams/team_comparision_screen.dart';

void main() {
  testWidgets('Verifica que los equipos aparezcan correctamente en tabla', (WidgetTester tester) async {
final team1 = Team(
  commonName: 'Team A',
  season: 2023,
  league_position: 1,
  matches_played: 10,
  matches_played_home: 5,
  matches_played_away: 5,
  wins: 6,
  wins_home: 3,
  wins_away: 3,
  draws: 2,
  draws_home: 1,
  draws_away: 1,
  losses: 2,
  losses_home: 1,
  losses_away: 1,
  goals_scored: 18,
  goals_conceded: 10,
  goals_difference: 8,
  total_goal_count: 28,
  corners_total: 40,
  corners_total_home: 20,
  corners_total_away: 20,
  cards_total: 15,
  cards_total_home: 8,
  cards_total_away: 7,
);

final team2 = Team(
  commonName: 'Team B',
  season: 2023,
  league_position: 2,
  matches_played: 10,
  matches_played_home: 5,
  matches_played_away: 5,
  wins: 5,
  wins_home: 2,
  wins_away: 3,
  draws: 3,
  draws_home: 2,
  draws_away: 1,
  losses: 2,
  losses_home: 1,
  losses_away: 1,
  goals_scored: 15,
  goals_conceded: 11,
  goals_difference: 4,
  total_goal_count: 26,
  corners_total: 38,
  corners_total_home: 18,
  corners_total_away: 20,
  cards_total: 12,
  cards_total_home: 6,
  cards_total_away: 6,
);



    await tester.pumpWidget(MaterialApp(
      home: TeamComparisonScreen(team1: team1, team2: team2),
    ));

    expect(find.text('Team A'), findsOneWidget);
    expect(find.text('Team B'), findsOneWidget);
    expect(find.text('Victorias'), findsWidgets);
  });
}
