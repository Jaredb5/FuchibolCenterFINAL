import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'player_model.dart';

class LineChartSamplePlayerComparison extends StatelessWidget {
  final String dataType;
  final List<Player> playerData;

  LineChartSamplePlayerComparison(
      {required this.dataType, required this.playerData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

    for (int i = 0; i < playerData.length; i++) {
      Player player = playerData[i];
      double value = 0;
      if (dataType == 'averageGoals') {
        value = player.appearances_overall > 0
            ? player.goalsOverall / player.appearances_overall
            : 0;
      } else if (dataType == 'averageAssists') {
        value = player.appearances_overall > 0
            ? player.assistsOverall / player.appearances_overall
            : 0;
      } else if (dataType == 'averageYellowCards') {
        value = player.appearances_overall > 0
            ? player.yellowCardsOverall / player.appearances_overall
            : 0;
      }
      spots.add(FlSpot(i.toDouble(), value));
    }

    return Stack(
      children: [
        LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                colors: [Colors.blue],
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.blue,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: _buildTitlesData(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 1),
                left: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            minY: 0,
            maxY: _calculateMaxY(spots),
            lineTouchData: LineTouchData(
              enabled: false,
            ),
          ),
          swapAnimationDuration: const Duration(milliseconds: 250),
          swapAnimationCurve: Curves.linear,
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: spots.map((spot) {
                  final x =
                      constraints.maxWidth * (spot.x / (playerData.length - 1));
                  final y = constraints.maxHeight *
                      (1 - (spot.y / _calculateMaxY(spots)));
                  final value = spot.y.toStringAsFixed(2);

                  // Determinar los desplazamientos para que el texto no interfiera con los puntos
                  double yOffset =
                      -10; // Posición inicial ajustada cerca del punto
                  double xOffset =
                      -10; // Desplazamiento horizontal para centrar el texto

                  // Ajuste para evitar que el texto se superponga o quede muy alejado del punto
                  if (y < constraints.maxHeight * 0.1) {
                    yOffset += 10; // Mover hacia abajo si está muy arriba
                  } else if (y > constraints.maxHeight * 0.9) {
                    yOffset -= 20; // Mover hacia arriba si está muy abajo
                  }

                  return Positioned(
                    left: x + xOffset, // Ajuste del desplazamiento horizontal
                    top: y + yOffset, // Ajuste del desplazamiento vertical
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 10,
        reservedSize: 40,
        getTitles: (double value) {
          if (value.toInt() >= 0 && value.toInt() < playerData.length) {
            return playerData[value.toInt()].season.toString();
          } else {
            return '';
          }
        },
        rotateAngle: 45,
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
        interval: 0.5,
        getTitles: (value) {
          return value.toString();
        },
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    );
  }

  double _calculateMaxY(List<FlSpot> spots) {
    double maxY = 0;
    for (var spot in spots) {
      if (spot.y > maxY) {
        maxY = spot.y;
      }
    }
    return maxY + 1;
  }
}
