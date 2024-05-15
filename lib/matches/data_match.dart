import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'match_model.dart'; // Asegúrate de que este archivo define la clase Match

Future<List<Match>> loadMatchData() async {
  String supabaseUrl =
      'https://eksgwihmgfwwanfrxnmg.supabase.co/storage/v1/object/public/Data/matches_csv';
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
    var fileUrl = '$supabaseUrl/$fileName';
    var response = await http.get(
      Uri.parse(fileUrl),
      headers: {'Accept-Charset': 'UTF-8'},
    );

    if (response.statusCode == 200) {
      // Decodificar la respuesta como UTF-8
      final String csvString = utf8.decode(response.bodyBytes);
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
          stadiumName: row[12].toString(),
          // ... y así sucesivamente para el resto de las columnas
        ));
      }
    } else {
      // Manejar el caso de error al cargar el archivo
      throw Exception(
          'Failed to load match data from Supabase Storage for file $fileName');
    }
  }

  return allMatches;
}
