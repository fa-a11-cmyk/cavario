class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final int maxParticipants;
  final List<String> participants;
  final String type;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.maxParticipants,
    this.participants = const [],
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'maxParticipants': maxParticipants,
      'participants': participants,
      'type': type,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      location: json['location'],
      maxParticipants: json['maxParticipants'],
      participants: List<String>.from(json['participants'] ?? []),
      type: json['type'],
    );
  }
}