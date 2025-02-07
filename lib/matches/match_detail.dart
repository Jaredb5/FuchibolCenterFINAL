import 'package:flutter/material.dart';
import 'match_model.dart';
import 'data_match.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Match match;

  const MatchDetailsScreen({Key? key, required this.match}) : super(key: key);

  Future<List<Match>> loadPreviousMatches(
      String homeTeam, String awayTeam) async {
    List<Match> allMatches = await loadAllMatchData();
    return allMatches
        .where((m) =>
            (m.homeTeam == homeTeam && m.awayTeam == awayTeam) ||
            (m.homeTeam == awayTeam && m.awayTeam == homeTeam))
        .toList();
  }

  Widget buildStatRow(String title, String homeValue, String awayValue) {
    int homeFlex = _parseFlexValue(homeValue);
    int awayFlex = _parseFlexValue(awayValue);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            homeValue,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(title, style: const TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Expanded(
                        flex: homeFlex,
                        child: Container(
                          height: 10,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        flex: awayFlex,
                        child: Container(
                          height: 10,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Text(
            awayValue,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  int _parseFlexValue(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 1; // Valor por defecto si no se puede convertir
    }
  }

  Widget buildPreviousMatchesSection(List<Match> previousMatches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Resultados Anteriores:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: previousMatches.length,
          itemBuilder: (context, index) {
            final previousMatch = previousMatches[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    previousMatch.homeTeamGoal,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  '${previousMatch.homeTeam} vs ${previousMatch.awayTeam}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Fecha: ${previousMatch.dateGMT}'),
                trailing: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    previousMatch.awayTeamGoal,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MatchDetailsScreen(match: previousMatch),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${match.homeTeam} vs ${match.awayTeam}'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<Match>>(
        future: loadPreviousMatches(match.homeTeam, match.awayTeam),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay resultados anteriores disponibles.'));
          } else {
            List<Match> previousMatches = snapshot.data!;

            return Scrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Detalles del Partido:',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
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
                          'Estadio: ${match.stadiumName}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildStatRow(
                        'Goles', match.homeTeamGoal, match.awayTeamGoal),
                    buildStatRow(
                        'Esquinas', match.homeTeamCorner, match.awayTeamCorner),
                    buildStatRow('Tarjetas Amarillas',
                        match.homeTeamYellowCards, match.awayTeamYellowCards),
                    buildStatRow('Tarjetas Rojas', match.homeTeamRedCards,
                        match.awayTeamRedCards),
                    buildStatRow(
                        'Tiros', match.homeTeamShots, match.awayTeamShots),
                    buildStatRow('Tiros a Puerta', match.homeTeamShotsOnTarget,
                        match.awayTeamShotsOnTarget),
                    buildStatRow(
                        'Faltas', match.homeTeamFouls, match.awayTeamFouls),
                    buildStatRow('Posesión', match.homeTeamPossession,
                        match.awayTeamPossession),
                    buildPreviousMatchesSection(previousMatches),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
