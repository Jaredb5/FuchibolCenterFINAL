import 'package:flutter/material.dart';
import 'player_model.dart';
import 'player_detail.dart';

class PlayerSearchDelegate extends SearchDelegate<Player?> {
  final List<Player> players;
  final bool isForComparison;

  PlayerSearchDelegate(this.players, {this.isForComparison = false});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = players
        .where((player) =>
            player.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Filtrar nombres únicos
    Map<String, Player> uniquePlayers = {};
    for (var player in results) {
      uniquePlayers[player.fullName] = player;
    }

    List<String> uniquePlayerNames = uniquePlayers.keys.toList();

    return ListView.builder(
      itemCount: uniquePlayerNames.length,
      itemBuilder: (context, index) {
        final playerName = uniquePlayerNames[index];
        final player = uniquePlayers[playerName]!;

        return ListTile(
          title: Text(playerName),
          subtitle: Text('Edad: ${player.age}, Liga: ${player.league}'),
          onTap: () {
            if (isForComparison) {
              close(context, player); // ✅ Se usa para selección
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerDetailsScreen(player: player),
                ),
              ); // ✅ Se usa para ver detalles
            }
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = players
        .where((player) =>
            player.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    Map<String, Player> uniquePlayers = {};
    for (var player in suggestions) {
      uniquePlayers[player.fullName] = player;
    }

    List<String> uniquePlayerNames = uniquePlayers.keys.toList();

    return ListView.builder(
      itemCount: uniquePlayerNames.length,
      itemBuilder: (context, index) {
        final playerName = uniquePlayerNames[index];
        final player = uniquePlayers[playerName]!;

        return ListTile(
          title: Text(playerName),
          subtitle: Text('Edad: ${player.age}, Liga: ${player.league}'),
          onTap: () {
            query = playerName;
            showResults(context);
          },
        );
      },
    );
  }
}
