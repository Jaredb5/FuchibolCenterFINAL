import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'match_model.dart'; // Asegúrate de que este archivo define la clase Match

Future<List<Match>> loadAllMatchData() async {
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
    // Cargar el archivo CSV desde la carpeta local lib/data/match_data
    final csvString =
        await rootBundle.loadString('lib/assets/matches/$fileName');
    List<List<dynamic>> csvData =
        const CsvToListConverter(fieldDelimiter: ';').convert(csvString);

    for (List<dynamic> row in csvData.skip(1)) {
      // Asumiendo que la primera fila es el encabezado
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
  }
  return allMatches;
}
