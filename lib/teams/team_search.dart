import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'team_detail.dart';

class TeamSearchDelegate extends SearchDelegate<Team?> {
  final List<Team> teams;

  TeamSearchDelegate(this.teams);

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

  Widget _buildTeamList(List<Team> teams) {
    if (teams.isEmpty) {
      return Center(child: Text('No se encontraron equipos.'));
    }
    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return ListTile(
          title: Text(team.commonName),
          subtitle: Text('Nombre: ${team.commonName}, Temporada: ${team.season}'),
          onTap: () {
            close(context, null);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TeamDetailsScreen(team: team),
              ),
            );
          },
        );
      },
    );
  }
}
