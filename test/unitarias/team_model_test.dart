// Archivo: test/unitarias/team_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/teams/teams_model.dart'; // Asegúrate que la ruta sea correcta en tu proyecto

void main() {
  group('Team Model Test', () {
    test('Debe crear un objeto Team correctamente', () {
      final team = Team(
        commonName: 'Atlético Nacional',
        season: 2023,
        matches_played: 40,
        matches_played_home: 20,
        matches_played_away: 20,
        wins: 25,
        wins_home: 15,
        wins_away: 10,
        draws: 10,
        draws_home: 5,
        draws_away: 5,
        losses: 5,
        losses_home: 2,
        losses_away: 3,
        league_position: 1,
        goals_scored: 70,
        goals_conceded: 30,
        goals_difference: 40,
        total_goal_count: 100,
        corners_total: 200,
        corners_total_home: 110,
        corners_total_away: 90,
        cards_total: 70,
        cards_total_home: 35,
        cards_total_away: 35,
      );

      expect(team.commonName, 'Atlético Nacional');
      expect(team.season, 2023);
      expect(team.matches_played, 40);
      expect(team.wins, 25);
      expect(team.draws_home, 5);
      expect(team.goals_difference, 40);
      expect(team.corners_total_away, 90);
      expect(team.cards_total, 70);
    });
  });
}
