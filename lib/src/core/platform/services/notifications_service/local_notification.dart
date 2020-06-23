import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';

import '../dialog_services/service_locator.dart';

class LocalNotificationService {
  // private default constructor
  LocalNotificationService._();

  // singleton
  static LocalNotificationService _instance = LocalNotificationService._();

  factory LocalNotificationService.getInstance() => _instance;

  FlutterLocalNotificationsPlugin notificationsPlugin;

  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iOSSettings;
  InitializationSettings initializationSettings;
  AndroidNotificationDetails androidNotificationDetails;
  IOSNotificationDetails iosNotificationDetails;
  NotificationDetails notificationDetails;

  // I don't know what is its useCase
  Future<void> _onDidReceiveLocalNotification(int x, String y, String z, String zz) async{
    // related to iOS

  }

  // called whenever the notification is tapped on
  Future _onSelectNotification(String payload) async {
    var stateProvider = locator.get<NotificationStateProvider>();
    stateProvider.setAsOpenedByID(json.decode(payload)['id']);
  }

  Future<void> initialize() async {
    notificationsPlugin = new FlutterLocalNotificationsPlugin();
    androidInitializationSettings = new AndroidInitializationSettings('app_icon');
    iOSSettings = new IOSInitializationSettings(onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(androidInitializationSettings, iOSSettings);
    androidNotificationDetails = new AndroidNotificationDetails(
      "Channel_ID",
      "Channel title",
      "Channel body",
      priority: Priority.High,
      importance: Importance.Max,
      ticker: 'test',
    );
    iosNotificationDetails = new IOSNotificationDetails();

    notificationDetails = new NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await notificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  }

  // show notification
  Future<void> showNotification({int channelID, String title, String body,String payload}) async {
    await notificationsPlugin.show(channelID, title, body, notificationDetails,payload:payload );
  }
}
