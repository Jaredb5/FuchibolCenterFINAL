import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'data_teams.dart';
import 'bar_chart.dart';
import 'team_info_card.dart';
import 'simple_team_performance_data.dart';


class TeamDetailsScreen extends StatefulWidget {
  final Team team;

  const TeamDetailsScreen({Key? key, required this.team}) : super(key: key);

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  String _selectedViewType = 'Tabla';

  List<Team> allTeams = [];
  List<Team> seasons = [];
  Team? selectedSeason;

  double avgWins = 0;
  double avgDraws = 0;
  double avgLosses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rendimiento de ${widget.team.commonName}'),
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
              child: Text('No hay datos disponibles para este equipo.'),
            );
          } else {
            allTeams = snapshot.data!;
            seasons = allTeams
                .where((t) => t.commonName == widget.team.commonName)
                .toList()
              ..sort((a, b) => b.season.compareTo(a.season));

            if (selectedSeason == null && seasons.isNotEmpty) {
              selectedSeason = seasons.first;
              _calculatePerformance();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTeamHeader(),
                  const SizedBox(height: 20),
                  _buildSeasonDropdown(),
                  const SizedBox(height: 20),
                  _buildViewSelector(),
                  const SizedBox(height: 20),
                  _selectedViewType == 'Tabla'
                      ? _buildPerformanceTable()
                      : SizedBox(
                          height: 300,
                          child: BarChartSampleTeamComparison(
                          data: _buildChartData(),
                          barColors: [Colors.blue, Colors.green, Colors.orange], // puedes personalizar
                        ),
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _calculatePerformance() {
    if (selectedSeason == null) return;
    final matches = selectedSeason!.matches_played;
    avgWins = _safeDivide(selectedSeason!.wins, matches);
    avgDraws = _safeDivide(selectedSeason!.draws, matches);
    avgLosses = _safeDivide(selectedSeason!.losses, matches);
  }

  double _safeDivide(int value, int matches) {
    return matches > 0 ? value / matches : 0.0;
  }

  Widget _buildTeamHeader() {
  if (selectedSeason == null) {
    return const Center(
      child: Text('No hay datos para mostrar del equipo.'),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TeamInfoCard(
        title: 'Nombre',
        value: selectedSeason!.commonName,
        icon: Icons.group,
      ),
      TeamInfoCard(
        title: 'Temporada',
        value: selectedSeason!.season.toString(),
        icon: Icons.calendar_today,
      ),
      TeamInfoCard(
        title: 'Partidos Jugados',
        value: selectedSeason!.matches_played.toString(),
        icon: Icons.sports_soccer,
      ),
      TeamInfoCard(
        title: 'Victorias',
        value: selectedSeason!.wins.toString(),
        icon: Icons.military_tech,
      ),
      TeamInfoCard(
        title: 'Empates',
        value: selectedSeason!.draws.toString(),
        icon: Icons.handshake,
      ),
      TeamInfoCard(
        title: 'Derrotas',
        value: selectedSeason!.losses.toString(),
        icon: Icons.cancel,
      ),
    ],
  );
}


  Widget _buildSeasonDropdown() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Seleccionar temporada',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: selectedSeason?.season,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: seasons.map((t) {
              return DropdownMenuItem<int>(
                value: t.season,
                child: Text('Temporada ${t.season}'),
              );
            }).toList(),
            onChanged: (int? newYear) {
              setState(() {
                selectedSeason =
                    seasons.firstWhere((t) => t.season == newYear);
                _calculatePerformance();
              });
            },
          ),
        ),
      ),
    ],
  );
}

Widget _buildViewSelector() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Visualización',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedViewType,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: ['Tabla', 'Gráfica'].map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedViewType = value!;
              });
            },
          ),
        ),
      ),
    ],
  );
}


  Widget _buildPerformanceTable() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue.shade100),
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
      },
      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.blue.shade50),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.blue.shade100),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Métrica',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Promedio',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          ],
        ),
        _buildTableRow('Victorias por partido', avgWins.toStringAsFixed(2)),
        _buildTableRow('Empates por partido', avgDraws.toStringAsFixed(2)),
        _buildTableRow('Derrotas por partido', avgLosses.toStringAsFixed(2)),
      ],
    ),
  );
}


  TableRow _buildTableRow(String label, String value) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(label),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value),
    ),
  ]);
}


  List<SimpleTeamPerformanceData> _buildChartData() {
    return [
      SimpleTeamPerformanceData('Victorias', avgWins),
      SimpleTeamPerformanceData('Empates', avgDraws),
      SimpleTeamPerformanceData('Derrotas', avgLosses),
    ];
  }
}
