import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_model.dart';

class BarChartSamplePlayer extends StatelessWidget {
  final Player player;
  final String dataType;

  BarChartSamplePlayer({required this.player, required this.dataType});

  @override
  Widget build(BuildContext context) {
    double maxY = player.appearances_overall.toDouble();
    List<BarChartGroupData> barGroups = [];

    // Función para generar las barras con etiquetas
    BarChartGroupData createBarChartGroup(int x, double y, Color color) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            y: y,
            colors: [color],
            width: 22,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        showingTooltipIndicators: [
          0
        ], // Para mostrar las etiquetas en el gráfico
      );
    }

    if (dataType == 'goals') {
      maxY = player.appearances_overall.toDouble();
      barGroups = [
        createBarChartGroup(0, player.goalsOverall.toDouble(), Colors.purple),
        createBarChartGroup(1, player.goalsHome.toDouble(), Colors.blue),
        createBarChartGroup(2, player.goalsAway.toDouble(), Colors.orange),
      ];
    } else if (dataType == 'assists') {
      maxY = player.assistsOverall.toDouble();
      barGroups = [
        createBarChartGroup(0, player.assistsHome.toDouble(), Colors.green),
        createBarChartGroup(1, player.assistsAway.toDouble(), Colors.pink),
      ];
    } else if (dataType == 'yellowCards') {
      maxY = player.yellowCardsOverall.toDouble();
      barGroups = [
        createBarChartGroup(
            0, player.yellowCardsOverall.toDouble(), Colors.amber),
      ];
    } else {
      maxY = 0;
      barGroups = [];
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barGroups: barGroups,
        titlesData: _buildTitlesData(dataType),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipMargin: 0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.toInt().toString(), // Convertir el valor a entero
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  FlTitlesData _buildTitlesData(String dataType) {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 16,
        getTitles: (double value) {
          if (dataType == 'goals') {
            switch (value.toInt()) {
              case 0:
                return 'Total Goles';
              case 1:
                return 'Goles Casa';
              case 2:
                return 'Goles Visitante';
              default:
                return '';
            }
          } else if (dataType == 'assists') {
            switch (value.toInt()) {
              case 0:
                return 'Asistencias en Casa';
              case 1:
                return 'Asistencias de Visitante';
              default:
                return '';
            }
          } else if (dataType == 'yellowCards') {
            return 'Tarjetas Amarillas';
          } else {
            return '';
          }
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        margin: 10,
        reservedSize: 28,
        getTitles: (value) {
          return '$value';
        },
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    );
  }
}
