import 'package:flutter/material.dart';
import 'player_model.dart';
import 'player_detail.dart';

class PlayerSearchDelegate extends SearchDelegate<Player?> {
  final List<Player> players;

  PlayerSearchDelegate(this.players);

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
    return _buildPlayerList(_getSuggestions());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildPlayerList(_getSuggestions());
  }

  List<Player> _getSuggestions() {
    if (query.isEmpty) {
      return players;
    } else {
      final queryLower = query.toLowerCase();
      return players.where((player) {
        return player.fullName.toLowerCase().contains(queryLower);
      }).toList();
    }
  }

  Widget _buildPlayerList(List<Player> players) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          title: Text(player.fullName),
          subtitle: Text('Edad: ${player.age}, Liga: ${player.league}'),
          onTap: () {
            close(context, player);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlayerDetailsScreen(player: player),
              ),
            );
          },
        );
      },
    );
  }
}
