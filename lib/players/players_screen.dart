// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'player_model.dart';
import 'player_detail.dart';
import 'player_search.dart';

class PlayersScreen extends StatelessWidget {
  final String year;
  final String supabaseUrl =
      'https://eksgwihmgfwwanfrxnmg.supabase.co/storage/v1/object/public/Data/players_csv';

  const PlayersScreen({required this.year, Key? key}) : super(key: key);

  Future<List<Player>> loadPlayersForYear(String year) async {
    var fileUrl = '$supabaseUrl/player $year.csv';
    var response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      // Decodificar la respuesta como UTF-8
      final String csvString =
          utf8.decode(response.bodyBytes, allowMalformed: true);
      List<List<dynamic>> csvData =
          const CsvToListConverter(fieldDelimiter: ';').convert(csvString);

      List<Player> players = [];
      for (List<dynamic> row in csvData.skip(1)) {
        players.add(Player(
          fullName: row[0],
          age: int.parse(row[1].toString()),
          league: row[2],
          season: int.parse(row[3].toString()),
          position: row[4],
          currentClub: row[5],
          nationality: row[6],
          appearances_overall: int.parse(row[7].toString()),
          goalsOverall: int.parse(row[8].toString()),
          goalsHome: int.parse(row[9].toString()),
          goalsAway: int.parse(row[10].toString()),
          assistsOverall: int.parse(row[11].toString()),
          assistsHome: int.parse(row[12].toString()),
          assistsAway: int.parse(row[13].toString()),
          yellowCardsOverall: int.parse(row[14].toString()),
          redCardsOverall: int.parse(row[15].toString()),
        ));
      }
      return players;
    } else {
      throw Exception(
          'Failed to load player data from Supabase Storage for year $year');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores $year'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final players = await loadPlayersForYear(year);
              showSearch(
                context: context,
                delegate: PlayerSearchDelegate(players),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Player>>(
        future: loadPlayersForYear(year),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay jugadores disponibles para este año.'));
          } else {
            List<Player> players = snapshot.data!;
            return Scrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading:
                          const Icon(Icons.person, color: Colors.blueAccent),
                      title: Text(
                        player.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text('Edad: ${player.age}, Liga: ${player.league}'),
                      trailing:
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayerDetailsScreen(player: player),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
