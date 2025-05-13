// Archivo: test/unitarias/match_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/matches/match_model.dart'; // Ajusta esta ruta si cambia en tu proyecto

void main() {
  group('Match Model Test', () {
    test('Debe crear un objeto Match correctamente', () {
      final match = Match(
        dateGMT: '2023-05-21',
        homeTeam: 'Junior',
        awayTeam: 'Atlético Nacional',
        homeTeamGoal: '2',
        awayTeamGoal: '1',
        homeTeamCorner: '5',
        awayTeamCorner: '3',
        homeTeamYellowCards: '2',
        homeTeamRedCards: '0',
        awayTeamYellowCards: '3',
        awayTeamRedCards: '1',
        homeTeamShots: '10',
        awayTeamShots: '8',
        homeTeamShotsOnTarget: '6',
        awayTeamShotsOnTarget: '3',
        homeTeamFouls: '12',
        awayTeamFouls: '14',
        homeTeamPossession: '55%',
        awayTeamPossession: '45%',
        stadiumName: 'Metropolitano Roberto Meléndez',
      );

      expect(match.dateGMT, '2023-05-21');
      expect(match.homeTeam, 'Junior');
      expect(match.awayTeam, 'Atlético Nacional');
      expect(match.homeTeamGoal, '2');
      expect(match.awayTeamGoal, '1');
      expect(match.stadiumName, 'Metropolitano Roberto Meléndez');
    });
  });
}
