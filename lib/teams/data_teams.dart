import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'teams_model.dart'; // Asegúrate de que este archivo define la clase Team

Future<List<Team>> loadTeamData() async {
  // Reemplaza con la URL base de tu proyecto Supabase
  String supabaseUrl = 'https://eksgwihmgfwwanfrxnmg.supabase.co/storage/v1/object/public/Data/teams_csv';
  List<String> fileNames = [
    'teams_2013.csv',
    'teams_2014.csv',
    'teams_2015.csv',
    'teams_2016.csv',
    'teams_2017.csv',
    'teams_2018.csv',
    'teams_2019.csv',
    'teams_2020.csv',
    'teams_2021.csv',
    'teams_2022.csv',
    'teams_2023.csv',
  ];

  List<Team> allTeams = [];

  for (String fileName in fileNames) {
    var fileUrl = '$supabaseUrl/$fileName';
    var response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      // Decodificar la respuesta como UTF-8
      final String csvString = utf8.decode(response.bodyBytes);
      List<List<dynamic>> csvData = const CsvToListConverter(fieldDelimiter: ';').convert(csvString);

      for (List<dynamic> row in csvData.skip(1)) { // Asumiendo que la primera fila es el encabezado
        allTeams.add(Team(
          commonName: row[0].toString(),
          season: int.tryParse(row[1].toString()) ?? 0,
          matches_played: int.tryParse(row[2].toString()) ?? 0,
          matches_played_home: int.tryParse(row[3].toString()) ?? 0,
          matches_played_away: int.tryParse(row[4].toString()) ?? 0,
          wins: int.tryParse(row[5].toString()) ?? 0,
          wins_home: int.tryParse(row[6].toString()) ?? 0,
          wins_away: int.tryParse(row[7].toString()) ?? 0,
          draws: int.tryParse(row[8].toString()) ?? 0,
          draws_home: int.tryParse(row[9].toString()) ?? 0,
          draws_away: int.tryParse(row[10].toString()) ?? 0,
          losses: int.tryParse(row[11].toString()) ?? 0,
          losses_home: int.tryParse(row[12].toString()) ?? 0,
          losses_away: int.tryParse(row[13].toString()) ?? 0,
          league_position: int.tryParse(row[14].toString()) ?? 0,
          goals_scored: int.tryParse(row[15].toString()) ?? 0,
          goals_conceded: int.tryParse(row[16].toString()) ?? 0,
          goals_difference: int.tryParse(row[17].toString()) ?? 0,
          total_goal_count: int.tryParse(row[18].toString()) ?? 0,
          corners_total: int.tryParse(row[19].toString()) ?? 0,
          corners_total_home: int.tryParse(row[20].toString()) ?? 0,
          corners_total_away: int.tryParse(row[21].toString()) ?? 0,
          cards_total: int.tryParse(row[22].toString()) ?? 0,
          cards_total_home: int.tryParse(row[23].toString()) ?? 0,
          cards_total_away: int.tryParse(row[24].toString()) ?? 0,
        ));
      }
    } else {
      // Manejar el caso de error al cargar el archivo
      throw Exception('Failed to load team data from Supabase Storage for file $fileName');
    }
  }

  return allTeams;
}
