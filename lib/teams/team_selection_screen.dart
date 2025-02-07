import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'data_teams.dart';
import 'team_detail.dart';
import 'team_search.dart'; // Asegúrate de importar el TeamSearchDelegate

class TeamSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Equipo'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final teams = await loadAllTeamData();
              showSearch(
                context: context,
                delegate: TeamSearchDelegate(teams),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Team>>(
        future: loadAllTeamData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay equipos disponibles.'));
          } else {
            // Filtrar nombres únicos de equipos y mantener relación con los objetos Team
            Map<String, Team> uniqueTeams = {};
            for (var team in snapshot.data!) {
              uniqueTeams[team.commonName] = team;
            }

            List<String> uniqueTeamNames = uniqueTeams.keys.toList();

            return ListView.builder(
              itemCount: uniqueTeamNames.length,
              itemBuilder: (context, index) {
                final teamName = uniqueTeamNames[index];
                final team = uniqueTeams[teamName];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.group, color: Colors.blueAccent),
                    title: Text(
                      teamName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamDetailsScreen(team: team!),
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
