import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'simple_team_performance_data.dart';

class PieChartSampleTeamComparison extends StatelessWidget {
  final List<SimpleTeamPerformanceData> data;
  final List<String> teamNames;

  const PieChartSampleTeamComparison({
    Key? key,
    required this.data,
    required this.teamNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections = List.generate(data.length, (i) {
      return PieChartSectionData(
        value: data[i].value,
        title: data[i].value.toStringAsFixed(2),
        color: i == 0 ? Colors.blue : Colors.green,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(data.length, (i) {
            return Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: i == 0 ? Colors.blue : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(teamNames[i]),
                const SizedBox(width: 16),
              ],
            );
          }),
        ),
      ],
    );
  }
}
