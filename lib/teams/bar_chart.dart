import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'teams_model.dart';

class BarChartSampleTeam extends StatelessWidget {
  final Team team;
  final String dataType;

  BarChartSampleTeam({super.key, required this.team, required this.dataType});

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    List<BarChartGroupData> barGroups = [];

    // Función para generar las barras con etiquetas
    BarChartGroupData createBarChartGroup(int x, double y, Color color) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            y: y,
            colors: [color],
            width: 22,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        showingTooltipIndicators: [
          0
        ], // Para mostrar las etiquetas en el gráfico
      );
    }

    if (dataType == 'matches') {
      maxY = team.matches_played.toDouble();
      barGroups = [
        createBarChartGroup(0, team.wins.toDouble(), Colors.green),
        createBarChartGroup(1, team.draws.toDouble(), Colors.amber),
        createBarChartGroup(2, team.losses.toDouble(), Colors.red),
      ];
    } else if (dataType == 'goals') {
      maxY = [team.goals_scored.toDouble(), team.goals_conceded.toDouble()]
          .reduce((a, b) => a > b ? a : b);
      barGroups = [
        createBarChartGroup(0, team.goals_scored.toDouble(), Colors.blue),
        createBarChartGroup(1, team.goals_conceded.toDouble(), Colors.orange),
      ];
    } else if (dataType == 'corners') {
      maxY = team.corners_total.toDouble();
      barGroups = [
        createBarChartGroup(0, team.corners_total_home.toDouble(), Colors.pink),
        createBarChartGroup(
            1, team.corners_total_away.toDouble(), Colors.yellow),
      ];
    } else {
      barGroups = [];
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barGroups: barGroups,
        titlesData: _buildTitlesData(dataType),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipMargin: 0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.toInt().toString(), // Convertir el valor a entero
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  FlTitlesData _buildTitlesData(String dataType) {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 16,
        getTitles: (double value) {
          if (dataType == 'matches') {
            switch (value.toInt()) {
              case 0:
                return 'Victorias';
              case 1:
                return 'Empates';
              case 2:
                return 'Derrotas';
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
          } else if (dataType == 'corners') {
            switch (value.toInt()) {
              case 0:
                return 'Corners en casa';
              case 1:
                return 'Corners fuera';
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
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        margin: 10,
        reservedSize: 28,
        getTitles: (value) {
          return '$value';
        },
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    );
  }
}
