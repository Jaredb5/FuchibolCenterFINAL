import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'match_model.dart';

class PieChartSampleMatchComparison extends StatelessWidget {
  final String dataType;
  final List<Match> matchData;

  PieChartSampleMatchComparison(
      {required this.dataType, required this.matchData});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];

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
      sections.add(PieChartSectionData(
        value: value,
        color: Colors.primaries[i % Colors.primaries.length],
        title: match.dateGMT,
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
              print(
                  "Se tocó una sección del gráfico: ${pieTouchResponse.touchedSection!.touchedSectionIndex}");
            }
          },
        ),
      ),
    );
  }
}
