import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/member.dart';
import '../models/event.dart';

class ApiService {
  static const String baseUrl = 'https://api.cavario.com';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Membres
  static Future<List<Member>> fetchMembers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/members'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Member.fromJson(json)).toList();
      }
      throw Exception('Failed to load members');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Member> createMember(Member member) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members'),
      headers: headers,
      body: json.encode(member.toJson()),
    );
    if (response.statusCode == 201) {
      return Member.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create member');
  }

  static Future<void> deleteMember(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/members/$id'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete member');
    }
  }

  // Événements
  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    }
    throw Exception('Failed to load events');
  }

  static Future<Event> createEvent(Event event) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: headers,
      body: json.encode(event.toJson()),
    );
    if (response.statusCode == 201) {
      return Event.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create event');
  }

  // Paiements
  static Future<Map<String, dynamic>> processPayment({
    required String amount,
    required String currency,
    required String memberId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: headers,
      body: json.encode({
        'amount': amount,
        'currency': currency,
        'member_id': memberId,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Payment failed');
  }
}