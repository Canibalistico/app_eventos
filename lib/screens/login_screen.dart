import 'dart:convert';

import 'package:app_eventos/screens/menu_screen.dart';
import 'package:app_eventos/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // set token(String token) {}

  Future<String?> _login() async {
    // Crear el cuerpo de la solicitud HTTP
    final body = jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    // Realizar la solicitud HTTP
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      // Guardar el token en SharedPreferences
      final token = jsonDecode(response.body)['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      return token;
    } else {
      // La solicitud falló
      // Mostrar un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar sesión'),
        ),
      );

      return null;
    }
  }

  String? token;
  @override
  void initState() {
    super.initState();

    // Obtener el token de acceso del almacenamiento compartido
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    // Si el token está presente, el usuario ya está autenticado
    if (token != null) {
      if (token == '') {
        return;
      }
      //setState(() {});
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MenuScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Calendario Comunitario Online",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  // Ejecutar el método _login() y obtener el resultado
                  final token = await _login();

                  // Navegar a la pantalla principal si el token es válido
                  if (token != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MenuScreen(),
                      ),
                    );
                  }
                },
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
