import 'dart:convert';

import 'package:malzama/src/core/general_models/notification.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../dialog_services/service_locator.dart';
import 'local_notification.dart';
import 'local_notification.dart';

class NotificationService {
  // private constructor
  NotificationService._();

  static int _channelID = -1;
  bool isInitialized = false;
  // singleton instance
  static NotificationService _instance = NotificationService._();

  factory NotificationService.getInstance() => _instance;

  Future<void> initialize() async {
    if(isInitialized){
      return;
    }
    LocalNotificationService localNotificationService = LocalNotificationService.getInstance();
    await localNotificationService.initialize();

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(
      "50c8ad6e-b20b-4f8e-a71a-219c4f4ce74e",
      iOSSettings: {OSiOSSettings.autoPrompt: false, OSiOSSettings.inAppLaunchUrl: false},
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.none);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared.setNotificationReceivedHandler(
      (OSNotification notification) {
        NotificationStateProvider notificationStateProvider = locator.get<NotificationStateProvider>();
        Notification receivedNotification = new Notification(
          title: notification.payload.title,
          body: notification.payload.body,
          id: notification.payload.notificationId,
          sentAt: DateTime.fromMillisecondsSinceEpoch(notification.payload.rawPayload['google.sent_time'])
        );
        notificationStateProvider.addToNotificationsList(receivedNotification);

        print('We recieved a new notificaitonn');
        print(DateTime.fromMillisecondsSinceEpoch(notification.payload.rawPayload['google.sent_time']));

        print('there is might be a problem');
        print('additional data');
        print(notification.payload.additionalData);

        print('attachment');
        print(notification.payload.attachments);

        print('badge');
        print(notification.payload.badge);

        print('badge increment');
        print(notification.payload.badgeIncrement);

        print('category');
        print(notification.payload.category);

        print('json representation');
        print(notification.payload.jsonRepresentation());

        print('from project number');
        print(notification.payload.fromProjectNumber);

        print('groupKey');
        print(notification.payload.groupKey);

        print('collapesd Id');
        print(notification.payload.collapseId);

        print('group Message');
        print(notification.payload.groupMessage);

        print('laucnUrl');
        print(notification.payload.launchUrl);

        print('notifcationId');
        print(notification.payload.notificationId);

        print('raw Payload');
        print(notification.payload.rawPayload);

        print('subtitle');
        print(notification.payload.subtitle);

        print('templaate Id');
        print(notification.payload.templateId);

        print('priority');
        print(notification.payload.priority);

        print('mutable content');
        print(notification.payload.mutableContent);
        print('before encoding');
        String payload;
        try{
           payload = json.encode(receivedNotification.asHashMap());
        }catch(err){
          print(err.toString());
        }
        print('after  encoding');

        print('before show notification');
        // do whatever the hell you wanna do in your life mother fucker
        localNotificationService.showNotification(
          channelID: ++_channelID,
          title: notification.payload.title,
          body: notification.payload.body,
          payload: payload
        );
        print('after show notification');
      },
    );
    isInitialized = true;
  }
}
