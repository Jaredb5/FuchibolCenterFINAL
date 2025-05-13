import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'simple_team_performance_data.dart';

class BarChartSampleTeamComparison extends StatelessWidget {
  final List<SimpleTeamPerformanceData> data;
  final List<Color> barColors;

  const BarChartSampleTeamComparison({
    Key? key,
    required this.data,
    required this.barColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxY = data.map((d) => d.value).fold(0.0, (a, b) => a > b ? a : b);
    if (maxY == 0.0) maxY = 1.0;

    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < data.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: data[i].value,
              colors: [barColors[i]],
              width: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY + 0.2,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) => '',
            getTextStyles: (context, _) => const TextStyle(fontSize: 10),
            margin: 10,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTitles: (value) => value.toStringAsFixed(1),
            getTextStyles: (context, _) => const TextStyle(fontSize: 10),
            reservedSize: 28,
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey.shade800,
            getTooltipItem: (group, _, rod, __) {
              return BarTooltipItem(
                '${data[group.x.toInt()].label}: ${rod.y.toStringAsFixed(2)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }
}
