import 'dart:convert';

import 'package:app_eventos/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['ID'],
      title: json['Title'],
      description: json['Description'],
      startDate: DateTime.parse(json['Date']),
      endDate: DateTime.parse(json['Date']),
    );
  }
}

class EventsScreen extends StatefulWidget {
  // final String token;

  const EventsScreen({
    Key? key,
    // required this.token,
  }) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  void _getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('token_event $token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/v1/events?page=1&limit=10'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      final events = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      setState(() {
        _events = events.map((e) => Event.fromJson(e)).toList();
      });
    } else {
      // La solicitud falló
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Eventos'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return Card(
                        child: GestureDetector(
                          onTap: () {
                            String eventId = event.id.toString();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(
                                    eventId: int.parse(eventId)),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                            ),
                            child: ListTile(
                              title: Text(
                                event.title.toUpperCase(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(event.description,
                                  style: const TextStyle(color: Colors.black)),
                              trailing: Text(
                                event.startDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
