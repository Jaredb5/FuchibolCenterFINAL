import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_detail.dart';

class LineChartSamplePlayerComparison extends StatelessWidget {
  final List<SimplePerformanceData> data;

  const LineChartSamplePlayerComparison({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return const Center(child: Text('Datos insuficientes'));

    final player1 = data[0];
    final player2 = data[1];

    final spots1 = [FlSpot(0, 0), FlSpot(1, player1.value)];
    final spots2 = [FlSpot(0, 0), FlSpot(1, player2.value)];

    final maxY = [player1.value, player2.value].reduce((a, b) => a > b ? a : b) + 0.5;

    return Column(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots1,
                  isCurved: false,
                  colors: [Colors.blue],
                  barWidth: 4,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: spots2,
                  isCurved: false,
                  colors: [Colors.green],
                  barWidth: 4,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    // Solo mostrar punto final como ' '
                    if (value == 1) return '';
                    return '';
                  },
                  getTextStyles: (context, _) => const TextStyle(fontSize: 12),
                  margin: 8,
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, _) => const TextStyle(fontSize: 10),
                  reservedSize: 28,
                  interval: 0.5,
                ),
                topTitles: SideTitles(showTitles: false),
                rightTitles: SideTitles(showTitles: false),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black12),
              ),
              lineTouchData: LineTouchData(enabled: false),
            ),
          ),
        ),

        // Etiquetas numéricas sobre los puntos
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDotWithLabel(Colors.blue, player1.value),
              _buildDotWithLabel(Colors.green, player2.value),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDotWithLabel(Color color, double value) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(value.toStringAsFixed(2)),
      ],
    );
  }
}
