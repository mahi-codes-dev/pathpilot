import '../local_db/app_database.dart';

class TaskRepository {
  final _db = AppDatabase.instance;

  /// ADD TASK (OFFLINE-FIRST)
  Future<void> addTask({
    required String uid,
    required String title,
  }) async {
    final db = await _db.database;

    await db.insert('tasks', {
      'uid': uid,
      'title': title,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'synced': 0,
    });
  }

  /// GET TASKS (OFFLINE)
  Future<List<Map<String, dynamic>>> getTasks(String uid) async {
    final db = await _db.database;

    return await db.query(
      'tasks',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'createdAt DESC',
    );
  }
}
