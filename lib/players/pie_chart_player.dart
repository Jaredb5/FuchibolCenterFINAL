import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_model.dart';

class PieChartSamplePlayer extends StatelessWidget {
  final Player player;
  final String dataType;

  PieChartSamplePlayer({required this.player, required this.dataType});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections;

    // Helper function para reducir el texto si es necesario
    String truncateText(String text, int maxLength) {
      return text.length <= maxLength
          ? text
          : '${text.substring(0, maxLength)}...';
    }

    PieChartSectionData createSection(double value, Color color, String label) {
      return PieChartSectionData(
        value: value,
        color: color,
        title:
            '${value.toInt()}\n${truncateText(label, 10)}', // Mostrar solo números enteros
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12, // Tamaño de texto más pequeño
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6, // Ajustar posición del texto
      );
    }

    if (dataType == 'goals') {
      sections = [
        createSection(player.goalsHome.toDouble(), Colors.blue, 'Goles Casa'),
        createSection(
            player.goalsAway.toDouble(), Colors.orange, 'Goles Fuera'),
      ];
    } else if (dataType == 'assists') {
      sections = [
        createSection(
            player.assistsHome.toDouble(), Colors.green, 'Asistencias Casa'),
        createSection(
            player.assistsAway.toDouble(), Colors.pink, 'Asistencias Fuera'),
      ];
    } else if (dataType == 'yellowCards') {
      sections = [
        createSection(player.yellowCardsOverall.toDouble(), Colors.amber,
            'Tarjetas Amarillas'),
      ];
    } else {
      sections = [];
    }

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {}),
      ),
    );
  }
}
