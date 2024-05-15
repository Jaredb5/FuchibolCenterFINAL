import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'teams_model.dart';

class PieChartSampleTeam extends StatelessWidget {
  final Team team;
  final String dataType;

  PieChartSampleTeam({required this.team, required this.dataType});

  // Función para reducir el texto si es necesario
  String truncateText(String text, int maxLength) {
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  // Función para crear las secciones del gráfico circular
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

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];

    if (dataType == 'matches') {
      sections = [
        createSection(team.wins.toDouble(), Colors.green, 'Victorias'),
        createSection(team.draws.toDouble(), Colors.amber, 'Empates'),
        createSection(team.losses.toDouble(), Colors.red, 'Derrotas'),
      ];
    } else if (dataType == 'goals') {
      sections = [
        createSection(team.goals_scored.toDouble(), Colors.blue, 'Anotados'),
        createSection(
            team.goals_conceded.toDouble(), Colors.orange, 'Recibidos'),
      ];
    } else {
      sections = [
        createSection(team.corners_total_home.toDouble(), Colors.blue, 'Casa'),
        createSection(
            team.corners_total_away.toDouble(), Colors.orange, 'Fuera'),
      ];
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
