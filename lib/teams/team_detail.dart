import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'bar_chart.dart';
import 'line_chart.dart';
import 'pie_chart.dart';

enum ChartType { barra, lineal, circular }

class TeamDetailsScreen extends StatefulWidget {
  final Team team;

  const TeamDetailsScreen({Key? key, required this.team}) : super(key: key);

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  ChartType _selectedChartTypeMatches = ChartType.barra;
  ChartType _selectedChartTypeGoals = ChartType.barra;
  bool _isMatchesChartVisible = false;
  bool _isGoalsChartVisible = false;

  String _chartTypeToDisplayString(ChartType chartType) {
    switch (chartType) {
      case ChartType.barra:
        return 'Gráfico de Barra';
      case ChartType.lineal:
        return 'Gráfico Lineal';
      case ChartType.circular:
        return 'Gráfico Circular';
      default:
        return '';
    }
  }

  Widget _buildChart(ChartType chartType, String dataType) {
    switch (chartType) {
      case ChartType.barra:
        return BarChartSampleTeam(team: widget.team, dataType: dataType);
      case ChartType.lineal:
        return LineChartSampleTeam(team: widget.team, dataType: dataType);
      case ChartType.circular:
        return PieChartSampleTeam(team: widget.team, dataType: dataType);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.team.commonName),
        ),
        body: Scrollbar(
          thumbVisibility: true,
          thickness: 6.0,
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
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
                  title: 'Temporada',
                  value: widget.team.season.toString(),
                  icon: Icons.calendar_today,
                ),
                ExpansionTile(
                  title: const Text('Estadísticas de Partidos'),
                  initiallyExpanded: _isMatchesChartVisible,
                  onExpansionChanged: (expanded) {
                    setState(() => _isMatchesChartVisible = expanded);
                  },
                  children: [
                    _buildDropdown(_selectedChartTypeMatches,
                        (ChartType? newValue) {
                      setState(() {
                        _selectedChartTypeMatches = newValue!;
                      });
                    }),
                    if (_isMatchesChartVisible)
                      SizedBox(
                          height: 200,
                          child: _buildChart(
                              _selectedChartTypeMatches, "matches")),
                  ],
                ),
                TeamInfoCard(
                  title: 'Partidos Jugados en Casa',
                  value: widget.team.matches_played_home.toString(),
                  icon: Icons.home,
                ),
                TeamInfoCard(
                  title: 'Partidos Jugados Fuera',
                  value: widget.team.matches_played_away.toString(),
                  icon: Icons.directions_run,
                ),
                TeamInfoCard(
                  title: 'Victorias en Casa',
                  value: widget.team.wins_home.toString(),
                  icon: Icons.home,
                ),
                TeamInfoCard(
                  title: 'Victorias Fuera',
                  value: widget.team.wins_away.toString(),
                  icon: Icons.directions_run,
                ),
                TeamInfoCard(
                  title: 'Empates en Casa',
                  value: widget.team.draws_home.toString(),
                  icon: Icons.home,
                ),
                TeamInfoCard(
                  title: 'Empates Fuera',
                  value: widget.team.draws_away.toString(),
                  icon: Icons.directions_run,
                ),
                TeamInfoCard(
                  title: 'Derrotas en Casa',
                  value: widget.team.losses_home.toString(),
                  icon: Icons.home,
                ),
                TeamInfoCard(
                  title: 'Derrotas Fuera',
                  value: widget.team.losses_away.toString(),
                  icon: Icons.directions_run,
                ),
                ExpansionTile(
                  title: const Text('Estadísticas de Goles'),
                  initiallyExpanded: _isGoalsChartVisible,
                  onExpansionChanged: (expanded) {
                    setState(() => _isGoalsChartVisible = expanded);
                  },
                  children: [
                    _buildDropdown(_selectedChartTypeGoals,
                        (ChartType? newValue) {
                      setState(() {
                        _selectedChartTypeGoals = newValue!;
                      });
                    }),
                    if (_isGoalsChartVisible)
                      SizedBox(
                          height: 200,
                          child: _buildChart(_selectedChartTypeGoals, "goals")),
                  ],
                ),
                TeamInfoCard(
                  title: 'Posición en la Liga',
                  value: widget.team.league_position.toString(),
                  icon: Icons.leaderboard,
                ),
                TeamInfoCard(
                  title: 'Diferencia de Goles',
                  value: widget.team.goals_difference.toString(),
                  icon: Icons.show_chart,
                ),
                ExpansionTile(
                  title: const Text('Estadísticas de Corners'),
                  initiallyExpanded: _isGoalsChartVisible,
                  onExpansionChanged: (expanded) {
                    setState(() => _isGoalsChartVisible = expanded);
                  },
                  children: [
                    _buildDropdown(_selectedChartTypeGoals,
                        (ChartType? newValue) {
                      setState(() {
                        _selectedChartTypeGoals = newValue!;
                      });
                    }),
                    if (_isGoalsChartVisible)
                      SizedBox(
                          height: 350,
                          child:
                              _buildChart(_selectedChartTypeGoals, "corners")),
                  ],
                ),
                TeamInfoCard(
                  title: 'Córners en Casa',
                  value: widget.team.corners_total_home.toString(),
                  icon: Icons.home,
                ),
                TeamInfoCard(
                  title: 'Córners Fuera',
                  value: widget.team.corners_total_away.toString(),
                  icon: Icons.directions_run,
                ),
                TeamInfoCard(
                  title: 'Total de Tarjetas',
                  value: widget.team.cards_total.toString(),
                  icon: Icons.warning_amber,
                ),
                TeamInfoCard(
                  title: 'Tarjetas en Casa',
                  value: widget.team.cards_total_home.toString(),
                  icon: Icons.home,
                ),
                TeamInfoCard(
                  title: 'Tarjetas Fuera',
                  value: widget.team.cards_total_away.toString(),
                  icon: Icons.directions_run,
                ),
              ],
            ),
          ),
        ));
  }

  DropdownButton<ChartType> _buildDropdown(
      ChartType selectedChartType, ValueChanged<ChartType?> onChanged) {
    return DropdownButton<ChartType>(
      value: selectedChartType,
      onChanged: onChanged,
      items: ChartType.values.map((ChartType type) {
        return DropdownMenuItem<ChartType>(
          value: type,
          child: Text(_chartTypeToDisplayString(type)),
        );
      }).toList(),
    );
  }
}

class TeamInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const TeamInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title: $value',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
