// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'match_model.dart';
import 'match_detail.dart';
import 'match_search.dart';

class MatchScreen extends StatelessWidget {
  final String year;
  final String supabaseUrl =
      'https://eksgwihmgfwwanfrxnmg.supabase.co/storage/v1/object/public/Data/matches_csv'; // Reemplaza con tu URL de Supabase

  const MatchScreen({required this.year, Key? key}) : super(key: key);

  Future<List<Match>> loadMatchesForYear(String year) async {
    var fileUrl =
        '$supabaseUrl/matches $year.csv'; // Asegúrate de que esta URL es correcta
    var response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      // Decodificar la respuesta como UTF-8
      final String csvString = utf8.decode(response.bodyBytes);
      List<List<dynamic>> csvData =
          const CsvToListConverter(fieldDelimiter: ';').convert(csvString);
      List<Match> matches = [];
      for (List<dynamic> row in csvData.skip(1)) {
        // Asumiendo que la primera fila es el encabezado
        matches.add(Match(
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
          stadiumName: row[12].toString(),
          // Asegúrate de que los índices coincidan con las columnas de tu CSV
        ));
      }
      return matches;
    } else {
      throw Exception(
          'Failed to load match data from Supabase Storage for year $year');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partidos $year'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final matches = await loadMatchesForYear(year);
              showSearch(
                context: context,
                delegate: MatchSearchDelegate(matches),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Match>>(
        future: loadMatchesForYear(year),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay partidos disponibles para este año.'));
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
