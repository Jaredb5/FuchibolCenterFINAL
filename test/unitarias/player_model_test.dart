import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/players/player_model.dart';

void main() {
  group('Player Model Test', () {
    test('Crear un jugador correctamente', () {
      // Simula datos que vendrían de un CSV
      final player = Player(
        fullName: 'James Rodríguez',
        age: 32,
        league: 'Categoria Primera A',
        season: 2023,
        position: 'Midfielder',
        currentClub: 'Atlético Nacional',
        nationality: 'Colombia',
        appearances_overall: 30,
        goalsOverall: 10,
        goalsHome: 6,
        goalsAway: 4,
        assistsOverall: 8,
        assistsHome: 5,
        assistsAway: 3,
        yellowCardsOverall: 3,
        redCardsOverall: 1,
      );

      // Verificaciones
      expect(player.fullName, 'James Rodríguez');
      expect(player.age, 32);
      expect(player.league, 'Categoria Primera A');
      expect(player.season, 2023);
      expect(player.position, 'Midfielder');
      expect(player.currentClub, 'Atlético Nacional');
      expect(player.nationality, 'Colombia');
      expect(player.appearances_overall, 30);
      expect(player.goalsOverall, 10);
      expect(player.assistsOverall, 8);
      expect(player.yellowCardsOverall, 3);
      expect(player.redCardsOverall, 1);
    });
  });
}
