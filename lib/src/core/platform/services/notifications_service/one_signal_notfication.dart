import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/general_models/notification.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../dialog_services/service_locator.dart';
import 'local_notification_service.dart';

class NotificationService {
  // private constructor
  NotificationService._();

  static int _channelID = -1;
  bool _isInitialized = false;

  // singleton instance
  static NotificationService _instance;

  factory NotificationService.getInstance() {
    if (_instance == null) {
      _instance = NotificationService._();
    }
    return _instance;
  }

  Future<void> initialize() async {
    if (_isInitialized) {
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

    // this will spawn an Isolate so in order not to block the main isolate
    // but not now
    _handleOneSignalRegistration('');

    OneSignal.shared.setNotificationReceivedHandler(
      (OSNotification notification) {
        print('*******************************************************************');
        print('new notification');
        print('addintional Data');
        print(notification.payload.additionalData);

        print('title  Data');
        print(notification.payload.title);

        print('subtitle  Data');
        print(notification.payload.subtitle);
        print('*******************************************************************');

//        print(++_channelID);
//        NotificationStateProvider notificationStateProvider = locator.get<NotificationStateProvider>();
//        var receivedNotification;
//        try {
//          receivedNotification = new NotificationInstance(
//            title: notification.payload.title,
//            body: notification.payload.body,
//            id: notification.payload.notificationId,
//            sentAt: DateTime.fromMillisecondsSinceEpoch(notification.payload.rawPayload['google.sent_time']),
//          );
//          notificationStateProvider.addToNotificationsList(receivedNotification);
//        } catch (err) {
//          throw err;
//        }
      },
    );
    _isInitialized = true;
  }
}

Future _handleOneSignalRegistration(String d) async {
  String userId;
  while (userId == null) {
    var data = await OneSignal.shared.getPermissionSubscriptionState();
    userId = data.subscriptionStatus.userId;
    if (userId != null) {
      print('*******************************************************************');
      print('we got it inside while loop => $userId');
      await CachingServices.saveStringField(key: 'one_signal_id', value: userId);
      print('************************************************************************');

      print('===================================== fetching tags');
      final Map<String, dynamic> myTags = await OneSignal.shared.getTags();
      print(myTags.isEmpty);
      print('===================================== End fetching tags');

      if (myTags == null || !(myTags is Map<String, dynamic>) || myTags.isEmpty) {
        final Map<String, dynamic> tags = await HelperFucntions.getUserTags();
        if (tags != null) {
          while (true) {
            var res = await OneSignal.shared.sendTags(tags);
            print('========================= tags send res');
            print(res);
            print('========================= tags send res');
            if (res != null && res is Map<String, dynamic> && res.isNotEmpty) {
              break;
            }
          }
        }
      }
    }
  }
}
