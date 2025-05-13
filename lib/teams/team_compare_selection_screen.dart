import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'data_teams.dart';
import 'team_comparision_screen.dart';
import 'team_search.dart';

class TeamCompareSelectionScreen extends StatefulWidget {
  const TeamCompareSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TeamCompareSelectionScreen> createState() =>
      _TeamCompareSelectionScreenState();
}

class _TeamCompareSelectionScreenState extends State<TeamCompareSelectionScreen> {
  List<Team> allTeams = [];

  String? selectedName1;
  int? selectedSeason1;
  Team? selectedTeam1;

  String? selectedName2;
  int? selectedSeason2;
  Team? selectedTeam2;

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllTeamData().then((data) {
      setState(() {
        allTeams = data;
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Future<void> _searchTeam(int index) async {
    final result = await showSearch<Team?>(
      context: context,
      delegate: TeamSearchDelegate(allTeams, isForComparison: true),
    );

    if (result != null) {
      setState(() {
        if (index == 1) {
          selectedName1 = result.commonName;
          selectedSeason1 = null;
          selectedTeam1 = null;
          _controller1.text = result.commonName;
        } else {
          selectedName2 = result.commonName;
          selectedSeason2 = null;
          selectedTeam2 = null;
          _controller2.text = result.commonName;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canCompare = selectedTeam1 != null && selectedTeam2 != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Comparar Equipos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchInput(
              label: 'Equipo 1',
              controller: _controller1,
              icon: Icons.shield,
              onTap: () => _searchTeam(1),
            ),
            if (selectedName1 != null) _buildSeasonDropdown(1),
            const SizedBox(height: 20),
            _buildSearchInput(
              label: 'Equipo 2',
              controller: _controller2,
              icon: Icons.shield_outlined,
              onTap: () => _searchTeam(2),
            ),
            if (selectedName2 != null) _buildSeasonDropdown(2),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: canCompare
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TeamComparisonScreen(
                            team1: selectedTeam1!,
                            team2: selectedTeam2!,
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

  Widget _buildSeasonDropdown(int index) {
    final name = index == 1 ? selectedName1 : selectedName2;
    final seasons = allTeams
        .where((t) => t.commonName == name)
        .map((t) => t.season)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // más reciente primero

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Temporada ${index == 1 ? 'Equipo 1' : 'Equipo 2'}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        value: index == 1 ? selectedSeason1 : selectedSeason2,
        items: seasons.map((season) {
          return DropdownMenuItem<int>(
            value: season,
            child: Text('Temporada $season'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            if (index == 1) {
              selectedSeason1 = value;
              selectedTeam1 = allTeams.firstWhere(
                  (t) => t.commonName == selectedName1 && t.season == value);
            } else {
              selectedSeason2 = value;
              selectedTeam2 = allTeams.firstWhere(
                  (t) => t.commonName == selectedName2 && t.season == value);
            }
          });
        },
      ),
    );
  }
}
