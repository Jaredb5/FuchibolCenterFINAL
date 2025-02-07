import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'teams_model.dart';

class LineChartSampleTeamComparison extends StatelessWidget {
  final String dataType;
  final List<Team> teamData;

  LineChartSampleTeamComparison(
      {required this.dataType, required this.teamData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
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
      spots.add(FlSpot(i.toDouble(), value));
    }

    return Stack(
      children: [
        LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                colors: [Colors.blue],
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.blue,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: _buildTitlesData(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 10,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 1),
                left: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            minY: 0,
            maxY: _calculateMaxY(spots),
            lineTouchData: LineTouchData(
              enabled: false,
            ),
          ),
          swapAnimationDuration: const Duration(milliseconds: 250), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: spots.map((spot) {
                  final x =
                      constraints.maxWidth * (spot.x / (teamData.length - 1));
                  final y = constraints.maxHeight *
                      (1 - (spot.y / _calculateMaxY(spots)));
                  final value =
                      dataType == 'averageGoals' || dataType == 'averageCards'
                          ? spot.y.toStringAsFixed(2)
                          : spot.y.toStringAsFixed(1);

                  return Positioned(
                    left: x,
                    top: y - 12, // Adjust to position the text above the point
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
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
        margin: 10,
        reservedSize: 40,
        getTitles: (double value) {
          if (value.toInt() >= 0 && value.toInt() < teamData.length) {
            return teamData[value.toInt()].season.toString();
          } else {
            return '';
          }
        },
        rotateAngle: 45,
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
        interval: 10,
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
