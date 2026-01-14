import '../local_db/app_database.dart';

class ExpenseRepository {
  final _db = AppDatabase.instance;

  /// ADD EXPENSE (OFFLINE-FIRST)
  Future<void> addExpense({
    required String uid,
    required String title,
    required double amount,
  }) async {
    final db = await _db.database;

    await db.insert('expenses', {
      'uid': uid,
      'title': title,
      'amount': amount,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'synced': 0,
    });
  }

  /// GET EXPENSES (OFFLINE)
  Future<List<Map<String, dynamic>>> getExpenses(String uid) async {
    final db = await _db.database;

    return await db.query(
      'expenses',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'createdAt DESC',
    );
  }
}
