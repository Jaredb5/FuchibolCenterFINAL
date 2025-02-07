// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_model.dart';

class BarChartSamplePlayerComparison extends StatelessWidget {
  final String dataType;
  final List<Player> playerData;

  // ignore: prefer_const_constructors_in_immutables
  BarChartSamplePlayerComparison(
      {required this.dataType, required this.playerData});

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

    for (int i = 0; i < playerData.length; i++) {
      Player player = playerData[i];
      double value = 0;
      if (dataType == 'averageGoals') {
        value = player.appearances_overall > 0
            ? player.goalsOverall / player.appearances_overall
            : 0;
      } else if (dataType == 'averageAssists') {
        value = player.appearances_overall > 0
            ? player.assistsOverall / player.appearances_overall
            : 0;
      } else if (dataType == 'averageYellowCards') {
        value = player.appearances_overall > 0
            ? player.yellowCardsOverall / player.appearances_overall
            : 0;
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
                rod.y.toStringAsFixed(2),
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
          if (value.toInt() >= 0 && value.toInt() < playerData.length) {
            return playerData[value.toInt()].season.toString();
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
        interval: 0.5,
        getTitles: (value) {
          if (value % 0.5 == 0) {
            return value.toString();
          } else {
            return '';
          }
        },
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    );
  }
}
