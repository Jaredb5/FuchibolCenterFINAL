// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'match_model.dart';
import 'match_detail.dart';
import 'match_search.dart';

class MatchScreen extends StatelessWidget {
  final String supabaseUrl =
      'https://eksgwihmgfwwanfrxnmg.supabase.co/storage/v1/object/public/Data/matches_csv';

  const MatchScreen({Key? key}) : super(key: key);

  Future<List<Match>> loadAllMatches() async {
    List<String> fileNames = [
      'matches 2013.csv',
      'matches 2014.csv',
      'matches 2015.csv',
      'matches 2016.csv',
      'matches 2017.csv',
      'matches 2018.csv',
      'matches 2019.csv',
      'matches 2020.csv',
      'matches 2021.csv',
      'matches 2022.csv',
      'matches 2023.csv',
    ];

    List<Match> allMatches = [];

    for (String fileName in fileNames) {
      try {
        var fileUrl = '$supabaseUrl/$fileName'; // URL del archivo en Supabase
        var response = await http.get(Uri.parse(fileUrl));

        if (response.statusCode == 200) {
          final String csvString = utf8.decode(response.bodyBytes);
          List<List<dynamic>> csvData =
              const CsvToListConverter(fieldDelimiter: ';').convert(csvString);

          for (List<dynamic> row in csvData.skip(1)) {
            allMatches.add(Match(
              dateGMT: row[0].toString(),
              homeTeam: row[1].toString(),
              awayTeam: row[2].toString(),
              homeTeamGoal: row[3].toString(),
              awayTeamGoal: row[4].toString(),
              homeTeamCorner: row[6].toString(),
              awayTeamCorner: row[7].toString(),
              homeTeamYellowCards: row[8].toString(),
              homeTeamRedCards: row[9].toString(),
              awayTeamYellowCards: row[10].toString(),
              awayTeamRedCards: row[11].toString(),
              homeTeamShots: row[12].toString(),
              awayTeamShots: row[13].toString(),
              homeTeamShotsOnTarget: row[14].toString(),
              awayTeamShotsOnTarget: row[15].toString(),
              homeTeamFouls: row[16].toString(),
              awayTeamFouls: row[17].toString(),
              homeTeamPossession: row[18].toString(),
              awayTeamPossession: row[19].toString(),
              stadiumName: row[20].toString(),
            ));
          }
        } else {
          print('Error al cargar $fileName: ${response.statusCode}');
        }
      } catch (e) {
        print('Excepción al cargar $fileName: $e');
      }
    }
    return allMatches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partidos'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final matches = await loadAllMatches();
              showSearch(
                context: context,
                delegate: MatchSearchDelegate(matches),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Match>>(
        future: loadAllMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay partidos disponibles.'));
          } else {
            List<Match> matches = snapshot.data!;
            return Scrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: const Icon(Icons.sports_soccer,
                          color: Colors.redAccent),
                      title: Text(
                        '${match.homeTeam} vs ${match.awayTeam}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Fecha: ${match.dateGMT}'),
                      trailing:
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MatchDetailsScreen(match: match),
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
