import 'package:flutter/material.dart';
import 'player_model.dart';
import 'bar_chart_player.dart';
import 'line_chart_player.dart';
import 'pie_chart_player.dart';
import 'player_detail.dart';

class PlayerComparisonScreen extends StatefulWidget {
  final Player player1;
  final Player player2;

  const PlayerComparisonScreen({
    Key? key,
    required this.player1,
    required this.player2,
  }) : super(key: key);

  @override
  State<PlayerComparisonScreen> createState() => _PlayerComparisonScreenState();
}

class _PlayerComparisonScreenState extends State<PlayerComparisonScreen> {
  String selectedView = 'Tabla';
  String selectedChart = 'Barra';
  String selectedMetric = 'Goles';

  double calculateAverage(int total, int matches) {
    return matches > 0 ? total / matches : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final p1 = widget.player1;
    final p2 = widget.player2;

    final data = {
      'Goles': [
        SimplePerformanceData(p1.fullName, calculateAverage(p1.goalsOverall, p1.appearances_overall)),
        SimplePerformanceData(p2.fullName, calculateAverage(p2.goalsOverall, p2.appearances_overall)),
      ],
      'Asistencias': [
        SimplePerformanceData(p1.fullName, calculateAverage(p1.assistsOverall, p1.appearances_overall)),
        SimplePerformanceData(p2.fullName, calculateAverage(p2.assistsOverall, p2.appearances_overall)),
      ],
      'Tarjetas': [
        SimplePerformanceData(p1.fullName, calculateAverage(p1.yellowCardsOverall + p1.redCardsOverall, p1.appearances_overall)),
        SimplePerformanceData(p2.fullName, calculateAverage(p2.yellowCardsOverall + p2.redCardsOverall, p2.appearances_overall)),
      ]
    };

    final tableDataPlayer1 = [
      SimplePerformanceData('Goles', data['Goles']![0].value),
      SimplePerformanceData('Asistencias', data['Asistencias']![0].value),
      SimplePerformanceData('Tarjetas', data['Tarjetas']![0].value),
    ];

    final tableDataPlayer2 = [
      SimplePerformanceData('Goles', data['Goles']![1].value),
      SimplePerformanceData('Asistencias', data['Asistencias']![1].value),
      SimplePerformanceData('Tarjetas', data['Tarjetas']![1].value),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Comparación de Jugadores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildViewSelector(),
            const SizedBox(height: 20),
            Expanded(
              child: selectedView == 'Tabla'
                  ? _buildComparisonTable(p1.fullName, p2.fullName, tableDataPlayer1, tableDataPlayer2)
                  : _buildChart(data[selectedMetric]!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Visualización', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedView,
              items: ['Tabla', 'Gráfico'].map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => setState(() => selectedView = val!),
            ),
            if (selectedView == 'Gráfico') ...[
              const SizedBox(width: 20),
              DropdownButton<String>(
                value: selectedChart,
                items: ['Barra', 'Lineal', 'Circular'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (val) => setState(() => selectedChart = val!),
              ),
              const SizedBox(width: 20),
              DropdownButton<String>(
                value: selectedMetric,
                items: ['Goles', 'Asistencias', 'Tarjetas'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (val) => setState(() => selectedMetric = val!),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildChart(List<SimplePerformanceData> data) {
    final chartWidget = () {
      switch (selectedChart) {
        case 'Lineal':
          return LineChartSamplePlayerComparison(data: data);
        case 'Circular':
          return PieChartSamplePlayerComparison(data: data);
        case 'Barra':
        default:
          return BarChartSamplePlayerComparison(
            data: data,
            barColors: [Colors.blue, Colors.green],
          );
      }
    }();

    return Column(
      children: [
        const SizedBox(height: 10),
        _buildLegend(),
        const SizedBox(height: 10),
        Expanded(child: chartWidget),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.blue, widget.player1.fullName),
        const SizedBox(width: 16),
        _legendItem(Colors.green, widget.player2.fullName),
      ],
    );
  }

  Widget _legendItem(Color color, String name) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(name),
      ],
    );
  }

  Widget _buildComparisonTable(
    String name1,
    String name2,
    List<SimplePerformanceData> p1,
    List<SimplePerformanceData> p2,
  ) {
    return Table(
      border: TableBorder.all(color: Colors.blueAccent),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        _buildHeaderRow('Métrica', name1, name2),
        for (int i = 0; i < p1.length; i++)
          _buildDataRow(p1[i].label, p1[i].value, p2[i].value),
      ],
    );
  }

  TableRow _buildHeaderRow(String label, String p1, String p2) {
    return TableRow(children: [
      _buildCell(label, isHeader: true),
      _buildCell(p1, isHeader: true),
      _buildCell(p2, isHeader: true),
    ]);
  }

  TableRow _buildDataRow(String label, double val1, double val2) {
    Color color1 = val1 > val2 ? Colors.green : Colors.red;
    Color color2 = val2 > val1 ? Colors.green : Colors.red;

    return TableRow(children: [
      _buildCell(label),
      _buildCell(val1.toStringAsFixed(2), color: color1),
      _buildCell(val2.toStringAsFixed(2), color: color2),
    ]);
  }

  Widget _buildCell(String text, {bool isHeader = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}