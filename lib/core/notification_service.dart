import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../models/settings.dart';

/// The one id this app ever schedules - there's only a single daily
/// reminder, so re-scheduling with the same id simply replaces whatever
/// was there before instead of stacking up duplicates.
const int _dailyReminderId = 1;

/// Thin seam around `flutter_local_notifications` so tests can inject a
/// fake that never touches a real platform channel - the same reasoning as
/// `TtsClient`/`AudioPlayerClient` in `audio_service.dart`: constructing
/// the real plugin and calling into it needs a registered platform
/// implementation that doesn't exist under `flutter test`.
abstract class NotificationClient {
  Future<void> initialize();

  /// Whether the user actually allowed notifications - null/true on
  /// platforms that don't ask (older Android, most desktop targets).
  Future<bool> requestPermission();

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  });

  Future<void> cancel(int id);
}

class RealNotificationClient implements NotificationClient {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _timezoneReady = false;

  Future<void> _ensureTimezone() async {
    if (_timezoneReady) return;
    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Falls back to whatever `timezone`'s own default local location is
      // (UTC) - a reminder firing at the wrong hour is a much smaller
      // problem than the feature crashing outright because a platform
      // channel this app doesn't strictly depend on failed.
    }
    _timezoneReady = true;
  }

  @override
  Future<void> initialize() async {
    await _ensureTimezone();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: darwinInit, macOS: darwinInit),
    );
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      // Returns null on Android <13, where notifications never needed
      // explicit permission in the first place - treated as granted.
      return (await android.requestNotificationsPermission()) ?? true;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return (await ios.requestPermissions(alert: true, badge: true, sound: true)) ?? false;
    }
    final macos = _plugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
    if (macos != null) {
      return (await macos.requestPermissions(alert: true, badge: true, sound: true)) ?? false;
    }
    // Web/Linux/Windows: no permission prompt in this plugin, never blocked.
    return true;
  }

  @override
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _ensureTimezone();
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily reminder',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // No SCHEDULE_EXACT_ALARM permission needed - a practice reminder
      // firing within a few minutes of the chosen time is perfectly fine,
      // and inexact scheduling avoids the extra Play Store policy scrutiny
      // exact alarms carry for a feature this minor.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

/// Notification title/body per app language (Etappe 24) - kept as a small
/// manual lookup rather than going through `AppLocalizations`, since
/// scheduling happens in `main.dart` before any `BuildContext` exists.
/// Falls back to English for an unset ("follow system") locale, same as
/// the rest of the app's non-widget code has no reliable way to read the
/// OS locale outside a widget tree.
const Map<String, (String, String)> _reminderText = {
  'de': ('Zeit zum Amharisch lernen!', 'Ein paar Minuten reichen schon - mach weiter mit Habesha Speak.'),
  'en': ('Time to learn Amharic!', 'A few minutes are enough - keep going with Habesha Speak.'),
  'nl': ('Tijd om Amhaars te leren!', 'Een paar minuten zijn al genoeg - ga verder met Habesha Speak.'),
  'sv': ('Dags att lära dig amhariska!', 'Några minuter räcker - fortsätt med Habesha Speak.'),
  'it': ('È ora di imparare l\'amarico!', 'Bastano pochi minuti - continua con Habesha Speak.'),
  'es': ('¡Es hora de aprender amárico!', 'Con unos minutos basta - sigue practicando con Habesha Speak.'),
};

/// Owns the app's one daily practice-reminder notification. Fully driven
/// by [AppSettings] - call [syncWithSettings] once at startup and again
/// every time settings change (the same pattern `main.dart` already uses
/// for `AudioService`'s sound settings), and it schedules/reschedules/
/// cancels as needed without the caller having to track what changed.
class NotificationService {
  final NotificationClient _client;

  NotificationService({NotificationClient? client}) : _client = client ?? RealNotificationClient();

  Future<void> init() => _client.initialize();

  /// Returns false if the user denied the OS permission prompt - the
  /// caller (the Settings screen) uses this to show an explanatory message
  /// and leave the toggle off instead of silently pretending it's enabled.
  Future<bool> requestPermission() => _client.requestPermission();

  Future<void> syncWithSettings(AppSettings settings) async {
    if (!settings.dailyReminderEnabled) {
      await _client.cancel(_dailyReminderId);
      return;
    }
    final (title, body) = _reminderText[settings.localeCode] ?? _reminderText['en']!;
    await _client.scheduleDaily(
      id: _dailyReminderId,
      title: title,
      body: body,
      hour: settings.reminderHour,
      minute: settings.reminderMinute,
    );
  }
}
