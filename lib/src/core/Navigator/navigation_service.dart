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
  factory NavigationService.getInstance() {
    if (_instance == null) {
      _instance = new NavigationService._();
    }
    return _instance;
  }

  static final GlobalKey<NavigatorState> _homePageNavigatorKey = new GlobalKey<NavigatorState>(debugLabel: '_homePageNavigatorKey');

  static final GlobalKey<NavigatorState> _materialNavigatorKey = new GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> _notificationsNavigatorKey =
      new GlobalKey<NavigatorState>(debugLabel: '_notificationsNavigatorKey');

  static final GlobalKey<NavigatorState> _messagesNavigatorKey = new GlobalKey<NavigatorState>(debugLabel: '_messagesNavigatorKey');
  static final GlobalKey<NavigatorState> _profilePageNavigatorKey = new GlobalKey<NavigatorState>(debugLabel: '_profilePageNavigatorKey');
  static final GlobalKey<NavigatorState> _mySaveMaterialNavigatorKey =
      new GlobalKey<NavigatorState>(debugLabel: '_mySaveMaterialNavigatorKey');
  static final GlobalKey<NavigatorState> _myUploadedMaterialNavigatorKey =
  new GlobalKey<NavigatorState>(debugLabel: '_myUploadedMaterialNavigatorKey');
  static final GlobalKey<NavigatorState> _quizesNavigatorKey = new GlobalKey<NavigatorState>(debugLabel: 'quizesNavigaorKey');
  static List<GlobalKey<NavigatorState>> get navigationKeys => [
        _homePageNavigatorKey,
        _materialNavigatorKey,
        _messagesNavigatorKey,
        _notificationsNavigatorKey,
        _profilePageNavigatorKey,
        _mySaveMaterialNavigatorKey,
      ];

  GlobalKey<NavigatorState> get currentNavigator => navigationKeys[this.currentIndex];

  static GlobalKey<NavigatorState> get homePageNavigatorKey => _homePageNavigatorKey;

  static GlobalKey<NavigatorState> get materialNavigatorKey => _materialNavigatorKey;

  static GlobalKey<NavigatorState> get notificationsNavigatorKey => _notificationsNavigatorKey;

  static GlobalKey<NavigatorState> get profilePageNavigatorKey => _profilePageNavigatorKey;

  static GlobalKey<NavigatorState> get messagesNavigatorKey => _messagesNavigatorKey;

  static GlobalKey<NavigatorState> get mySavedMaterialNavigatorKey => _mySaveMaterialNavigatorKey;

  static GlobalKey<NavigatorState> get myUploadedMaterialNavigatorKey => _myUploadedMaterialNavigatorKey;

  static GlobalKey<NavigatorState> get quizesNavigatorKey => _quizesNavigatorKey;

  static NavigatorState get homePageNavigator => _homePageNavigatorKey.currentState;

  static NavigatorState get materialNavigator => _materialNavigatorKey.currentState;

  static NavigatorState get notificationsNavigator => _notificationsNavigatorKey.currentState;

  static NavigatorState get messagesNavigator => _messagesNavigatorKey.currentState;

  static NavigatorState get profilePageNavigator => _profilePageNavigatorKey.currentState;


    bool get  canWePopFromMySaved => this.currentIndex == 1 &&
      _mySaveMaterialNavigatorKey.currentState != null &&
        _mySaveMaterialNavigatorKey.currentState.canPop();

    bool get canWePopFromMyUploads => this.currentIndex == 1 &&
        _myUploadedMaterialNavigatorKey.currentState != null &&
        _myUploadedMaterialNavigatorKey.currentState.canPop();

    bool get canWePopFromQuizesNavigator => this.currentIndex == 1 &&
        _quizesNavigatorKey.currentState != null &&
        _quizesNavigatorKey.currentState.canPop();

    void popFromMySaved() => _mySaveMaterialNavigatorKey.currentState.pop();
    void popFromMyUploads () => _myUploadedMaterialNavigatorKey.currentState.pop();
    void popFromQuizesNavigator() => _quizesNavigatorKey.currentState.pop();



}
