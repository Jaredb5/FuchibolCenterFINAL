import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'teams_model.dart';

class LineChartSampleTeam extends StatelessWidget {
  final Team team;
  final String dataType;

  LineChartSampleTeam({required this.team, required this.dataType});

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lineBarsData = [];

    // Función para crear una línea
    LineChartBarData createLine(List<FlSpot> spots, Color color) {
      return LineChartBarData(
        spots: spots,
        isCurved: true,
        colors: [color],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
      );
    }

    if (dataType == 'matches') {
      lineBarsData = [
        createLine(
            [FlSpot(0, 0), FlSpot(1, team.wins.toDouble())], Colors.green),
        createLine(
            [FlSpot(0, 0), FlSpot(1, team.draws.toDouble())], Colors.amber),
        createLine(
            [FlSpot(0, 0), FlSpot(1, team.losses.toDouble())], Colors.red),
      ];
    } else if (dataType == 'corners') {
      lineBarsData = [
        createLine(
            [FlSpot(0, 0), FlSpot(1, team.corners_total_home.toDouble())],
            Colors.blue),
        createLine(
            [FlSpot(0, 0), FlSpot(1, team.corners_total_away.toDouble())],
            Colors.yellow),
      ];
    } else if (dataType == 'goals') {
      lineBarsData = [
        createLine([FlSpot(0, 0), FlSpot(1, team.goals_scored.toDouble())],
            Colors.blue),
        createLine([FlSpot(0, 0), FlSpot(1, team.goals_conceded.toDouble())],
            Colors.orange),
      ];
    }

    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: _buildTitlesData(dataType),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        minY: 0,
      ),
    );
  }

  FlTitlesData _buildTitlesData(String dataType) {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        getTitles: (value) {
          if (dataType == 'matches') {
            switch (value.toInt()) {
              case 0:
                return 'Inicio';
              case 1:
                return 'Resultado';
              default:
                return '';
            }
          } else if (dataType == 'corners') {
            switch (value.toInt()) {
              case 0:
                return 'Inicio';
              case 1:
                return 'Resultado';
              default:
                return '';
            }
          } else if (dataType == 'goals') {
            switch (value.toInt()) {
              case 0:
                return 'Anotados';
              case 1:
                return 'Recibidos';
              default:
                return '';
            }
          } else {
            return '';
          }
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: 10, // Reducir el número de líneas en el eje Y
        getTitles: (value) {
          if (value % 10 == 0) {
            return value.toInt().toString();
          }
          return '';
        },
      ),
    );
  }
}
