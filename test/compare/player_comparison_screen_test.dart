import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/players/player_model.dart';
import 'package:flutter_application_2/players/player_comparison_screen.dart';

void main() {
  testWidgets('Verifica que los nombres de jugadores estén en la tabla', (WidgetTester tester) async {
final player1 = Player(
  fullName: 'Jugador A',
  age: 25,
  league: 'Liga BetPlay',
  season: 2023,
  position: 'Delantero',
  currentClub: 'Club A',
  nationality: 'Colombiano',
  goalsOverall: 6,
  goalsHome: 3,
  goalsAway: 3,
  assistsOverall: 2,
  assistsHome: 1,
  assistsAway: 1,
  yellowCardsOverall: 1,
  redCardsOverall: 0,
  appearances_overall: 6,
);

final player2 = Player(
  fullName: 'Jugador B',
  age: 28,
  league: 'Liga BetPlay',
  season: 2023,
  position: 'Volante',
  currentClub: 'Club B',
  nationality: 'Colombiano',
  goalsOverall: 3,
  goalsHome: 2,
  goalsAway: 1,
  assistsOverall: 1,
  assistsHome: 1,
  assistsAway: 0,
  yellowCardsOverall: 2,
  redCardsOverall: 1,
  appearances_overall: 6,
);


    await tester.pumpWidget(MaterialApp(
      home: PlayerComparisonScreen(player1: player1, player2: player2),
    ));

    // Verifica que aparezcan los nombres
    expect(find.text('Jugador A'), findsWidgets);
    expect(find.text('Jugador B'), findsWidgets);
    expect(find.text('Goles'), findsWidgets);
    expect(find.text('Asistencias'), findsWidgets);
    expect(find.text('Tarjetas'), findsWidgets);
  });
}
