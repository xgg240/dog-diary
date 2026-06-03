// ============================================================
//  通知服务 (本地通知)
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return;
    tz.initializeTimeZones();
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(initSettings);

    // Android 13+ 运行时申请 POST_NOTIFICATIONS 权限
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      // granted 可以是 null (老 Android) / true / false
      // false 不 throw，scheduleReminder 失败时会吞错
    }
  }

  /// 手动重新请求通知权限（设置页可调）
  static Future<bool?> requestPermission() async {
    if (kIsWeb) return null;
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return null;
    return await androidImpl.requestNotificationsPermission();
  }

  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails('dog_diary', '养狗日记', importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
    try {
      await _plugin.show(id, title, body, details);
    } catch (e) {
      debugPrint('⚠️ showNow 失败: $e');
    }
  }

  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    if (kIsWeb) return;
    if (when.isBefore(DateTime.now())) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails('dog_diary_reminder', '提醒', importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(when, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // 权限被拒绝/未授权时吞错，不让功能崩
      debugPrint('⚠️ scheduleReminder 失败: $e');
    }
  }
}
