import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {

   int currentIndex;
   TabController controller;

  // private constructor
  NavigationService._();

  // singleton object
  static NavigationService _instance;

  // return a signleton
  factory NavigationService.getInstance(){
    if(_instance == null){
      _instance = new NavigationService._();
    }
    return _instance;
  }

  static final GlobalKey<NavigatorState> _homePageNavigatorKey = new GlobalKey<NavigatorState>(debugLabel: '_homePageNavigatorKey') ;
  static final GlobalKey<NavigatorState> _materialNavigatorKey  = new GlobalKey<NavigatorState>() ;
  static final GlobalKey<NavigatorState> _notificationsNavigatorKey  = new GlobalKey<NavigatorState>(debugLabel:'_notificationsNavigatorKey' ) ;
  static final GlobalKey<NavigatorState> _messagesNavigatorKey  = new GlobalKey<NavigatorState>(debugLabel: '_messagesNavigatorKey');
  static final GlobalKey<NavigatorState> _profilePageNavigatorKey  = new GlobalKey<NavigatorState> (debugLabel: '_profilePageNavigatorKey');

  static List<GlobalKey<NavigatorState>> get navigationKeys => [
    _homePageNavigatorKey,
    _materialNavigatorKey,
    _messagesNavigatorKey,
    _notificationsNavigatorKey,
    _profilePageNavigatorKey
  ];

  static GlobalKey<NavigatorState> get homePageNavigatorKey => _homePageNavigatorKey;
  static GlobalKey<NavigatorState> get materialNavigatorKey => _materialNavigatorKey;
  static GlobalKey<NavigatorState> get notificationsNavigatorKey => _notificationsNavigatorKey;
  static GlobalKey<NavigatorState> get profilePageNavigatorKey => _profilePageNavigatorKey;
  static GlobalKey<NavigatorState> get messagesNavigatorKey => _messagesNavigatorKey;

  static NavigatorState get homePageNavigator => _homePageNavigatorKey.currentState;
  static NavigatorState get materialNavigator => _materialNavigatorKey.currentState;
  static NavigatorState get notificationsNavigator => _notificationsNavigatorKey.currentState;
  static NavigatorState get messagesNavigator => _messagesNavigatorKey.currentState;
  static NavigatorState get profilePageNavigator => _profilePageNavigatorKey.currentState;

}

