import 'dart:convert';
import 'dart:math';

import 'package:app_eventos/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cell_calendar/cell_calendar.dart';

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

class CalendarScreen extends StatefulWidget {
  // final String token;

  const CalendarScreen({
    Key? key,
    // required this.token,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  void _getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // print('token_event $token');
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
    final events = _events
        .map((event) => CalendarEvent(
              eventID: event.id.toString(),
              eventName: event.title,
              eventDate: event.startDate,
              eventBackgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              eventTextStyle: const TextStyle(color: Colors.white),
            ))
        .toList();
    final cellCalendarPageController = CellCalendarPageController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Calendario de Eventos"),
        ),
        body: CellCalendar(
            onCellTapped: (date) {
              final eventsOnTheDate = events.where((event) {
                final eventDate = event.eventDate;
                return eventDate.year == date.year &&
                    eventDate.month == date.month &&
                    eventDate.day == date.day;
              }).toList();

              if (eventsOnTheDate.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("${date.month.monthName} ${date.day}"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: eventsOnTheDate
                          .map(
                            (event) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 12),
                              color: event.eventBackgroundColor,
                              child: GestureDetector(
                                onTap: () {
                                  if (event.eventID != null) {
                                    String eventId = event.eventID.toString();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailsPage(
                                            eventId: int.parse(eventId)),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  event.eventName,
                                  style: event.eventTextStyle,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              }
            },
            cellCalendarPageController: cellCalendarPageController,
            events: events,
            daysOfTheWeekBuilder: (dayIndex) {
              final labels = ["S", "M", "T", "W", "T", "F", "S"];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  labels[dayIndex],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
            monthYearLabelBuilder: (datetime) {
              final year = datetime!.year.toString();
              final month = datetime.month.monthName;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      "$month  $year",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        cellCalendarPageController.animateToDate(
                          DateTime.now(),
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    )
                  ],
                ),
              );
            }));
  }
}
