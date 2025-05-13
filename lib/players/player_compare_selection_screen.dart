import 'package:flutter/material.dart';
import 'player_model.dart';
import 'data_player.dart';
import 'player_comparison_screen.dart';
import 'player_search.dart';

class PlayerCompareSelectionScreen extends StatefulWidget {
  const PlayerCompareSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PlayerCompareSelectionScreen> createState() => _PlayerCompareSelectionScreenState();
}

class _PlayerCompareSelectionScreenState extends State<PlayerCompareSelectionScreen> {
  List<Player> allPlayers = [];
  Player? selectedPlayer1;
  Player? selectedPlayer2;

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  List<int> player1Seasons = [];
  List<int> player2Seasons = [];
  int? selectedSeason1;
  int? selectedSeason2;

  @override
  void initState() {
    super.initState();
    loadAllPlayerData().then((data) {
      setState(() {
        allPlayers = data;
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Future<void> _searchPlayer(int index) async {
    final result = await showSearch<Player?>(
      context: context,
      delegate: PlayerSearchDelegate(allPlayers, isForComparison: true),
    );

    if (result != null) {
      final playerSeasons = allPlayers
          .where((p) => p.fullName == result.fullName)
          .map((p) => p.season)
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));

      setState(() {
        if (index == 1) {
          selectedPlayer1 = result;
          player1Seasons = playerSeasons;
          selectedSeason1 = playerSeasons.first;
          _controller1.text = result.fullName;
        } else {
          selectedPlayer2 = result;
          player2Seasons = playerSeasons;
          selectedSeason2 = playerSeasons.first;
          _controller2.text = result.fullName;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canCompare = selectedPlayer1 != null && selectedPlayer2 != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar Jugadores'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchInput(
              label: 'Jugador 1',
              controller: _controller1,
              icon: Icons.person,
              onTap: () => _searchPlayer(1),
            ),
            const SizedBox(height: 8),
            if (selectedPlayer1 != null) _buildSeasonDropdown(player1Seasons, selectedSeason1, (value) {
              setState(() => selectedSeason1 = value);
            }),
            const SizedBox(height: 20),
            _buildSearchInput(
              label: 'Jugador 2',
              controller: _controller2,
              icon: Icons.person,
              onTap: () => _searchPlayer(2),
            ),
            const SizedBox(height: 8),
            if (selectedPlayer2 != null) _buildSeasonDropdown(player2Seasons, selectedSeason2, (value) {
              setState(() => selectedSeason2 = value);
            }),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: canCompare
                  ? () {
                      final playerData1 = allPlayers.firstWhere((p) => p.fullName == selectedPlayer1!.fullName && p.season == selectedSeason1);
                      final playerData2 = allPlayers.firstWhere((p) => p.fullName == selectedPlayer2!.fullName && p.season == selectedSeason2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerComparisonScreen(
                            player1: playerData1,
                            player2: playerData2,
                          ),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.bar_chart),
              label: const Text('Comparar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  Widget _buildSeasonDropdown(List<int> seasons, int? selected, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: selected,
      decoration: const InputDecoration(
        labelText: 'Temporada',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      items: seasons.map((season) {
        return DropdownMenuItem<int>(
          value: season,
          child: Text('Temporada $season'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
