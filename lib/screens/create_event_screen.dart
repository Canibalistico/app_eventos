import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  String? token = '';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear evento'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de texto para el título
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
              ),
              // Campo de texto para la descripción
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
              ),
              // Campo de texto para la ubicación
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                ),
              ),
              // Campo de texto para el precio
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  // Validar el valor ingresado
                  try {
                    double price = double.parse(value);
                  } catch (e) {
                    // Si el valor no es un número, establecerlo en 0
                    _priceController.text = '0';
                  }
                },
              ),
              // Campo de texto para la fecha
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                ),
                onTap: () {
                  // Mostrar el picker de fecha
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023, 1, 1),
                    lastDate: DateTime(2024, 12, 31),
                  ).then((date) {
                    // Actualizar el valor del campo de texto
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
                  });
                },
                readOnly: true,
              ),
              // Campo de texto para el horario
              TextField(
                controller: _scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Horario',
                ),
              ),
              // Campo de texto para la imagen
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Link Imagen',
                ),
              ),
              const SizedBox(height: 30),
              // Botón para crear el evento
              TextButton(
                onPressed: () {
                  // Crear el objeto JSON del evento
                  final event = jsonEncode({
                    "title": _titleController.text,
                    "description": _descriptionController.text,
                    "location": _locationController.text,
                    "price": double.tryParse(_priceController.text),
                    "date": _dateController.text + "T00:00:01Z",
                    "capability": 0,
                    "schedule":
                        _scheduleController.text, // "2023-10-10T12:00:00Z"
                    "likes": 0,
                    "latitude": -33.47031,
                    "longitude": -70.65919,
                    "image": _imageController.text,
                  });
                  print('token crear $event');
                  // Enviar el evento al servidor
                  http
                      .post(
                    Uri.parse('http://10.0.2.2:3000/api/v1/events'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                    body: event,
                  )
                      .then((response) {
                    // Si la respuesta es exitosa, mostrar un mensaje de éxito
                    if (response.statusCode == 201) {
                      // Limpiar los campos
                      _titleController.text = '';
                      _descriptionController.text = '';
                      _locationController.text = '';
                      _priceController.text = '0';
                      _dateController.text = '';
                      _scheduleController.text = '';
                      _imageController.text = '';
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Evento creado correctamente'),
                        ),
                      );

                      // Navegar a la pantalla de inicio
                      //Navigator.pop(context);
                    } else {
                      // Si la respuesta no es exitosa, mostrar un mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al crear el evento'),
                        ),
                      );
                    }
                  });
                },
                child: const Text('Crear evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
