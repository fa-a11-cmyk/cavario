class Horse {
  final String id;
  final String name;
  final String breed;
  final int age;
  final String color;
  final String gender;
  final String healthStatus;
  final bool isAvailable;
  final String? assignedRider;
  final List<String> specialNeeds;

  Horse({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.color,
    required this.gender,
    required this.healthStatus,
    this.isAvailable = true,
    this.assignedRider,
    this.specialNeeds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'color': color,
      'gender': gender,
      'healthStatus': healthStatus,
      'isAvailable': isAvailable,
      'assignedRider': assignedRider,
      'specialNeeds': specialNeeds,
    };
  }

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      age: json['age'],
      color: json['color'],
      gender: json['gender'],
      healthStatus: json['healthStatus'],
      isAvailable: json['isAvailable'] ?? true,
      assignedRider: json['assignedRider'],
      specialNeeds: List<String>.from(json['specialNeeds'] ?? []),
    );
  }
}

class Equipment {
  final String id;
  final String name;
  final String type;
  final String condition;
  final bool isAvailable;
  final DateTime lastMaintenance;
  final DateTime? nextMaintenance;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.condition,
    this.isAvailable = true,
    required this.lastMaintenance,
    this.nextMaintenance,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'condition': condition,
      'isAvailable': isAvailable,
      'lastMaintenance': lastMaintenance.toIso8601String(),
      'nextMaintenance': nextMaintenance?.toIso8601String(),
    };
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      condition: json['condition'],
      isAvailable: json['isAvailable'] ?? true,
      lastMaintenance: DateTime.parse(json['lastMaintenance']),
      nextMaintenance: json['nextMaintenance'] != null 
          ? DateTime.parse(json['nextMaintenance'])
          : null,
    );
  }
}