import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  final String tableSavedEvents = 'savedEvents';
  final String tableProfile = 'profile';
  final String tableSavedTickets = 'savedTickets';

  final String columnEventId = 'id';
  final String columnTitle = 'title';
  final String columnDate = 'date';
  final String columnLocation = 'location';
  final String columnIsSaved = 'isSaved';

  final String columnProfileId = 'id';
  final String columnName = 'name';
  final String columnEmail = 'email';
  final String columnPhone = 'phone';
  final String columnProfileLocation = 'location';

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future <Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'events_finder.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSavedEvents (
        $columnEventId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnLocation TEXT NOT NULL,
        $columnIsSaved INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableProfile (
        $columnProfileId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnEmail TEXT,
        $columnPhone TEXT,
        $columnProfileLocation TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableSavedTickets (
        $columnEventId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnLocation TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertSavedEvent(Map<String, dynamic> event) async {
    final dbClient = await db;
    return await dbClient.insert(tableSavedEvents, event);
  }

  Future<List<Map<String, dynamic>>> getSavedEvents() async {
    final dbClient = await db;
    return await dbClient.query(tableSavedEvents);
  }

  Future<int> deleteSavedEvent(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      tableSavedEvents,
      where: '$columnEventId = ?',
      whereArgs: [id],
    );
  }

  Future<int> addProfile(Map<String, dynamic> profile) async {
    final dbClient = await db;
    return await dbClient.insert(tableProfile, profile);
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(tableProfile);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateProfile(Map<String, dynamic> profile) async {
    final dbClient = await db;
    return await dbClient.update(
      tableProfile,
      profile,
      where: '$columnProfileId = ?',
      whereArgs: [profile[columnProfileId]],
    );
  }

  Future<int> insertTicket(Map<String, dynamic> ticket) async {
    final dbClient = await db;
    return await dbClient.insert(tableSavedTickets, ticket);
  }

  Future<List<Map<String, dynamic>>> getSavedTickets() async {
    final dbClient = await db;
    return await dbClient.query(tableSavedTickets);
  }

  Future<int> deleteTicket(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      tableSavedTickets,
      where: '$columnEventId = ?',
      whereArgs: [id],
    );
  }
}