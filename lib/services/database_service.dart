import 'package:sqflite/sqflite.dart';
import '../core/database/db_provider.dart';
import '../features/home/models/drilling_activity_model.dart';

class DatabaseService {
  // Fungsi untuk menyimpan data baru (baik sebagai Draft maupun Submitted)
  Future<int> insertActivity(DrillingActivityModel activity) async {
    final db = await DbProvider.database;
    return await db.insert(
      DbProvider.tableName,
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fungsi untuk mengambil data berstatus OFFLINE (Draft) -> isSubmitted = 0
  Future<List<DrillingActivityModel>> getOfflineActivities() async {
    final db = await DbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DbProvider.tableName,
      where: 'isSubmitted = ?',
      whereArgs: [0],
      orderBy: 'id DESC', // Tampilkan dari yang paling baru
    );

    return List.generate(maps.length, (i) => DrillingActivityModel.fromMap(maps[i]));
  }

  // Fungsi untuk mengambil data berstatus ONLINE (Submitted/API) -> isSubmitted = 1
  Future<List<DrillingActivityModel>> getOnlineActivities() async {
    final db = await DbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DbProvider.tableName,
      where: 'isSubmitted = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) => DrillingActivityModel.fromMap(maps[i]));
  }

  // Fungsi untuk mengupdate data yang sudah ada (edit draft)
  Future<int> updateActivity(DrillingActivityModel activity) async {
    final db = await DbProvider.database;
    return await db.update(
      DbProvider.tableName,
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  // Fungsi opsional: Mengubah status dari Draft menjadi Submitted (jika nanti dibutuhkan di UI)
  Future<int> submitDraft(int id) async {
    final db = await DbProvider.database;
    return await db.update(
      DbProvider.tableName,
      {'isSubmitted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}