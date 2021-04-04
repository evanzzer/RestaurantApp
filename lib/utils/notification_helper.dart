import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper _instance;

  NotificationHelper._createObject();

  factory NotificationHelper() {
    if (_instance == null) {
      _instance = NotificationHelper._createObject();
    }
    return _instance;
  }

  Future<void> initNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          print('Notification Payload: $payload');
        }
        selectNotificationSubject.add(payload);
      }
    );
  }

  Future<void> showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, RestaurantResult restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_restaurant";
    var _channelDescription = "Restaurant Notification";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId, _channelName, _channelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Restaurant on the Line</b>";
    var randomNumber = Random().nextInt(restaurant.count);
    var selectedRestaurant = restaurant.restaurants[randomNumber];

    var titleNews = selectedRestaurant.name;

    await flutterLocalNotificationsPlugin.show(
      0, titleNotification, titleNews, platformChannelSpecifics, payload: json.encode(selectedRestaurant.toJson())
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = Restaurant.fromJson(json.decode(payload));
      Navigation.intentWithData(route, data);
    });
  }
}