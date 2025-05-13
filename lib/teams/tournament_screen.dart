import 'package:flutter/material.dart';
import 'teams_model.dart';
import 'data_teams.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  List<Team> allTeams = [];
  List<int> availableSeasons = [];
  int? selectedSeason;
  List<Team> seasonTeams = [];
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    loadAllTeamData().then((data) {
      setState(() {
        allTeams = data;
        availableSeasons =
            allTeams.map((t) => t.season).toSet().toList()..sort((a, b) => b.compareTo(a));
        selectedSeason = availableSeasons.first;
        _filterTeamsBySeason();
      });
    });
  }

  void _filterTeamsBySeason() {
    seasonTeams = allTeams.where((t) => t.season == selectedSeason).toList()
      ..sort((a, b) => a.league_position.compareTo(b.league_position));
  }

  void _sort<T>(Comparable<T> Function(Team t) getField, int columnIndex, bool ascending) {
    seasonTeams.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabla del Torneo')),
      body: allTeams.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSeasonDropdown(),
                  const SizedBox(height: 20),
                  Expanded(child: _buildLeagueTable()),
                ],
              ),
            ),
    );
  }

  Widget _buildSeasonDropdown() {
    return Row(
      children: [
        const Text("Temporada:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        DropdownButton<int>(
          value: selectedSeason,
          onChanged: (value) {
            setState(() {
              selectedSeason = value!;
              _filterTeamsBySeason();
            });
          },
          items: availableSeasons.map((year) {
            return DropdownMenuItem(
              value: year,
              child: Text('Temporada $year'),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLeagueTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade100),
          dataRowColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? Colors.lightBlue.shade50
                : Colors.grey.shade50,
          ),
          columnSpacing: 12,
          horizontalMargin: 16,
          columns: [
            DataColumn(label: const Text('Pos')),
            DataColumn(
              label: const Text('Equipo'),
              onSort: (i, asc) => _sort((t) => t.commonName, i, asc),
            ),
            DataColumn(
              label: const Text('PJ'),
              numeric: true,
              onSort: (i, asc) => _sort((t) => t.matches_played, i, asc),
            ),
            DataColumn(
              label: const Text('G'),
              numeric: true,
              onSort: (i, asc) => _sort((t) => t.wins, i, asc),
            ),
            DataColumn(
              label: const Text('E'),
              numeric: true,
              onSort: (i, asc) => _sort((t) => t.draws, i, asc),
            ),
            DataColumn(
              label: const Text('P'),
              numeric: true,
              onSort: (i, asc) => _sort((t) => t.losses, i, asc),
            ),
            DataColumn(
              label: const Text('GF'),
              numeric: true,
              onSort: (i, asc) => _sort((t) => t.goals_scored, i, asc),
            ),
            DataColumn(
              label: const Text('GC'),
              numeric: true,
              onSort: (i, asc) => _sort((t) => t.goals_conceded, i, asc),
            ),
            DataColumn(
              label: const Text('Dif'),
              numeric: true,
              onSort: (i, asc) => _sort((t) => t.goals_difference, i, asc),
            ),
          ],
          rows: seasonTeams.map((team) {
            return DataRow(cells: [
              DataCell(Text(team.league_position.toString())),
              DataCell(Text(team.commonName)),
              DataCell(Text(team.matches_played.toString())),
              DataCell(Text(team.wins.toString())),
              DataCell(Text(team.draws.toString())),
              DataCell(Text(team.losses.toString())),
              DataCell(Text(team.goals_scored.toString())),
              DataCell(Text(team.goals_conceded.toString())),
              DataCell(Text(team.goals_difference.toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
