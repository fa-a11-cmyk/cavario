import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member.dart';
import '../models/event.dart';
import '../models/horse.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'cavario.db';
  static const int _dbVersion = 2;

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
      onUpgrade: _upgradeTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    // Table membres
    await db.execute('''
      CREATE TABLE members(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        membershipType TEXT NOT NULL,
        joinDate TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        paymentStatus TEXT DEFAULT 'pending'
      )
    ''');

    // Table événements
    await db.execute('''
      CREATE TABLE events(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        location TEXT NOT NULL,
        maxParticipants INTEGER NOT NULL,
        participants TEXT NOT NULL,
        type TEXT NOT NULL,
        price REAL DEFAULT 0.0
      )
    ''');

    // Table chevaux
    await db.execute('''
      CREATE TABLE horses(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        breed TEXT NOT NULL,
        age INTEGER NOT NULL,
        color TEXT NOT NULL,
        gender TEXT NOT NULL,
        healthStatus TEXT NOT NULL,
        isAvailable INTEGER NOT NULL DEFAULT 1,
        assignedRider TEXT,
        specialNeeds TEXT
      )
    ''');

    // Table équipements
    await db.execute('''
      CREATE TABLE equipment(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        condition TEXT NOT NULL,
        isAvailable INTEGER NOT NULL DEFAULT 1,
        lastMaintenance TEXT NOT NULL,
        nextMaintenance TEXT
      )
    ''');

    // Table messages chat
    await db.execute('''
      CREATE TABLE chat_messages(
        id TEXT PRIMARY KEY,
        senderId TEXT NOT NULL,
        senderName TEXT NOT NULL,
        message TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Table paiements
    await db.execute('''
      CREATE TABLE payments(
        id TEXT PRIMARY KEY,
        memberId TEXT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        status TEXT NOT NULL,
        paymentDate TEXT NOT NULL,
        description TEXT
      )
    ''');

    // Données de démonstration
    await _insertDemoData(db);
  }

  static Future<void> _upgradeTables(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE members ADD COLUMN paymentStatus TEXT DEFAULT "pending"');
      await db.execute('ALTER TABLE events ADD COLUMN price REAL DEFAULT 0.0');
    }
  }

  static Future<void> _insertDemoData(Database db) async {
    // Membres
    await db.insert('members', {
      'id': '1',
      'name': 'Marie Dubois',
      'email': 'marie@email.com',
      'phone': '0123456789',
      'membershipType': 'Premium',
      'joinDate': DateTime(2023, 1, 15).toIso8601String(),
      'isActive': 1,
      'paymentStatus': 'paid',
    });

    await db.insert('members', {
      'id': '2',
      'name': 'Pierre Martin',
      'email': 'pierre@email.com',
      'phone': '0987654321',
      'membershipType': 'Standard',
      'joinDate': DateTime(2023, 3, 20).toIso8601String(),
      'isActive': 1,
      'paymentStatus': 'pending',
    });

    // Chevaux
    await db.insert('horses', {
      'id': '1',
      'name': 'Thunder',
      'breed': 'Pur-sang',
      'age': 8,
      'color': 'Bai',
      'gender': 'Étalon',
      'healthStatus': 'Excellent',
      'isAvailable': 1,
      'assignedRider': null,
      'specialNeeds': '',
    });

    await db.insert('horses', {
      'id': '2',
      'name': 'Belle',
      'breed': 'Quarter Horse',
      'age': 6,
      'color': 'Alezan',
      'gender': 'Jument',
      'healthStatus': 'Bon',
      'isAvailable': 1,
      'assignedRider': '1',
      'specialNeeds': 'Régime spécial',
    });

    // Équipements
    await db.insert('equipment', {
      'id': '1',
      'name': 'Selle de dressage #1',
      'type': 'Selle',
      'condition': 'Excellent',
      'isAvailable': 1,
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'nextMaintenance': DateTime.now().add(const Duration(days: 60)).toIso8601String(),
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

  // Chevaux
  static Future<List<Horse>> getHorses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('horses');
    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      map['specialNeeds'] = (map['specialNeeds'] as String).split(',').where((s) => s.isNotEmpty).toList();
      map['isAvailable'] = map['isAvailable'] == 1;
      return Horse.fromJson(map);
    });
  }

  static Future<void> insertHorse(Horse horse) async {
    final db = await database;
    final horseData = horse.toJson();
    horseData['specialNeeds'] = (horseData['specialNeeds'] as List<String>).join(',');
    horseData['isAvailable'] = horseData['isAvailable'] ? 1 : 0;
    await db.insert('horses', horseData);
  }

  static Future<void> deleteHorse(String id) async {
    final db = await database;
    await db.delete('horses', where: 'id = ?', whereArgs: [id]);
  }

  // Équipements
  static Future<List<Equipment>> getEquipment() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('equipment');
    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      map['isAvailable'] = map['isAvailable'] == 1;
      return Equipment.fromJson(map);
    });
  }

  static Future<void> insertEquipment(Equipment equipment) async {
    final db = await database;
    final equipmentData = equipment.toJson();
    equipmentData['isAvailable'] = equipmentData['isAvailable'] ? 1 : 0;
    await db.insert('equipment', equipmentData);
  }

  static Future<void> deleteEquipment(String id) async {
    final db = await database;
    await db.delete('equipment', where: 'id = ?', whereArgs: [id]);
  }

  // Messages chat
  static Future<List<Map<String, dynamic>>> getChatMessages() async {
    final db = await database;
    return await db.query('chat_messages', orderBy: 'timestamp ASC');
  }

  static Future<void> insertChatMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert('chat_messages', message);
  }

  // Paiements
  static Future<void> insertPayment(Map<String, dynamic> payment) async {
    final db = await database;
    await db.insert('payments', payment);
  }

  static Future<List<Map<String, dynamic>>> getPaymentHistory(String memberId) async {
    final db = await database;
    return await db.query(
      'payments',
      where: 'memberId = ?',
      whereArgs: [memberId],
      orderBy: 'paymentDate DESC',
    );
  }
}