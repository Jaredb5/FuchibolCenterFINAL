import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'teams_model.dart'; // Asegúrate de que este archivo define la clase Team

Future<List<Team>> loadAllTeamData() async {
  List<String> fileNames = [
    'teams 2013.csv',
    'teams 2014.csv',
    'teams 2015.csv',
    'teams 2016.csv',
    'teams 2017.csv',
    'teams 2018.csv',
    'teams 2019.csv',
    'teams 2020.csv',
    'teams 2021.csv',
    'teams 2022.csv',
    'teams 2023.csv',
  ];

  List<Team> allTeams = [];

  for (String fileName in fileNames) {
    // Cargar el archivo CSV desde la carpeta local lib/data/team_data
    final csvString = await rootBundle.loadString('lib/assets/teams/$fileName');
    List<List<dynamic>> csvData =
        const CsvToListConverter(fieldDelimiter: ';').convert(csvString);

    for (List<dynamic> row in csvData.skip(1)) {
      // Asumiendo que la primera fila es el encabezado
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
  }

  return allTeams;
}
