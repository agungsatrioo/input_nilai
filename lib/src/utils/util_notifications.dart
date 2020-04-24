import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:input_nilai/src/utils/util_common.dart';

class NotificationUtils {
  static final NotificationUtils _instance = NotificationUtils._internal();

  factory NotificationUtils() => _instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Map<String, Function> _actions;

  NotificationUtils._internal() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onClick);
    _actions = new Map();
  }

  static NotificationUtils get object => _instance;

  Future notify(int id, String title, String body, Function action) async {
    String payload = generateStr();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    _actions.putIfAbsent(payload, action);
  }

  Future _onClick(String payload) async {
    _actions.forEach((name, action) {
      if (name == payload) {
        action();
      }
    });

    _actions.removeWhere((name, action) {
      return name == payload;
    });
  }
}
