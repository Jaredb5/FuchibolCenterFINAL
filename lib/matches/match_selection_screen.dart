import 'package:flutter/material.dart';
import 'match_model.dart';
import 'match_detail.dart';
import 'data_match.dart';
import 'match_search.dart'; // Importa tu archivo de búsqueda

class MatchSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Partido'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final matches = await loadAllMatchData();
              showSearch(
                context: context,
                delegate: MatchSearchDelegate(matches),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Match>>(
        future: loadAllMatchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay partidos disponibles.'));
          } else {
            List<Match> matches = snapshot.data!;
            return ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.sports_soccer,
                        color: Colors.redAccent),
                    title: Text(
                      '${match.homeTeam} vs ${match.awayTeam}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Fecha: ${match.dateGMT}'),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MatchDetailsScreen(match: match),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
