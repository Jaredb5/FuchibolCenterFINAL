import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_detail.dart';

class PieChartSamplePlayerComparison extends StatelessWidget {
  final List<SimplePerformanceData> data;

  const PieChartSamplePlayerComparison({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> fixedColors = [Colors.blue, Colors.green];

    final List<PieChartSectionData> sections = List.generate(data.length, (i) {
      return PieChartSectionData(
        value: data[i].value,
        title: data[i].value.toStringAsFixed(2),
        color: fixedColors[i % fixedColors.length],
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
