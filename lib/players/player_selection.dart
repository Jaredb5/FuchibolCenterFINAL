import 'package:flutter/material.dart';
import 'player_model.dart';
import 'player_detail.dart';
import 'data_player.dart';
import 'player_search.dart';

class PlayerSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Jugador'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final players = await loadAllPlayerData();
              showSearch(
                context: context,
                delegate: PlayerSearchDelegate(players),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Player>>(
        future: loadAllPlayerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay jugadores disponibles.'));
          } else {
            // Filtrar nombres únicos de jugadores y mantener relación con los objetos Player
            Map<String, Player> uniquePlayers = {};
            for (var player in snapshot.data!) {
              uniquePlayers[player.fullName] = player;
            }

            List<String> uniquePlayerNames = uniquePlayers.keys.toList();

            return ListView.builder(
              itemCount: uniquePlayerNames.length,
              itemBuilder: (context, index) {
                final playerName = uniquePlayerNames[index];
                final player = uniquePlayers[playerName];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.blueAccent),
                    title: Text(
                      playerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Edad: ${player!.age}, Liga: ${player.league}'),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlayerDetailsScreen(player: player),
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
