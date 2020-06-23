import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/general_models/notification.dart';

class NotificationStateProvider with ChangeNotifier{

  // Constructor
  NotificationStateProvider(){
    this._notificationsList = [];
  }
  // list of all notifications
  List<Notification> _notificationsList;

  // count of the notifications that have now viewed yet
  int _notOpenedNotificationsCount = 0;


  // get the list of all notifications
  List<Notification> get notificationsList => _notificationsList;

  // get the count of the notifications that have now viewed yet
  int get notOpenedNotificationsCount => _notOpenedNotificationsCount;


  // append new notification to the list
  // called whenever a new notification is received
  void addToNotificationsList(Notification notification){
    if(notification != null){
      _notificationsList.add(notification);
      _notOpenedNotificationsCount += 1;
      notifyListeners();
    }
  }

  // set the opened notification as opened by index
  // so the UI will update accordingly
  // the color of the notification that is opened differs from that which is not
  void setAsOpenedByIndex(int index){
    _notificationsList.elementAt(index).isOpened = true;
    _notOpenedNotificationsCount =  _notificationsList.where((element) => !element.isOpened).length;
    notifyListeners();
  }



  // set the opened notification as opened by id
  // so the UI will update accordingly
  // the color of the notification that is opened differs from that which is not
  void setAsOpenedByID(String id){
    _notificationsList.firstWhere((notification) => notification.id.compareTo(id) == 0).isOpened = true;
    _notOpenedNotificationsCount -= 1 ;
    notifyListeners();
  }
}