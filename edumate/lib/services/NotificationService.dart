import 'dart:async';

import 'package:edumate/services/db_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    // const DarwinInitializationSettings darwinInitializationSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse details) {
    print("noti clicked: ${details.payload}");
  }

  Future<void> showInstantNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "instant_channel",
      "Instant Notification",
      channelDescription: "Channel for instant",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpec =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(0, 'title', 'body', platformChannelSpec, payload: "INstant");
  }

  Future<void> scheduleRepeatingNotification() async {
    print("repeat ");

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   0, // ID thông báo
    //   'Scheduled Notification', // Tiêu đề
    //   'This notification repeats every minute.', // Nội dung
    //   _nextInstance(), // Thời gian thông báo đầu tiên
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'repeating_channel', // ID kênh
    //       'Repeating Notifications', // Tên kênh
    //       channelDescription:
    //           'This channel is used for repeating notifications.',
    //       importance: Importance.max,
    //       priority: Priority.high,
    //     ),
    //   ),

    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      await flutterLocalNotificationsPlugin.show(
        timer.tick, // ID thông báo duy nhất
        'Repeating Notification', // Tiêu đề
        'This notification repeats every 10 seconds. Tick: ${timer.tick}', // Nội dung
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'manual_repeating_channel',
            'Manual Repeating Notifications',
            channelDescription:
                'Notifications manually repeated every 10 seconds.',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
      print('Notification sent: ${timer.tick}');
    });
  }

  tz.TZDateTime _nextInstance() {
    final now = tz.TZDateTime.now(tz.local);
    return now.add(const Duration(seconds: 10));
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Future<void> scheduleReminders() async {
  //   final dbHelper = DBHelper();
  //   final reminders = await dbHelper.getReminders();

  //   if (reminders.isEmpty) {
  //     print('No reminders found.');
  //     return;
  //   }

  //   for (var reminder in reminders) {
  //     final type = reminder['type'] as String;
  //     final message = reminder['message'] as String;
  //     final intervalHours = reminder['interval_hours'] as int;
  //     final intervalMinutes = reminder['interval_minutes'] as int;

  //     Timer.periodic(
  //       Duration(hours: intervalHours, minutes: intervalMinutes),
  //       (timer) async {
  //         final now = tz.TZDateTime.now(tz.local);

  //         // Tùy chỉnh tiêu đề thông báo
  //         String title = 'Reminder';
  //         if (type == 'note') {
  //           title = 'Note Reminder';
  //         } else if (type == 'flashcard') {
  //           title = 'Flashcard Reminder';
  //         } else if (type == 'general') {
  //           title = 'Study Reminder';
  //         }

  //         await flutterLocalNotificationsPlugin.show(
  //           timer.tick, // ID duy nhất
  //           title, // Tiêu đề
  //           message, // Nội dung
  //           const NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               'reminder_channel',
  //               'Reminder Notifications',
  //               channelDescription: 'Study reminders',
  //               importance: Importance.max,
  //               priority: Priority.high,
  //             ),
  //           ),
  //         );
  //         print('Notification sent at $now with message: $message');
  //       },
  //     );
  //   }
  // }

  // Future<void> scheduleReminders() async {
  //   final dbHelper = DBHelper();
  //   final reminders = await dbHelper.getReminders(); // Lấy cấu hình từ SQLite

  //   if (reminders.isEmpty) {
  //     print('No reminders found.');
  //     return;
  //   }

  //   for (var reminder in reminders) {
  //     final type = reminder['type'] as String;
  //     final message = reminder['message'] as String;
  //     final intervalHours = reminder['interval_hours'] as int;
  //     final intervalMinutes = reminder['interval_minutes'] as int;

  //     // Tạo lịch lặp theo cấu hình
  //     Timer.periodic(
  //       Duration(hours: intervalHours, minutes: intervalMinutes),
  //       (timer) async {
  //         final now = tz.TZDateTime.now(tz.local);

  //         if (type == 'note') {
  //           final notes = await dbHelper.getNotes();
  //           if (notes.isEmpty) {
  //             print('No notes found for notifications.');
  //             return;
  //           }

  //           for (int i = 0; i < notes.length; i++) {
  //             final note = notes[i];
  //             final title = note['title'] as String;
  //             final content = note['content'] as String;

  //             // Gửi thông báo cho từng ghi chú, cách nhau 15 giây
  //             Future.delayed(Duration(seconds: i * 15), () async {
  //               await flutterLocalNotificationsPlugin.show(
  //                 now.millisecondsSinceEpoch % 100000 + i, // ID duy nhất
  //                 title, // Tiêu đề ghi chú
  //                 content, // Nội dung ghi chú
  //                 const NotificationDetails(
  //                   android: AndroidNotificationDetails(
  //                     'reminder_channel',
  //                     'Reminder Notifications',
  //                     channelDescription: 'Study reminders',
  //                     importance: Importance.max,
  //                     priority: Priority.high,
  //                   ),
  //                 ),
  //               );
  //               print(
  //                   'Notification sent at ${tz.TZDateTime.now(tz.local)} with title: $title and content: $content');
  //             });
  //           }
  //         } else {
  //           // Xử lý các loại cấu hình khác (flashcard, general)
  //           String notificationTitle = 'Reminder';
  //           if (type == 'flashcard') notificationTitle = 'Flashcard Reminder';
  //           if (type == 'general') notificationTitle = 'General Reminder';

  //           await flutterLocalNotificationsPlugin.show(
  //             now.millisecondsSinceEpoch % 100000, // ID duy nhất
  //             notificationTitle,
  //             message,
  //             const NotificationDetails(
  //               android: AndroidNotificationDetails(
  //                 'reminder_channel',
  //                 'Reminder Notifications',
  //                 channelDescription: 'Study reminders',
  //                 importance: Importance.max,
  //                 priority: Priority.high,
  //               ),
  //             ),
  //           );
  //           print(
  //               'Notification sent at $now with title: $notificationTitle and message: $message');
  //         }
  //       },
  //     );
  //   }
  // }

  Future<void> scheduleReminders() async {
    final dbHelper = DBHelper();

    // Lấy danh sách cấu hình từ bảng `config`
    final configs = await dbHelper.getAllConfigs();
    if (configs.isEmpty) {
      print('No configurations found.');
      return;
    }

    print(configs);

    for (var config in configs) {
      final type = config['type'] as String;

      if (type == 'note') {
        _scheduleNoteNotifications(dbHelper, config);
      } else if (type == 'flashcard') {
        _scheduleFlashcardNotifications(dbHelper, config);
      }
    }
  }

  Future<void> _scheduleNoteNotifications(
      DBHelper dbHelper, Map<String, dynamic> config) async {
    final repeatTime = config['repeat_time'] as String?;
    final intervalHours = config['interval_hours'] as int?;
    final intervalMinutes = config['interval_minutes'] as int?;

    final notes = await dbHelper.getNotes();
    if (notes.isEmpty) {
      print('No notes found for notifications.');
      return;
    }

    if (repeatTime != null) {
      // Lặp lại theo giờ cố định
      final timeParts = repeatTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1].split(' ')[0]);
      final isPM = repeatTime.contains('PM');

      Timer.periodic(Duration(days: 1), (timer) async {
        final now = tz.TZDateTime.now(tz.local);
        final notificationTime = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          isPM ? hour + 12 : hour,
          minute,
        );

        if (now.isAfter(notificationTime)) return;

        for (int i = 0; i < notes.length; i++) {
          final note = notes[i];
          final title = note['title'] as String;
          final content = note['content'] as String;

          Future.delayed(Duration(seconds: i * 15), () async {
            await flutterLocalNotificationsPlugin.show(
              now.millisecondsSinceEpoch % 100000 + i,
              title,
              content,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'note_channel',
                  'Note Notifications',
                  channelDescription: 'Note reminders',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
          });
        }
      });
    } else if (intervalHours != null || intervalMinutes != null) {
      // Lặp lại sau khoảng thời gian
      Timer.periodic(
        Duration(
          hours: intervalHours ?? 0,
          minutes: intervalMinutes ?? 0,
        ),
        (timer) async {
          for (int i = 0; i < notes.length; i++) {
            final note = notes[i];
            final title = note['title'] as String;
            final content = note['content'] as String;

            Future.delayed(Duration(seconds: i * 15), () async {
              final now = tz.TZDateTime.now(tz.local);
              await flutterLocalNotificationsPlugin.show(
                now.millisecondsSinceEpoch % 100000 + i,
                title,
                content,
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'note_channel',
                    'Note Notifications',
                    channelDescription: 'Note reminders',
                    importance: Importance.max,
                    priority: Priority.high,
                  ),
                ),
              );
            });
          }
        },
      );
    }
  }

  Future<void> _scheduleFlashcardNotifications(
      DBHelper dbHelper, Map<String, dynamic> config) async {
    final repeatTime = config['repeat_time'] as String?;
    final intervalHours = config['interval_hours'] as int?;
    final intervalMinutes = config['interval_minutes'] as int?;

    final flashcards = await dbHelper.getFlashcard();
    if (flashcards.isEmpty) {
      print('No flashcards found for notifications.');
      return;
    }

    if (repeatTime != null) {
      // Lặp lại theo giờ cố định
      final timeParts = repeatTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1].split(' ')[0]);
      final isPM = repeatTime.contains('PM');

      Timer.periodic(Duration(days: 1), (timer) async {
        final now = tz.TZDateTime.now(tz.local);
        final notificationTime = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          isPM ? hour + 12 : hour,
          minute,
        );

        if (now.isAfter(notificationTime)) return;

        for (int i = 0; i < flashcards.length; i++) {
          final flashcard = flashcards[i];
          final question = flashcard['question'] as String;
          final answer = flashcard['answer'] as String;

          Future.delayed(Duration(seconds: i * 15), () async {
            await flutterLocalNotificationsPlugin.show(
              now.millisecondsSinceEpoch % 100000 + i,
              'Flashcard: $question',
              answer,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'flashcard_channel',
                  'Flashcard Notifications',
                  channelDescription: 'Flashcard reminders',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
          });
        }
      });
    } else if (intervalHours != null || intervalMinutes != null) {
      // Lặp lại sau khoảng thời gian
      Timer.periodic(
        Duration(
          hours: intervalHours ?? 0,
          minutes: intervalMinutes ?? 0,
        ),
        (timer) async {
          for (int i = 0; i < flashcards.length; i++) {
            final flashcard = flashcards[i];
            final question = flashcard['question'] as String;
            final answer = flashcard['answer'] as String;

            Future.delayed(Duration(seconds: i * 15), () async {
              final now = tz.TZDateTime.now(tz.local);
              await flutterLocalNotificationsPlugin.show(
                now.millisecondsSinceEpoch % 100000 + i,
                'Flashcard: $question',
                answer,
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'flashcard_channel',
                    'Flashcard Notifications',
                    channelDescription: 'Flashcard reminders',
                    importance: Importance.max,
                    priority: Priority.high,
                  ),
                ),
              );
            });
          }
        },
      );
    }
  }

  Future<void> scheduleReminderSpecial() async {
    final dbHelper = DBHelper();
    final reminders = await dbHelper.getReminders();

    if (reminders.isEmpty) {
      print('No reminders found.');
      return;
    }

    print(reminders.length);
    for (var reminder in reminders) {
      _scheduleReminderForItem(reminder);
    }
  }

  void _scheduleReminderForItem(Map<String, dynamic> reminder) {
    final id = reminder['id'] as int;
    final title = reminder['title'] as String;
    final content = reminder['content'] as String?;
    final repeatType = reminder['repeat_type'] as String;
    final fixedTime = reminder['fixed_time'] as String?;
    final intervalHours = reminder['interval_hours'] as int?;
    final intervalMinutes = reminder['interval_minutes'] as int?;

    if (repeatType == 'fixed' && fixedTime != null) {
      _scheduleFixedReminder(title, content, fixedTime);
    } else if (repeatType == 'interval') {
      _scheduleIntervalReminder(
          title, content, intervalHours, intervalMinutes, id);
    } else {
      print('Invalid configuration for reminder: $title');
    }
  }

  void _scheduleFixedReminder(String title, String? content, String fixedTime) {
    final timeParts = fixedTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    Timer.periodic(Duration(days: 1), (timer) async {
      final now = tz.TZDateTime.now(tz.local);
      final notificationTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (now.isAfter(notificationTime)) return; // Bỏ qua nếu đã qua giờ
      final notificationId = now.millisecondsSinceEpoch % 100000;
      await flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        content ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Fixed Time Reminders',
            channelDescription: 'Daily reminders at a fixed time',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );

      print(
          'Notification sent at $notificationTime with title: $title and content: $content');
    });
  }

  void _scheduleIntervalReminder(String title, String? content,
      int? intervalHours, int? intervalMinutes, int id) {
    if (intervalHours == null && intervalMinutes == null) {
      print('Invalid interval configuration for reminder: $title');
      return;
    }

    Timer.periodic(
      Duration(
        hours: intervalHours ?? 0,
        minutes: intervalMinutes ?? 0,
      ),
      (timer) async {
        final now = tz.TZDateTime.now(tz.local);
        final notificationId = now.millisecondsSinceEpoch % 100000;
        await flutterLocalNotificationsPlugin.show(
          notificationId,
          title,
          content ?? '',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminder_channel',
              'Interval Reminders',
              channelDescription: 'Reminders at regular intervals',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
        // Cập nhật notification_id vào cơ sở dữ liệu
        final dbHelper = DBHelper();
        await dbHelper.updateNotificationId(id, notificationId);

        print(
            'Notification sent at $now with title: $title and content: $content');
      },
    );
  }
}
