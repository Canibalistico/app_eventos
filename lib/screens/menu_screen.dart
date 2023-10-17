import 'package:app_eventos/screens/calendar_event_screen.dart';
import 'package:app_eventos/screens/create_event_screen.dart';
import 'package:app_eventos/screens/events_screen.dart';
import 'package:app_eventos/screens/login_screen.dart';
import 'package:app_eventos/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Grupo de botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón "Ver eventos"
                TextButton(
                  onPressed: () {
                    // Navegar a la pantalla para ver los eventos
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventsScreen(),
                      ),
                    );
                  },
                  child: const Text('Ver eventos'),
                ),
                // Botón "Calendario"
                TextButton(
                  onPressed: () {
                    // Navegar a la pantalla del calendario
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarScreen(),
                      ),
                    );
                  },
                  child: const Text('Calendario'),
                ),
                // Botón "Crear evento"
                TextButton(
                  onPressed: () {
                    // Navegar a la pantalla para crear un evento
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateEventScreen(),
                      ),
                    );
                  },
                  child: const Text('Crear evento'),
                ),
              ],
            ),
            // Bloque de texto
            const SizedBox(height: 20),
            // Container con texto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                const SizedBox(height: 20),
                const Text(
                  "Bienvenidos al Calendario Comunitario Online",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Aqui podras crear y ver todos los eventos relacionados con la junta de vecinos a la que perteneces.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Image.network(
                  'https://www.rapidweb.cl/images/main.png',
                ),
              ]),
            ),
            // Botones de perfil y cerrar sesión
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón "Ver perfil"
                TextButton(
                  onPressed: () {
                    // Navegar a la pantalla para ver el perfil ProfileScreen
                    /*            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );*/
                  },
                  child: const Text('Ver perfil'),
                ),
                // Botón "Cerrar sesión"
                TextButton(
                  onPressed: () {
                    // Cerrar la sesión
                    signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Cerrar sesión'),
                  style: TextButton.styleFrom(
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void signOut() async {
    // Eliminar el token del usuario
//    dynamic token;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('token', token);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
  }
}
