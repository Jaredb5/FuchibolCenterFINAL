import 'package:flutter/material.dart';
import '../teams/teams_screen.dart';

class YearSelectionScreenTeams extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const years = ['2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023'];
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Año')),
      body: ListView.builder(
        itemCount: years.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(years[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamsScreen(year: years[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
