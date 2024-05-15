import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_model.dart';

class LineChartSamplePlayer extends StatelessWidget {
  final Player player;
  final String dataType;

  LineChartSamplePlayer({required this.player, required this.dataType});

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lineBarsData = [];

    if (dataType == 'goals') {
      // Línea para Goles en Casa
      lineBarsData.add(
        LineChartBarData(
          spots: [
            FlSpot(0, 0), // Comienza en el origen
            FlSpot(1, player.goalsHome.toDouble()),
          ],
          isCurved: true,
          colors: [Colors.blue],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
        ),
      );

      // Línea para Goles de Visitante
      lineBarsData.add(
        LineChartBarData(
          spots: [
            FlSpot(0, 0), // Comienza en el origen
            FlSpot(1, player.goalsAway.toDouble()),
          ],
          isCurved: true,
          colors: [Colors.orange],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
        ),
      );
    } else if (dataType == 'assists') {
      // Línea para Asistencias en Casa
      lineBarsData.add(
        LineChartBarData(
          spots: [
            FlSpot(0, 0), // Comienza en el origen
            FlSpot(1, player.assistsHome.toDouble()),
          ],
          isCurved: true,
          colors: [Colors.green],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
        ),
      );

      // Línea para Asistencias de Visitante
      lineBarsData.add(
        LineChartBarData(
          spots: [
            FlSpot(0, 0), // Comienza en el origen
            FlSpot(1, player.assistsAway.toDouble()),
          ],
          isCurved: true,
          colors: [Colors.pink],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
        ),
      );
    } else if (dataType == 'yellowCards') {
      // Línea para Tarjetas Amarillas
      lineBarsData.add(
        LineChartBarData(
          spots: [
            FlSpot(0, 0), // Comienza en el origen
            FlSpot(1, player.yellowCardsOverall.toDouble()),
          ],
          isCurved: true,
          colors: [Colors.amber],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
        ),
      );
    }

    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: _buildTitlesData(dataType),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        minY: 0, // Asegurarse de que el eje Y comience en 0
      ),
    );
  }

  FlTitlesData _buildTitlesData(String dataType) {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        getTitles: (value) {
          if (dataType == 'goals' || dataType == 'assists') {
            switch (value.toInt()) {
              case 0:
                return 'En Casa';
              case 1:
                return 'De Visitante';
              default:
                return '';
            }
          } else if (dataType == 'yellowCards') {
            return 'Total';
          } else {
            return '';
          }
        },
      ),
      leftTitles: SideTitles(showTitles: true),
    );
  }
}
