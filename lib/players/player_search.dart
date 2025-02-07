import 'package:flutter/material.dart';
import 'player_model.dart';
import 'player_detail.dart';

class PlayerSearchDelegate extends SearchDelegate<Player?> {
  final List<Player> players;

  PlayerSearchDelegate(this.players);

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

    // Filtrar nombres únicos de jugadores y mantener relación con los objetos Player
    Map<String, Player> uniquePlayers = {};
    for (var player in results) {
      uniquePlayers[player.fullName] = player;
    }

    List<String> uniquePlayerNames = uniquePlayers.keys.toList();

    return ListView.builder(
      itemCount: uniquePlayerNames.length,
      itemBuilder: (context, index) {
        final playerName = uniquePlayerNames[index];
        final player = uniquePlayers[playerName];

        return ListTile(
          title: Text(playerName),
          subtitle: Text('Edad: ${player!.age}, Liga: ${player.league}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerDetailsScreen(player: player),
              ),
            );
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

    // Filtrar nombres únicos de jugadores y mantener relación con los objetos Player
    Map<String, Player> uniquePlayers = {};
    for (var player in suggestions) {
      uniquePlayers[player.fullName] = player;
    }

    List<String> uniquePlayerNames = uniquePlayers.keys.toList();

    return ListView.builder(
      itemCount: uniquePlayerNames.length,
      itemBuilder: (context, index) {
        final playerName = uniquePlayerNames[index];
        final player = uniquePlayers[playerName];

        return ListTile(
          title: Text(playerName),
          subtitle: Text('Edad: ${player!.age}, Liga: ${player.league}'),
          onTap: () {
            query = playerName;
            showResults(context);
          },
        );
      },
    );
  }
}
