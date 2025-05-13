import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_detail.dart';

class BarChartSamplePlayerComparison extends StatelessWidget {
  final List<SimplePerformanceData> data;
  final List<Color> barColors;

  const BarChartSamplePlayerComparison({
    Key? key,
    required this.data,
    required this.barColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxY = data.map((d) => d.value).fold(0.0, (a, b) => a > b ? a : b);
    if (maxY == 0.0) maxY = 1.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY + 0.5,
        barGroups: List.generate(data.length, (i) {
          return BarChartGroupData(
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
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) => '', // Quita nombres extensos
            getTextStyles: (context, _) => const TextStyle(fontSize: 12),
            margin: 10,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTextStyles: (context, _) => const TextStyle(fontSize: 10),
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.toStringAsFixed(2),
                TextStyle(color: barColors[group.x.toInt()]),
              );
            },
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
