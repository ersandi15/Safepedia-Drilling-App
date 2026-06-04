import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  static Database? _database;
  static const String tableName = 'drilling_activities';

  // Singleton pattern untuk memastikan hanya ada satu instance database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'safepedia_drilling.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            holeId TEXT,
            accelX REAL,
            accelY REAL,
            accelZ REAL,
            gyroX REAL,
            gyroY REAL,
            gyroZ REAL,
            imagePath TEXT,
            status TEXT,
            isSubmitted INTEGER
          )
        ''');
      },
    );
  }
}