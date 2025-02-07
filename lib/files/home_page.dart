import 'package:flutter/material.dart';
import 'package:flutter_application_2/files/user_preferences.dart';
import '../matches/match_selection_screen.dart'; 
import '../players/player_selection.dart';
import '../teams/team_selection_screen.dart';
import '../test/massive_list_screen.dart'; // Importa la nueva pantalla de lista masiva

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var deviceWidth = screenSize.width;

    double iconSize = deviceWidth < 392 ? 80 : deviceWidth > 392 ? 120 : 100;
    double titleFontSize = deviceWidth < 392 ? 20 : 24;
    double subtitleFontSize = deviceWidth < 392 ? 14 : 16;

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
                  Text(UserPreferences.isLoggedIn() ? 'Usuario' : 'Usuario'),
              accountEmail: Text(
                  UserPreferences.isLoggedIn() ? 'usuario@correo.com' : ''),
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
                    builder: (context) => PlayerSelectionScreen(),
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
                    builder: (context) => TeamSelectionScreen(),
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
                    builder: (context) => MatchSelectionScreen(),
                  ),
                );
              },
            ),
            _createDrawerItem(
              icon: Icons.list,
              text: 'Lista Masiva',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MassiveListScreen(),
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
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer,
              size: iconSize,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Bienvenido a Fuchibol Center',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Disfruta de toda la información sobre el fútbol.',
              style: TextStyle(fontSize: subtitleFontSize),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
