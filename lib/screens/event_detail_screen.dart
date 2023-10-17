import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'event.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    super.key,
    required this.eventId,
  });

  final int eventId;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  Event? _event;

  @override
  void initState() {
    super.initState();
    _getEvent();
  }

  Future<void> _getEvent() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/v1/events/${widget.eventId}'),
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      final event =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      setState(() {
        _event = Event.fromJson(event);
      });
    } else {
      // La solicitud falló
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_event!.eventName.toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Titulo
            Text(
              _event!.eventName.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            /// Descripcion
            Container(
              color: const Color.fromARGB(255, 212, 235, 238),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _event!.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Ubicacion
            Text(
              "Ubicación: ${_event!.location}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            /// Precio
            Text(
              "Precio: \$${_event!.price}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            /// Fecha del evento
            Text(
              " Fecha: ${DateFormat("dd/MM/yyyy").format(_event!.date).toString()}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            /// Capacidad
            Text(
              "Capacidad: ${_event!.capability} personas",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            /// Horario
            Text(
              "Horario: ${_event!.schedule}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            /// Imagen
            Image.network(
              _event!.image.isEmpty
                  ? getRandomImageUrl(eventsImages)
                  : _event!.image,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),

            /// Likes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {},
                ),
                Text(
                  "${_event!.likes}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<String> eventsImages = [
  "https://rapidweb.cl/images/junta_vecinos_1.jpg",
  "https://rapidweb.cl/images/junta_vecinos_2.jpg",
  "https://rapidweb.cl/images/junta_vecinos_3.jpg",
  "https://rapidweb.cl/images/junta_vecinos_4.jpg",
];

String getRandomImageUrl(List<String> imageUrls) {
  return imageUrls[Random().nextInt(imageUrls.length)];
}
