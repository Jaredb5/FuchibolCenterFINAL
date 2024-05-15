import 'package:flutter/material.dart';
import '../players/players_screen.dart';

class YearSelectionScreenPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const years = [
      '2013',
      '2014',
      '2015',
      '2016',
      '2017',
      '2018',
      '2019',
      '2020',
      '2021',
      '2022',
      '2023'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Año de Jugadores'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Lógica de acción
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: years.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.sports_soccer,
                        color: Colors.blueAccent),
                    title: Text(
                      years[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlayersScreen(year: years[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
