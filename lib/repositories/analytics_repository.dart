import '../local_db/app_database.dart';

class AnalyticsRepository {
  final _db = AppDatabase.instance;

  /// 🔥 STUDY STREAK (unique active days in last 7 days)
  Future<int> getWeeklyStudyStreak(String uid) async {
    final db = await _db.database;

    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6)).millisecondsSinceEpoch;

    final rows = await db.query(
      'tasks',
      where: 'uid = ? AND createdAt >= ?',
      whereArgs: [uid, start],
    );

    final activeDays = <String>{};

    for (final row in rows) {
      final date = DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int);
      activeDays.add('${date.year}-${date.month}-${date.day}');
    }

    return activeDays.length;
  }

  /// 💰 TOTAL EXPENSE THIS WEEK
  Future<double> getWeeklyExpenseTotal(String uid) async {
    final db = await _db.database;

    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6)).millisecondsSinceEpoch;

    final rows = await db.query(
      'expenses',
      where: 'uid = ? AND createdAt >= ?',
      whereArgs: [uid, start],
    );

    double total = 0;
    for (final row in rows) {
      total += (row['amount'] as num).toDouble();
    }

    return total;
  }

  /// 💸 NUMBER OF EXPENSES THIS WEEK
  Future<int> getWeeklyExpenseCount(String uid) async {
    final db = await _db.database;

    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6)).millisecondsSinceEpoch;

    final rows = await db.query(
      'expenses',
      where: 'uid = ? AND createdAt >= ?',
      whereArgs: [uid, start],
    );

    return rows.length;
  }
}
