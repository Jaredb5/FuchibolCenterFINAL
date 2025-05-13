import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'bar_chart.dart';
import 'line_chart.dart';
import 'pie_chart.dart';
import 'simple_team_performance_data.dart';



class TeamComparisonScreen extends StatefulWidget {
  final Team team1;
  final Team team2;

  const TeamComparisonScreen({
    Key? key,
    required this.team1,
    required this.team2,
  }) : super(key: key);

  @override
  State<TeamComparisonScreen> createState() => _TeamComparisonScreenState();
}

class _TeamComparisonScreenState extends State<TeamComparisonScreen> {
  String selectedView = 'Tabla';
  String selectedChart = 'Barra';
  String selectedMetric = 'Victorias';

  double _safeDivide(int value, int total) {
    return total > 0 ? value / total : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final t1 = widget.team1;
    final t2 = widget.team2;

    final data = {
      'Victorias': [
        SimpleTeamPerformanceData(t1.commonName, _safeDivide(t1.wins, t1.matches_played)),
        SimpleTeamPerformanceData(t2.commonName, _safeDivide(t2.wins, t2.matches_played)),
      ],
      'Empates': [
        SimpleTeamPerformanceData(t1.commonName, _safeDivide(t1.draws, t1.matches_played)),
        SimpleTeamPerformanceData(t2.commonName, _safeDivide(t2.draws, t2.matches_played)),
      ],
      'Derrotas': [
        SimpleTeamPerformanceData(t1.commonName, _safeDivide(t1.losses, t1.matches_played)),
        SimpleTeamPerformanceData(t2.commonName, _safeDivide(t2.losses, t2.matches_played)),
      ],
    };

    final tableData1 = [
      SimpleTeamPerformanceData('Victorias', data['Victorias']![0].value),
      SimpleTeamPerformanceData('Empates', data['Empates']![0].value),
      SimpleTeamPerformanceData('Derrotas', data['Derrotas']![0].value),
    ];

    final tableData2 = [
      SimpleTeamPerformanceData('Victorias', data['Victorias']![1].value),
      SimpleTeamPerformanceData('Empates', data['Empates']![1].value),
      SimpleTeamPerformanceData('Derrotas', data['Derrotas']![1].value),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Comparación de Equipos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildViewSelector(),
            const SizedBox(height: 20),
            Expanded(
              child: selectedView == 'Tabla'
                  ? _buildComparisonTable(t1.commonName, t2.commonName, tableData1, tableData2)
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
                items: ['Victorias', 'Empates', 'Derrotas'].map((value) {
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

  Widget _buildChart(List<SimpleTeamPerformanceData> data) {
    final chartWidget = () {
      switch (selectedChart) {
        case 'Lineal':
          return LineChartSampleTeamComparison(
            data: data,
            teamNames: [widget.team1.commonName, widget.team2.commonName],
          );
        case 'Circular':
          return PieChartSampleTeamComparison(
            data: data,
            teamNames: [widget.team1.commonName, widget.team2.commonName],
          );
        case 'Barra':
        default:
          return BarChartSampleTeamComparison(
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
        _legendItem(Colors.blue, widget.team1.commonName),
        const SizedBox(width: 16),
        _legendItem(Colors.green, widget.team2.commonName),
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
    List<SimpleTeamPerformanceData> t1,
    List<SimpleTeamPerformanceData> t2,
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
        for (int i = 0; i < t1.length; i++)
          _buildDataRow(t1[i].label, t1[i].value, t2[i].value),
      ],
    );
  }

  TableRow _buildHeaderRow(String label, String t1, String t2) {
    return TableRow(children: [
      _buildCell(label, isHeader: true),
      _buildCell(t1, isHeader: true),
      _buildCell(t2, isHeader: true),
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
