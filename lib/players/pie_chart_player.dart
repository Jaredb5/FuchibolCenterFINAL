import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_model.dart';

class PieChartSamplePlayerComparison extends StatelessWidget {
  final String dataType;
  final List<Player> playerData;

  PieChartSamplePlayerComparison({required this.dataType, required this.playerData});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];

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
      sections.add(PieChartSectionData(
        value: value,
        color: Colors.primaries[i % Colors.primaries.length],
        title: value.toStringAsFixed(2),
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          touchCallback: (PieTouchResponse? pieTouchResponse) {
            if (pieTouchResponse != null &&
                pieTouchResponse.touchedSection != null) {
              print("Se tocó una sección: ${pieTouchResponse.touchedSection!.touchedSectionIndex}");
            }
          },
        ),
      ),
    );
  }
}
