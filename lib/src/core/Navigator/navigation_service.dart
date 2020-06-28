import 'package:flutter/cupertino.dart';

class NavigationService {

  // private constructor
  NavigationService._(){
    this._homePageNavigatorKey = new GlobalKey<NavigatorState>() ;
    this._messagesNavigatorKey = new GlobalKey<NavigatorState>() ;
    this._notificationsNavigatorKey = new GlobalKey<NavigatorState>() ;
    this._profilePageNavigatorKey  = new GlobalKey<NavigatorState> ();
  }

  // singleton object
  static NavigationService _instance;

  // return a signleton
  factory NavigationService.getInstance(){
    if(_instance == null){
      _instance = new NavigationService._();
    }
    return _instance;
  }

  GlobalKey<NavigatorState> _homePageNavigatorKey ;
  GlobalKey<NavigatorState> _messagesNavigatorKey ;
  GlobalKey<NavigatorState> _notificationsNavigatorKey ;
  GlobalKey<NavigatorState> _profilePageNavigatorKey ;

  List<GlobalKey<NavigatorState>> get navigationKeys => [
    _homePageNavigatorKey,
    _messagesNavigatorKey,
    _notificationsNavigatorKey,
    _profilePageNavigatorKey
  ];

  GlobalKey<NavigatorState> get homePageNavigatorKey => _homePageNavigatorKey;
  GlobalKey<NavigatorState> get messagesNavigatorKey => _messagesNavigatorKey;
  GlobalKey<NavigatorState> get notificationsNavigatorKey => _notificationsNavigatorKey;
  GlobalKey<NavigatorState> get profilePageNavigatorKey => _profilePageNavigatorKey;

  NavigatorState get homePageNavigator => _homePageNavigatorKey.currentState;
  NavigatorState get messagesNavigator => _messagesNavigatorKey.currentState;
  NavigatorState get notificationsNavigator => _notificationsNavigatorKey.currentState;
  NavigatorState get profilePageNavigator => _profilePageNavigatorKey.currentState;

}