import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/general_models/notification.dart';

class NotificationStateProvider with ChangeNotifier{

  // Constructor
  NotificationStateProvider(){
    this._notificationsList = [];
  }
  // list of all notifications
  List<NotificationInstance> _notificationsList;

  // count of the notifications that have now viewed yet
  int _notOpenedNotificationsCount = 0;


  // get the list of all notifications
  List<NotificationInstance> get notificationsList => _notificationsList;

  // get the count of the notifications that have now viewed yet
  int get notOpenedNotificationsCount => _notOpenedNotificationsCount;

  // set not Notification hint count to zero
  void setNotificationCountToZero(){
    if(_notOpenedNotificationsCount != 0){
      _notOpenedNotificationsCount = 0;
      notifyListeners();
      print('not opened notifications is now Zero');
    }
  }
  // append new notification to the list
  // called whenever a new notification is received
  void addToNotificationsList(NotificationInstance notification){
    if(notification != null){

      _notificationsList.add(notification);
      _notOpenedNotificationsCount += 1;
      notifyListeners();
      print('added to notification list and notifyListeners was called');
    }
  }

  // set the opened notification as opened by index
  // so the UI will update accordingly
  // the color of the notification that is opened differs from that which is not
  void setAsOpenedByIndex(int index){
    _notificationsList.elementAt(index).isOpened = true;
    _notOpenedNotificationsCount =  _notificationsList.where((element) => !element.isOpened).length;
    notifyListeners();
    print('Notificaiton has beeen set as opened');
  }



  // set the opened notification as opened by id
  // so the UI will update accordingly
  // the color of the notification that is opened differs from that which is not
  void setAsOpenedByID(String id){
    _notificationsList.firstWhere((notification) => notification.id.compareTo(id) == 0).isOpened = true;
    _notOpenedNotificationsCount -= 1 ;
    notifyListeners();
    print('Notificaiton has beeen set as opened');
  }
}