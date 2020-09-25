import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/platform/services/file_system_services.dart';

class UserInfoStateProvider with ChangeNotifier {
  UserInfoStateProvider() {
    _loadUserData();
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
      userData = data;
      account_type = userData['account_type'];
      notifyListeners();
    }
  }
}
