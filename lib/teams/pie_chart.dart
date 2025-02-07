import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'teams_model.dart';

class PieChartSampleTeamComparison extends StatelessWidget {
  final String dataType;
  final List<Team> teamData;

  PieChartSampleTeamComparison({required this.dataType, required this.teamData});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];

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
