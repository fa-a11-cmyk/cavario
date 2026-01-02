import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member.dart';
import '../models/event.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'cavario.db';
  static const int _dbVersion = 1;

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE members(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        membershipType TEXT NOT NULL,
        joinDate TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE events(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        location TEXT NOT NULL,
        maxParticipants INTEGER NOT NULL,
        participants TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    // Données de démonstration
    await db.insert('members', {
      'id': '1',
      'name': 'Marie Dubois',
      'email': 'marie@email.com',
      'phone': '0123456789',
      'membershipType': 'Premium',
      'joinDate': DateTime(2023, 1, 15).toIso8601String(),
      'isActive': 1,
    });

    await db.insert('members', {
      'id': '2',
      'name': 'Pierre Martin',
      'email': 'pierre@email.com',
      'phone': '0987654321',
      'membershipType': 'Standard',
      'joinDate': DateTime(2023, 3, 20).toIso8601String(),
      'isActive': 1,
    });
  }

  // Membres
  static Future<List<Member>> getMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('members');
    return List.generate(maps.length, (i) => Member.fromJson(maps[i]));
  }

  static Future<void> insertMember(Member member) async {
    final db = await database;
    await db.insert('members', member.toJson());
  }

  static Future<void> deleteMember(String id) async {
    final db = await database;
    await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  // Événements
  static Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      map['participants'] = (map['participants'] as String).split(',').where((s) => s.isNotEmpty).toList();
      return Event.fromJson(map);
    });
  }

  static Future<void> insertEvent(Event event) async {
    final db = await database;
    final eventData = event.toJson();
    eventData['participants'] = (eventData['participants'] as List<String>).join(',');
    await db.insert('events', eventData);
  }

  static Future<void> deleteEvent(String id) async {
    final db = await database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateEventParticipants(String eventId, List<String> participants) async {
    final db = await database;
    await db.update(
      'events',
      {'participants': participants.join(',')},
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }
}