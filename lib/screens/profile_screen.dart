import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String? token;
  late Map<String, dynamic> profile;

  get http => null;

  @override
  Future<void> initState() async {
    super.initState();

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    // Hacer una solicitud GET a la API
    getProfile();
  }

  Future<void> getProfile() async {
    // Crear la URL de la API
    final url = Uri.parse('http://10.0.2.2:3000/api/v1/users/4');

    // Hacer la solicitud GET
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    // Procesar la respuesta
    if (response.statusCode == 200) {
      profile = jsonDecode(response.body);
      setState(() {});
    } else {
      // TODO: Mostrar un error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Mostrar el nombre del usuario
            Text(profile['FirstName'] + ' ' + profile['LastName']),
            // Mostrar el correo electrónico del usuario
            Text(profile['Email']),
            // Mostrar el teléfono del usuario
            Text(profile['Phone']),
          ],
        ),
      ),
    );
  }
}
