class Member {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String membershipType;
  final DateTime joinDate;
  final bool isActive;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.membershipType,
    required this.joinDate,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'membershipType': membershipType,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      membershipType: json['membershipType'],
      joinDate: DateTime.parse(json['joinDate']),
      isActive: json['isActive'] ?? true,
    );
  }
}