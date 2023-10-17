import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Realizar la solicitud HTTP para registrarse
                _register();
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  void _register() async {
    // Crear el cuerpo de la solicitud HTTP
    final body = jsonEncode({
      'FirstName': _firstNameController.text,
      'LastName': _lastNameController.text,
      'Email': _emailController.text,
      'Phone': _phoneController.text,
      'Password': _passwordController.text,
    });

    final headers = {'Content-Type': 'application/json'};
    // Realizar la solicitud HTTP
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/users'),
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      Navigator.pop(context);
    } else {
      // La solicitud falló
      Navigator.pop(context);
    }
  }
}
