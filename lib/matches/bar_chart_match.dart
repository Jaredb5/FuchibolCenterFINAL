import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'match_model.dart';

class BarChartSampleMatchComparison extends StatelessWidget {
  final String dataType;
  final List<Match> matchData;

  BarChartSampleMatchComparison(
      {required this.dataType, required this.matchData});

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    List<BarChartGroupData> barGroups = [];

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
        showingTooltipIndicators: [0],
      );
    }

    for (int i = 0; i < matchData.length; i++) {
      Match match = matchData[i];
      double value = 0;
      if (dataType == 'goals') {
        value =
            double.parse(match.homeTeamGoal) + double.parse(match.awayTeamGoal);
      } else if (dataType == 'corners') {
        value = double.parse(match.homeTeamCorner) +
            double.parse(match.awayTeamCorner);
      } else if (dataType == 'cards') {
        value = double.parse(match.homeTeamYellowCards) +
            double.parse(match.homeTeamRedCards) +
            double.parse(match.awayTeamYellowCards) +
            double.parse(match.awayTeamRedCards);
      }
      barGroups.add(createBarChartGroup(i, value, Colors.blue));
      if (value > maxY) maxY = value;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
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
                rod.y.toInt().toString(),
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
        margin: 32,
        interval: 1,
        rotateAngle: 45,
        getTitles: (double value) {
          if (value.toInt() >= 0 && value.toInt() < matchData.length) {
            return matchData[value.toInt()].dateGMT;
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
          return value.toString();
        },
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    );
  }
}
