// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'player_model.dart';
import 'bar_chart_player.dart';
import 'line_chart_player.dart';
import 'pie_chart_player.dart';

enum ChartType { barra, lineal, circular }

class PlayerDetailsScreen extends StatefulWidget {
  final Player player;

  const PlayerDetailsScreen({Key? key, required this.player}) : super(key: key);

  @override
  _PlayerDetailsScreenState createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  ChartType _selectedChartType = ChartType.barra;
  bool _isChartVisible = false;

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
        return BarChartSamplePlayer(player: widget.player, dataType: dataType);
      case ChartType.lineal:
        return LineChartSamplePlayer(player: widget.player, dataType: dataType);
      case ChartType.circular:
        return PieChartSamplePlayer(player: widget.player, dataType: dataType);
      default:
        return Container();
    }
  }

  DropdownButton<ChartType> _buildDropdown(ChartType selectedChartType, ValueChanged<ChartType?> onChanged) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.fullName),
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
              title: 'Temporada',
              value: widget.player.season.toString(),
              icon: Icons.calendar_today,
            ),
            PlayerInfoCard(
              title: 'Posición',
              value:widget.player.position,
              icon: Icons.directions_run,
            ),
            PlayerInfoCard(
              title: 'Club Actual',
              value:widget.player.currentClub,
              icon: Icons.home_work,
            ),
            PlayerInfoCard(
              title: 'Nacionalidad',
              value: widget.player.nationality,
              icon: Icons.flag, 
            ),
            PlayerInfoCard(
              title: 'Apariciones',
              value: widget.player.appearances_overall.toString(),
              icon: Icons.flag,
            ),
            _buildStatisticsExpansionTile('Goles', 'goals'),
            PlayerInfoCard(
              title: 'Goles Totales',
              value: widget.player.goalsOverall.toString(),
              icon: Icons.sports_soccer,
            ),
            PlayerInfoCard(
              title: 'Goles en Casa',
              value: widget.player.goalsHome.toString(),
              icon: Icons.sports_soccer,
            ),
            PlayerInfoCard(
              title: 'Goles de Visitante',
              value: widget.player.goalsAway.toString(),
              icon: Icons.sports_soccer,
            ),
            _buildStatisticsExpansionTile('Asistencias', 'assists'),
            PlayerInfoCard(
              title: 'Asistencias Totales',
              value: widget.player.assistsOverall.toString(),
              icon: Icons.assistant,
            ),
            PlayerInfoCard(
              title: 'Asistencias en Casa',
              value: widget.player.assistsHome.toString(),
              icon: Icons.assistant,
            ),
            PlayerInfoCard(
              title: 'Asistencias de Visitante',
              value: widget.player.assistsAway.toString(),
              icon: Icons.assistant,
            ),
            _buildStatisticsExpansionTile('Tarjetas Amarillas', 'yellowCards'),
            PlayerInfoCard(
              title: 'Tarjetas Amarillas',
              value: widget.player.yellowCardsOverall.toString(),
              icon: Icons.warning_amber,
            ),
            PlayerInfoCard(
              title: 'Tarjetas Rojas',
              value: widget.player.redCardsOverall.toString(),
              icon: Icons.cancel,
            ),
          ],
        ),
      ),
    )
    );
  }

  ExpansionTile _buildStatisticsExpansionTile(String title, String dataType) {
    return ExpansionTile(
      title: Text('Estadísticas de $title'),
      initiallyExpanded: _isChartVisible,
      onExpansionChanged: (expanded) {
        setState(() => _isChartVisible = expanded);
      },
      children: [
        _buildDropdown(_selectedChartType, (ChartType? newValue) {
          setState(() {
            _selectedChartType = newValue!;
          });
        }),
        if (_isChartVisible)
          SizedBox(height: 200, child: _buildChart(_selectedChartType, dataType)),
      ],
    );
  }
}

class PlayerInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const PlayerInfoCard({
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
