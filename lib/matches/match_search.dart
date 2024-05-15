import 'package:flutter/material.dart';
import 'match_model.dart';
import 'match_detail.dart';

class MatchSearchDelegate extends SearchDelegate<Match?> {
  final List<Match> matches;

  MatchSearchDelegate(this.matches);

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
    return _buildMatchList(_getFilteredResults());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildMatchList(_getFilteredResults());
  }

  List<Match> _getFilteredResults() {
    if (query.isEmpty) {
      return [];
    } else {
      final queryLower = query.toLowerCase();
      return matches.where((match) {
        return match.homeTeam.toLowerCase().contains(queryLower) || 
               match.awayTeam.toLowerCase().contains(queryLower);
      }).toList();
    }
  }

  Widget _buildMatchList(List<Match> matches) {
    if (matches.isEmpty) {
      return const Center(child: Text('No se encontraron partidos.'));
    }
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return ListTile(
          title: Text('${match.homeTeam} vs ${match.awayTeam}'),
          subtitle: Text('Fecha: ${match.dateGMT}'),
          onTap: () {
            close(context, null);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MatchDetailsScreen(match: match),
              ),
            );
          },
        );
      },
    );
  }
}
