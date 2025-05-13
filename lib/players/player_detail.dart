import 'package:flutter/material.dart';
import 'player_model.dart';
import 'data_player.dart';
import 'bar_chart_player.dart';
import 'line_chart_player.dart';
import 'pie_chart_player.dart';
import 'player_info_card.dart';

class SimplePerformanceData {
  final String label;
  final double value;

  SimplePerformanceData(this.label, this.value);
}

class PlayerDetailsScreen extends StatefulWidget {
  final Player player;

  const PlayerDetailsScreen({Key? key, required this.player}) : super(key: key);

  @override
  _PlayerDetailsScreenState createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  String _selectedViewType = 'Tabla';
  String _selectedChartType = 'Barra';

  List<Player> allPlayerData = [];
  List<Player> playerSeasons = [];
  Player? selectedSeason;

  double goalsPerMatch = 0.0;
  double assistsPerMatch = 0.0;
  double cardsPerMatch = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendimiento del jugador'),
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
              child: Text('No hay datos disponibles para este jugador.'),
            );
          } else {
            allPlayerData = snapshot.data!;
            playerSeasons = getPlayerSeasons(widget.player.fullName);

            if (selectedSeason == null && playerSeasons.isNotEmpty) {
              selectedSeason = playerSeasons.first;
              _calculatePerformance();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerHeader(),
                  const SizedBox(height: 20),
                  _buildSeasonDropdown(),
                  const SizedBox(height: 20),
                  _buildViewSelector(),
                  const SizedBox(height: 20),
                  _selectedViewType == 'Tabla'
                      ? _buildPerformanceTable()
                      : Column(
                          children: [
                            _buildChartTypeSelector(),
                            const SizedBox(height: 10),
                            SizedBox(height: 300, child: _buildChartPerformance()),
                          ],
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<Player> getPlayerSeasons(String name) {
    return allPlayerData
        .where((p) => p.fullName == name)
        .toList()
      ..sort((a, b) => b.season.compareTo(a.season));
  }

  void _calculatePerformance() {
    if (selectedSeason == null) return;

    final matches = selectedSeason!.appearances_overall;
    goalsPerMatch = _safeDivide(selectedSeason!.goalsOverall, matches);
    assistsPerMatch = _safeDivide(selectedSeason!.assistsOverall, matches);
    cardsPerMatch = _safeDivide(
      selectedSeason!.yellowCardsOverall + selectedSeason!.redCardsOverall,
      matches,
    );
  }

  double _safeDivide(int total, int matches) {
    return matches > 0 ? total / matches : 0.0;
  }

  Widget _buildPlayerHeader() {
    if (selectedSeason == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlayerInfoCard(
          title: 'Nombre',
          value: widget.player.fullName,
          icon: Icons.person,
        ),
        PlayerInfoCard(
          title: 'Edad',
          value: '${selectedSeason!.age}',
          icon: Icons.cake,
        ),
        PlayerInfoCard(
          title: 'Liga',
          value: selectedSeason!.league,
          icon: Icons.sports,
        ),
        PlayerInfoCard(
          title: 'Temporada',
          value: selectedSeason!.season.toString(),
          icon: Icons.calendar_month,
        ),
        PlayerInfoCard(
          title: 'Posición',
          value: selectedSeason!.position,
          icon: Icons.directions_run,
        ),
        PlayerInfoCard(
          title: 'Nacionalidad',
          value: selectedSeason!.nationality,
          icon: Icons.flag,
        ),
        PlayerInfoCard(
          title: 'Club actual',
          value: selectedSeason!.currentClub,
          icon: Icons.shield,
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
              items: playerSeasons.map((p) {
                return DropdownMenuItem<int>(
                  value: p.season,
                  child: Text('Temporada ${p.season}'),
                );
              }).toList(),
              onChanged: (int? newYear) {
                setState(() {
                  selectedSeason =
                      playerSeasons.firstWhere((p) => p.season == newYear);
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

  Widget _buildChartTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de gráfico',
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
              value: _selectedChartType,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: ['Barra', 'Lineal', 'Circular'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedChartType = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

Widget _buildChartPerformance() {
  final chartData = _buildChartData();

  switch (_selectedChartType) {
    case 'Lineal':
      return LineChartSamplePlayerComparison(data: chartData);
    case 'Circular':
      return PieChartSamplePlayerComparison(data: chartData);
    case 'Barra':
    default:
      return BarChartSamplePlayerComparison(
        data: chartData,
        barColors: List.generate(chartData.length, (index) => Colors.blue),
      );
  }
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
          _buildTableRow('Goles por partido', goalsPerMatch.toStringAsFixed(2)),
          _buildTableRow('Asistencias por partido', assistsPerMatch.toStringAsFixed(2)),
          _buildTableRow('Tarjetas por partido', cardsPerMatch.toStringAsFixed(2)),
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

  List<SimplePerformanceData> _buildChartData() {
    return [
      SimplePerformanceData('Goles', goalsPerMatch),
      SimplePerformanceData('Asistencias', assistsPerMatch),
      SimplePerformanceData('Tarjetas', cardsPerMatch),
    ];
  }
}
