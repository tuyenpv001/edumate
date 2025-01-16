import 'package:edumate/services/NotificationService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();
  final notificationService = new NotificationService();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'study_app.db');

    return await openDatabase(
      path,
      version: 2, // Tăng version khi thay đổi database
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await _createTables(db); // Đảm bảo bảng mới được tạo khi nâng cấp
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Tạo bảng ghi chú
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');
    // Tạo bảng flashcards
    await db.execute('''
      CREATE TABLE IF NOT EXISTS flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        repeat_type TEXT NOT NULL, -- "fixed" hoặc "interval"
        fixed_time TEXT, -- Lưu giờ cố định dưới dạng HH:mm
        interval_hours INTEGER, -- Khoảng thời gian (giờ)
        interval_minutes INTEGER, -- Khoảng thời gian (phút)
        notification_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS config (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL UNIQUE, -- "note", "flashcard", "reminder"
        repeat_time TEXT,          -- Thời gian lặp (ví dụ: "10:30 AM")
        interval_hours INTEGER,    -- Khoảng cách giờ
        interval_minutes INTEGER   -- Khoảng cách phút
      )
    ''');
  }

  // // Reminder
  // Future<int> insertReminder({
  //   required String type,
  //   int? referenceId,
  //   required int hours,
  //   required int minutes,
  //   required String message,
  // }) async {
  //   final db = await database;
  //   return await db.insert(
  //     'reminders',
  //     {
  //       'type': type,
  //       'reference_id': referenceId,
  //       'interval_hours': hours,
  //       'interval_minutes': minutes,
  //       'message': message,
  //     },
  //   );
  // }

  // Future<List<Map<String, dynamic>>> getReminders() async {
  //   final db = await database;
  //   return await db.query('reminders');
  // }

  Future<List<Map<String, dynamic>>> getFlashcard() async {
    final db = await database;
    return await db.query('flashcards');
  }

  Future<int> insertNote({
    required String uuid,
    required String title,
    required String content,
  }) async {
    final db = await database;
    return await db.insert(
      'notes',
      {
        'uuid': uuid,
        'title': title,
        'content': content,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes');
  }

  Future<int> deleteNote(String uuid) async {
    final db = await database;
    return await db.delete('notes', where: 'uuid = ?', whereArgs: [uuid]);
  }

  Future<int> deleteNoteId(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteFlashcardId(int id) async {
    final db = await database;
    return await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  // Future<int> deleteReminder(int id) async {
  //   final db = await database;
  //   return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  // }

  Future<int> deleteReminderAll() async {
    final db = await database;
    return await db.delete('reminders');
  }

  // COnfig
  Future<int> insertOrUpdateConfig({
    required String type,
    String? repeatTime,
    int? intervalHours,
    int? intervalMinutes,
  }) async {
    final db = await database;

    final existingConfig = await db.query(
      'config',
      where: 'type = ?',
      whereArgs: [type],
    );

    if (existingConfig.isNotEmpty) {
      // Update existing config
      return await db.update(
        'config',
        {
          'repeat_time': repeatTime,
          'interval_hours': intervalHours,
          'interval_minutes': intervalMinutes,
        },
        where: 'type = ?',
        whereArgs: [type],
      );
    } else {
      // Insert new config
      return await db.insert(
        'config',
        {
          'type': type,
          'repeat_time': repeatTime,
          'interval_hours': intervalHours,
          'interval_minutes': intervalMinutes,
        },
      );
    }
  }

  Future<Map<String, dynamic>?> getConfigByType(String type) async {
    final db = await database;
    final result = await db.query(
      'config',
      where: 'type = ?',
      whereArgs: [type],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteConfigByType(String type) async {
    final db = await database;
    return await db.delete('config', where: 'type = ?', whereArgs: [type]);
  }

  Future<List<Map<String, dynamic>>> getAllConfigs() async {
    final db = await database;
    return await db.query('config');
  }

  Future<int> insertReminder({
    required String title,
    String? content,
    required String repeatType,
    String? fixedTime,
    int? intervalHours,
    int? intervalMinutes,
  }) async {
    final db = await database;
    return await db.insert(
      'reminders',
      {
        'title': title,
        'content': content,
        'repeat_type': repeatType,
        'fixed_time': fixedTime,
        'interval_hours': intervalHours,
        'interval_minutes': intervalMinutes,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await database;
    return await db.query('reminders');
  }

  Future<int> updateReminder(int id, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update(
      'reminders',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteReminder(int id) async {
    final db = await database;

    // Lấy notification_id của reminder
    final reminder = await db.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (reminder.isNotEmpty) {
      final notificationId = reminder.first['notification_id'] as int?;

      // Hủy thông báo nếu có
      if (notificationId != null) {
        await notificationService.flutterLocalNotificationsPlugin
            .cancel(notificationId);
        print('Notification with ID $notificationId canceled.');
      }

      // Xóa reminder khỏi cơ sở dữ liệu
      await db.delete(
        'reminders',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<int> deleteAllReminders() async {
    final db = await database;
    return await db.delete('reminders');
  }

  Future<int> insertFlashcard({
    required String title,
    required String question,
    required String answer,
  }) async {
    final db = await database;
    return await db.insert(
      'flashcards',
      {
        'title': title,
        'question': question,
        'answer': answer,
      },
    );
  }

  Future<int> deleteFlashcard(int id) async {
    final db = await database;
    return await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFlashcard({
    required int id,
    required String title,
    required String question,
    required String answer,
  }) async {
    final db = await database;
    return await db.update(
      'flashcards',
      {
        'title': title,
        'question': question,
        'answer': answer,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateNotificationId(int reminderId, int notificationId) async {
    final db = await database;
    await db.update(
      'reminders',
      {'notification_id': notificationId},
      where: 'id = ?',
      whereArgs: [reminderId],
    );
  }
}
