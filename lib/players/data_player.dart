import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'player_model.dart'; // Asegúrate de que este archivo define la clase Player

Future<List<Player>> loadAllPlayerData() async {
  // Reemplaza con la URL base de tu proyecto Supabase
  String supabaseUrl =
      'https://eksgwihmgfwwanfrxnmg.supabase.co/storage/v1/object/public/Data/players_csv';
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
    var fileUrl = '$supabaseUrl/$fileName';
    var response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      // Decodificar la respuesta como UTF-8
      final String csvString = utf8.decode(response.bodyBytes);
      List<List<dynamic>> csvData =
          const CsvToListConverter(fieldDelimiter: ';').convert(csvString);

      for (List<dynamic> row in csvData.skip(1)) {
        // Asumiendo que la primera fila es el encabezado
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
          // ... otros campos según tu modelo
        ));
      }
    } else {
      // Manejar el caso de error al cargar el archivo
      throw Exception(
          'Failed to load player data from Supabase Storage for file $fileName');
    }
  }

  return allPlayers;
}
