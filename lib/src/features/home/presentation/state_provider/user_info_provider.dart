import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/general_variables.dart';
import '../../../../core/platform/services/file_system_services.dart';

class UserInfoStateProvider with ChangeNotifier {
  // ====================================
  // this is for quiz collections count availabe for current user
  int _quizCollectionsCount;
  int get quizCollectionsCount => _quizCollectionsCount;
  void setQuizCollectionsCountTo(int update){
    _quizCollectionsCount = update ?? 0;
    notifyListeners();
  }

  Future<void> fetchQuizesCount()async{
    var response = await HttpMethods.get(url: Api.FETCH_QUIZES_COUNT);
    if(response.statusCode == 200){
      _quizCollectionsCount = json.decode(response.message)['count'];
    }else{
      print('***********************************');
      print(response.message);
      print('***********************************');

      _quizCollectionsCount = 0;
    }
    notifyListeners();
  }

  // ====================================


  bool showQuizWelcomeMessage = true;
  UserInfoStateProvider(Map<String,dynamic>data) {
    userData = data;
    account_type = userData['account_type'];
    fetchQuizesCount();
    GeneralVariablesService.getQuizWelcomeMessagePermission.then((value) {
      print('after setting up');
      print(value);
      print('after setting up');
      showQuizWelcomeMessage = value ?? true;
    });
    notifyListeners();
  }

  PersistentBottomSheetController bottomSheetController;

  // Visibility of the bottom navigation bar of the root navigator
  bool _isBottomNavBarVisible = true;

  bool get isBottomNavBarVisible => _isBottomNavBarVisible;


  // ========================================================================================



//  // check whether the comment sheet is visible or not
//  bool _isCommentSheetVisible = false;
//  bool get isCommentSheetVisible => _isCommentSheetVisible;
//
//  void setIsCommentSheetVisibilityTo(bool update){
//    if(update != null ){
//      _isCommentSheetVisible = update;
//      notifyListeners();
//    }
//  }




  // ========================================================================================

  void setBottomNavBarVisibilityTo(bool update) {
    if (_isBottomNavBarVisible != update) {
      _isBottomNavBarVisible = update;
      notifyListeners();
    }
  }

  // visibility of the comment floating text field to add a comment
  bool _isCommentTextFieldVisible = false;

  bool get isCommentTextFieldVisible => _isCommentTextFieldVisible;

  void setCommentTextFieldVisibilityTo(bool update) {
    if (_isCommentTextFieldVisible != update) {
      _isCommentTextFieldVisible = update;
      notifyListeners();
    }
  }

  Map<String, dynamic> userData;
  String account_type;

  void _loadUserData() async {
    var data = await FileSystemServices.getUserData();
    if (data != null && data != false) {

    }
  }
}
