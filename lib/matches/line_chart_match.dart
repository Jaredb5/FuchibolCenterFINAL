import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'match_model.dart';

class LineChartSampleMatchComparison extends StatelessWidget {
  final String dataType;
  final List<Match> matchData;

  LineChartSampleMatchComparison(
      {required this.dataType, required this.matchData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

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
      spots.add(FlSpot(i.toDouble(), value));
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            colors: [Colors.blue],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
          ),
        ],
        titlesData: _buildTitlesData(),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        minY: 0,
        maxY: _calculateMaxY(spots),
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
          fontSize: 14,
        ),
        margin: 16,
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

  double _calculateMaxY(List<FlSpot> spots) {
    double maxY = 0;
    for (var spot in spots) {
      if (spot.y > maxY) {
        maxY = spot.y;
      }
    }
    return maxY + 1;
  }
}
