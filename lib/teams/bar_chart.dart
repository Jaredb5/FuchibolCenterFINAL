import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'teams_model.dart';

class BarChartSampleTeamComparison extends StatelessWidget {
  final String dataType;
  final List<Team> teamData;

  BarChartSampleTeamComparison(
      {required this.dataType, required this.teamData});

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    List<BarChartGroupData> barGroups = [];

    BarChartGroupData createBarChartGroup(int x, double y, Color color) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            y: y.roundToDouble(), // Redondear al entero más cercano
            colors: [color],
            width: 22,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }

    for (int i = 0; i < teamData.length; i++) {
      Team team = teamData[i];
      double value = 0;
      if (dataType == 'matches') {
        value = team.matches_played.toDouble();
      } else if (dataType == 'goals') {
        value = team.goals_scored.toDouble();
      } else if (dataType == 'cards') {
        value = team.cards_total.toDouble();
      } else if (dataType == 'averageGoals') {
        value = team.matches_played > 0
            ? team.goals_scored.toDouble() / team.matches_played
            : 0;
      } else if (dataType == 'averageCards') {
        value = team.matches_played > 0
            ? team.cards_total.toDouble() / team.matches_played
            : 0;
      }
      value = value.roundToDouble(); // Asegurarse de que el valor sea un entero
      barGroups.add(createBarChartGroup(i, value, Colors.blue));
      if (value > maxY) maxY = value;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxY + 1).roundToDouble(), // Redondear también el valor máximo
        barGroups: barGroups,
        titlesData: _buildTitlesData(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipMargin: 0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.toInt().toString(), // Mostrar como entero
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
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        margin: 8,
        interval: 1,
        rotateAngle: 45,
        getTitles: (double value) {
          if (value.toInt() >= 0 && value.toInt() < teamData.length) {
            return teamData[value.toInt()].season.toString();
          } else {
            return '';
          }
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: 10,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        margin: 10,
        reservedSize: 28,
        getTitles: (value) {
          return value.toInt().toString(); // Mostrar sólo enteros en el eje Y
        },
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    );
  }
}
