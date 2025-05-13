import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'player_model.dart';
import 'player_detail.dart';
import 'player_search.dart';

class PlayersScreen extends StatelessWidget {
  final String year;

  // ✅ NUEVA URL de Supabase actualizada
  final String supabaseUrl =
      'https://erxdcztffrdgbsiirsmu.supabase.co/storage/v1/object/public/data/players';

  const PlayersScreen({Key? key, required this.year}) : super(key: key);

  Future<List<Player>> loadAllPlayers() async {
    List<String> fileNames = [
      'player 2013.csv',
      'player 2014.csv',
      'player 2015.csv',
      'player 2016.csv',
      'player 2017.csv',
      'player 2018.csv',
      'player 2019.csv',
      'player 2020.csv',
      'player 2021.csv',
      'player 2022.csv',
      'player 2023.csv',
    ];

    List<Player> allPlayers = [];

    for (String fileName in fileNames) {
      try {
        final encodedFileName = Uri.encodeComponent(fileName); // Manejo de espacios
        final fileUrl = '$supabaseUrl/$encodedFileName';
        final response = await http.get(Uri.parse(fileUrl));

        if (response.statusCode == 200) {
          final csvString = utf8.decode(response.bodyBytes);
          List<List<dynamic>> csvData =
              const CsvToListConverter(fieldDelimiter: ';').convert(csvString);

          for (List<dynamic> row in csvData.skip(1)) {
            allPlayers.add(Player(
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
        } else {
          print('❌ Error al cargar $fileName: ${response.statusCode}');
        }
      } catch (e) {
        print('⚠️ Excepción al cargar $fileName: $e');
      }
    }

    return allPlayers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final players = await loadAllPlayers();
              showSearch(
                context: context,
                delegate: PlayerSearchDelegate(players),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Player>>(
        future: loadAllPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay jugadores disponibles.'));
          } else {
            final players = snapshot.data!;
            return Scrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
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
