import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'chat_database.db';
  static final _databaseVersion = 1;

  static final _messagesTableName = 'messages_Table';
  static final columnId = 'id';
  static final columnIdSender = 'id_sender';
  static final columnIdReceiver = 'id_receiver';
  static final columnText = 'text_msg';
  static final columnDate = 'date';
  static final columnTime = 'time';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_messagesTableName (
        $columnId INTEGER PRIMARY KEY,
        $columnIdSender TEXT NOT NULL,
        $columnIdReceiver TEXT NOT NULL,
        $columnText TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnTime TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertMessage(Map<String, dynamic> message) async {
    final db = await instance.database;
    await db.insert(_messagesTableName, message);
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await instance.database;
    return await db.query(_messagesTableName);
  }
}
