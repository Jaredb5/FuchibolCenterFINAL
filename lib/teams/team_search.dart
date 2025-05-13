import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'team_detail.dart';

class TeamSearchDelegate extends SearchDelegate<Team?> {
  final List<Team> teams;
  final bool isForComparison;

  TeamSearchDelegate(this.teams, {this.isForComparison = false});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildTeamList(_getFilteredResults());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildTeamList(_getFilteredResults());
  }

  List<Team> _getFilteredResults() {
    if (query.isEmpty) {
      return [];
    } else {
      final queryLower = query.toLowerCase();
      return teams.where((team) {
        return team.commonName.toLowerCase().contains(queryLower);
      }).toList();
    }
  }

  Widget _buildTeamList(List<Team> results) {
    if (results.isEmpty) {
      return const Center(child: Text('No se encontraron equipos.'));
    }

    final Map<String, Team> uniqueTeams = {};
    for (var team in results) {
      uniqueTeams[team.commonName] = team;
    }

    final uniqueTeamNames = uniqueTeams.keys.toList();

    return ListView.builder(
      itemCount: uniqueTeamNames.length,
      itemBuilder: (context, index) {
        final name = uniqueTeamNames[index];
        final team = uniqueTeams[name];

        return ListTile(
          title: Text(name),
          subtitle: Text('Temporada: ${team!.season}'),
          onTap: () {
            if (isForComparison) {
              close(context, team); // ← ✅ Devuelve el equipo seleccionado
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TeamDetailsScreen(team: team),
              ));
            }
          },
        );
      },
    );
  }
}
