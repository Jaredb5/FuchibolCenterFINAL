// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'match_model.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Match match;

  MatchDetailsScreen({required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${match.homeTeam} vs ${match.awayTeam}'),
        ),
        body: Scrollbar(
          thumbVisibility: true,
          thickness: 6.0,
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Detalles del Partido:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Fecha y Hora: ${match.dateGMT}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TeamStatCard(
                        team: match.homeTeam,
                        goals: match.homeTeamGoal,
                        corners: match.homeTeamCorner,
                        yellowCards: match.homeTeamYellowCards,
                        redCards: match.homeTeamRedCards,
                        textColor: Colors.blue.shade700,
                        bgColor: Colors.blue.shade100,
                      ),
                    ),
                    Expanded(
                      child: TeamStatCard(
                        team: match.awayTeam,
                        goals: match.awayTeamGoal,
                        corners: match.awayTeamCorner,
                        yellowCards: match.awayTeamYellowCards,
                        redCards: match.awayTeamRedCards,
                        textColor: Colors.red.shade700,
                        bgColor: Colors.red.shade100,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estadio',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            Text(
                              match.stadiumName,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.sports_soccer,
                        color: Colors.blue.shade800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class TeamStatCard extends StatelessWidget {
  final String team;
  final String goals;
  final String corners;
  final String yellowCards;
  final String redCards;
  final Color textColor;
  final Color bgColor;

  const TeamStatCard({
    Key? key,
    required this.team,
    required this.goals,
    required this.corners,
    required this.yellowCards,
    required this.redCards,
    required this.textColor,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              team,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const Divider(),
            StatRow(title: 'Goles', value: goals, textColor: textColor),
            StatRow(title: 'Esquinas', value: corners, textColor: textColor),
            StatRow(
                title: 'Amarillas', value: yellowCards, textColor: textColor),
            StatRow(title: 'Rojas', value: redCards, textColor: textColor),
          ],
        ),
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String title;
  final String value;
  final Color textColor;

  const StatRow({
    Key? key,
    required this.title,
    required this.value,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: textColor)),
          Text(value, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
