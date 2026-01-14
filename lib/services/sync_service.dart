import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../local_db/app_database.dart';

class SyncService {
  final _db = AppDatabase.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Call this whenever app opens or connectivity changes
  Future<void> syncAll(String uid) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    await _syncTasks(uid);
    await _syncExpenses(uid);
  }

  Future<void> _syncTasks(String uid) async {
    final db = await _db.database;

    final unsynced = await db.query(
      'tasks',
      where: 'uid = ? AND synced = 0',
      whereArgs: [uid],
    );

    for (final task in unsynced) {
      await _firestore.collection('tasks').add({
        'uid': uid,
        'title': task['title'],
        'createdAt': Timestamp.fromMillisecondsSinceEpoch(
          task['createdAt'] as int,
        ),
      });

      await db.update(
        'tasks',
        {'synced': 1},
        where: 'id = ?',
        whereArgs: [task['id']],
      );
    }
  }

  Future<void> _syncExpenses(String uid) async {
    final db = await _db.database;

    final unsynced = await db.query(
      'expenses',
      where: 'uid = ? AND synced = 0',
      whereArgs: [uid],
    );

    for (final e in unsynced) {
      await _firestore.collection('expenses').add({
        'uid': uid,
        'title': e['title'],
        'amount': e['amount'],
        'createdAt': Timestamp.fromMillisecondsSinceEpoch(
          e['createdAt'] as int,
        ),
      });

      await db.update(
        'expenses',
        {'synced': 1},
        where: 'id = ?',
        whereArgs: [e['id']],
      );
    }
  }
}
