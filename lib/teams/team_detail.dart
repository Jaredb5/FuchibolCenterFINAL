import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'data_teams.dart';
import 'team_info_card.dart';
import 'bar_chart.dart';
import 'line_chart.dart';
import 'pie_chart.dart';

class TeamDetailsScreen extends StatefulWidget {
  final Team team;

  const TeamDetailsScreen({Key? key, required this.team}) : super(key: key);

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  String _selectedChartType = 'Barra';

  List<Team> getTeamDataForLast10Years(List<Team> allTeams, String teamName) {
    return allTeams.where((t) => t.commonName == teamName).toList();
  }

  double _calculateAverage(double total, int matches) {
    return matches > 0 ? total / matches : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.commonName),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Team>>(
        future: loadAllTeamData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay datos disponibles para este equipo.'));
          } else {
            List<Team> allTeams = snapshot.data!;
            List<Team> teamData =
                getTeamDataForLast10Years(allTeams, widget.team.commonName);

            double averageGoals = _calculateAverage(
                widget.team.goals_scored.toDouble(),
                widget.team.matches_played);
            double averageCards = _calculateAverage(
                widget.team.cards_total.toDouble(), widget.team.matches_played);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles del Equipo:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TeamInfoCard(
                    title: 'Nombre',
                    value: widget.team.commonName,
                    icon: Icons.group,
                  ),
                  TeamInfoCard(
                    title: 'Promedio de Goles General por Partido',
                    value: averageGoals.toStringAsFixed(2),
                    icon: Icons.sports_soccer,
                  ),
                  TeamInfoCard(
                    title: 'Promedio de Tarjetas en General por Partido',
                    value: averageCards.toStringAsFixed(2),
                    icon: Icons.warning_amber,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Estadísticas:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildStatisticsTable(teamData),
                  const SizedBox(height: 20),
                  _buildStatisticsExpansionTile(
                      'Promedio de Goles por Partido en cada temporada',
                      'averageGoals',
                      teamData),
                  _buildStatisticsExpansionTile('Goles', 'goals', teamData),
                  _buildStatisticsExpansionTile('Tarjetas', 'cards', teamData),
                  // Añade un nuevo caso en el método _buildStatisticsExpansionTile
                  _buildStatisticsExpansionTile(
                      'Promedio de Tarjetas por Partido en cada temporada',
                      'averageCards', // Nuevo dataType
                      teamData),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatisticsTable(List<Team> teamData) {
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
              'Partidos',
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
              'Tarjetas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: teamData.map((team) {
          return DataRow(cells: [
            DataCell(Text(team.season.toString())),
            DataCell(Text(team.matches_played.toString())),
            DataCell(Text(team.goals_scored.toString())),
            DataCell(Text(team.cards_total.toString())),
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
      String title, String dataType, List<Team> teamData) {
    return ExpansionTile(
      title: Text(
        title,
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
        _buildChartComparison(teamData, dataType),
      ],
    );
  }

  Widget _buildChartComparison(List<Team> teamData, String dataType) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _selectedChartType == 'Barra'
          ? BarChartSampleTeamComparison(dataType: dataType, teamData: teamData)
          : _selectedChartType == 'Lineal'
              ? LineChartSampleTeamComparison(
                  dataType: dataType, teamData: teamData)
              : PieChartSampleTeamComparison(
                  dataType: dataType, teamData: teamData),
    );
  }
}
