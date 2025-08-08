import '../models/diary_event_model.dart';
import '../services/database_helper.dart';

class DiaryRepository {
  final dbHelper = DatabaseHelper();

  Future<int> addEvent(DiaryEvent event) async {
    final db = await dbHelper.database;
    return await db.insert('events', event.toMap());
  }

  Future<List<DiaryEvent>> getAllEvents() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('events', orderBy: 'startTime DESC');
    return List.generate(maps.length, (i) {
      return DiaryEvent.fromMap(maps[i]);
    });
  }

  Future<List<DiaryEvent>> getEventsForDateRange(DateTime start, DateTime end) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'startTime >= ? AND startTime <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'startTime DESC',
    );
    return List.generate(maps.length, (i) {
      return DiaryEvent.fromMap(maps[i]);
    });
  }

  Future<List<DiaryEvent>> getEventsPaginated({
    int limit = 50,
    int offset = 0,
    String? query,
  }) async {
    final db = await dbHelper.database;
    List<Map<String, dynamic>> maps;

    if (query != null && query.isNotEmpty) {
      maps = await db.query(
        'events',
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'startTime DESC',
        limit: limit,
        offset: offset,
      );
    } else {
      maps = await db.query(
        'events',
        orderBy: 'startTime DESC',
        limit: limit,
        offset: offset,
      );
    }

    return List.generate(maps.length, (i) {
      return DiaryEvent.fromMap(maps[i]);
    });
  }

  Future<DiaryEvent?> getEventById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DiaryEvent.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<String>> getUniqueTitles(String query) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      distinct: true,
      columns: ['title'],
      where: 'title LIKE ?',
      whereArgs: ['$query%'],
    );

    return List.generate(maps.length, (i) {
      return maps[i]['title'] as String;
    });
  }

  Future<int> updateEvent(DiaryEvent event) async {
    final db = await dbHelper.database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
