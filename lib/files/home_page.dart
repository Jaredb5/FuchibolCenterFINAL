// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_2/teams/team_by_year.dart';
import 'package:flutter_application_2/files/user_preferences.dart';
import '../matches/match_by_year.dart';
import '../players/player_by_year.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  Text(UserPreferences.isLoggedIn() ? 'Usuario' : 'Invitado'),
              accountEmail: Text(UserPreferences.isLoggedIn()
                  ? 'usuario@correo.com'
                  : 'No autenticado'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            _createDrawerItem(
              icon: Icons.person,
              text: 'Ver jugadores',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YearSelectionScreenPlayers(),
                  ),
                );
              },
            ),
            _createDrawerItem(
              icon: Icons.group,
              text: 'Ver Equipos',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YearSelectionScreenTeams(),
                  ),
                );
              },
            ),
            _createDrawerItem(
              icon: Icons.event,
              text: 'Ver Partidos',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YearSelectionScreenMatches(),
                  ),
                );
              },
            ),
            if (UserPreferences.isLoggedIn())
              _createDrawerItem(
                icon: Icons.exit_to_app,
                text: 'Logout',
                onTap: () async {
                  await UserPreferences.setLoggedIn(false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    // ignore: prefer_const_constructors
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            if (!UserPreferences.isLoggedIn())
              _createDrawerItem(
                icon: Icons.login,
                text: 'Iniciar sesión',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Bienvenido a Fuchibol Center',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Disfruta de toda la información sobre el fútbol.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
