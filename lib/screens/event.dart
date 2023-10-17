class Event {
  final int eventID;
  final String eventName;
  final String description;
  final String location;
  final int price;
  final DateTime date;
  final int capability;
  final String schedule;
  final int likes;
  final String image;

  Event({
    required this.eventID,
    required this.eventName,
    required this.description,
    required this.location,
    required this.price,
    required this.date,
    required this.capability,
    required this.schedule,
    required this.likes,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventID: json['ID'],
        eventName: json['Title'],
        description: json['Description'],
        location: json['Location'],
        price: json['Price'],
        date: DateTime.parse(json['Date']),
        capability: json['Capability'],
        schedule: json['Schedule'],
        likes: json['Likes'],
        image: json['Image'],
      );
}
