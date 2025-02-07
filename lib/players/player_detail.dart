import 'package:flutter/material.dart';
import 'player_model.dart';
import 'data_player.dart';
import 'player_info_card.dart';
import 'bar_chart_player.dart';
import 'line_chart_player.dart';
import 'pie_chart_player.dart';

class PlayerDetailsScreen extends StatefulWidget {
  final Player player;

  const PlayerDetailsScreen({Key? key, required this.player}) : super(key: key);

  @override
  _PlayerDetailsScreenState createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  String _selectedChartType = 'Barra';

  List<Player> getPlayerDataForLast10Years(
      List<Player> allPlayers, String playerName) {
    return allPlayers.where((p) => p.fullName == playerName).toList();
  }

  double _calculateAverage(int total, int matches) {
    return matches > 0 ? total / matches : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.fullName),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Player>>(
        future: loadAllPlayerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay datos disponibles para este jugador.'));
          } else {
            List<Player> allPlayers = snapshot.data!;
            List<Player> playerData =
                getPlayerDataForLast10Years(allPlayers, widget.player.fullName);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles del Jugador:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  PlayerInfoCard(
                    title: 'Nombre',
                    value: widget.player.fullName,
                    icon: Icons.person,
                  ),
                  PlayerInfoCard(
                    title: 'Edad',
                    value: widget.player.age.toString(),
                    icon: Icons.cake,
                  ),
                  PlayerInfoCard(
                    title: 'Liga',
                    value: widget.player.league,
                    icon: Icons.sports_soccer,
                  ),
                  PlayerInfoCard(
                    title: 'Posición',
                    value: widget.player.position,
                    icon: Icons.directions_run,
                  ),
                  PlayerInfoCard(
                    title: 'Nacionalidad',
                    value: widget.player.nationality,
                    icon: Icons.flag,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Carrera:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildCareerTable(playerData),
                  const SizedBox(height: 20),
                  _buildStatisticsExpansionTile(
                      'Goles por partido en cada temporada',
                      'averageGoals',
                      playerData),
                  _buildStatisticsExpansionTile(
                      'Asistencias por partido en cada temporada',
                      'averageAssists',
                      playerData),
                  _buildStatisticsExpansionTile(
                      'Tarjetas Amarillas por partido en cada temporada',
                      'averageYellowCards',
                      playerData),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCareerTable(List<Player> playerData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text(
              'Temporada',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Club',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Apariciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Goles',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Asistencias',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Tarjetas Amarillas/Rojas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: playerData.map((player) {
          return DataRow(cells: [
            DataCell(Text(player.season.toString())),
            DataCell(Text(player.currentClub)),
            DataCell(Text(player.appearances_overall.toString())),
            DataCell(Text(player.goalsOverall.toString())),
            DataCell(Text(player.assistsOverall.toString())),
            DataCell(Text(
                'Amarillas: ${player.yellowCardsOverall}, Rojas: ${player.redCardsOverall}')),
          ]);
        }).toList(),
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => Colors.blueAccent.shade100,
        ),
        headingTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        dataRowColor: MaterialStateColor.resolveWith(
          (states) => Colors.blueAccent.shade100,
        ),
        dataTextStyle: const TextStyle(
          color: Colors.black,
        ),
        border: TableBorder.all(
          color: Colors.blueAccent,
          width: 1.5,
        ),
        columnSpacing: 20.0,
      ),
    );
  }

  ExpansionTile _buildStatisticsExpansionTile(
      String title, String dataType, List<Player> playerData) {
    return ExpansionTile(
      title: Text(
        'Estadísticas de $title',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton<String>(
            value: _selectedChartType,
            items: <String>['Barra', 'Lineal', 'Circular'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedChartType = newValue!;
              });
            },
          ),
        ),
        _buildChartComparison(playerData, dataType),
      ],
    );
  }

  Widget _buildChartComparison(List<Player> playerData, String dataType) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _selectedChartType == 'Barra'
          ? BarChartSamplePlayerComparison(
              dataType: dataType, playerData: playerData)
          : _selectedChartType == 'Lineal'
              ? LineChartSamplePlayerComparison(
                  dataType: dataType, playerData: playerData)
              : PieChartSamplePlayerComparison(
                  dataType: dataType, playerData: playerData),
    );
  }
}
