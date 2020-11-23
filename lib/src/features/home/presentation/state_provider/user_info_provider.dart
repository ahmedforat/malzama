import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';

import '../../../../core/api/api_client/clients/quiz_client.dart';
import '../../../../core/platform/local_database/access_objects/general_variables.dart';
import '../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import '../../models/users/user.dart';


class UserInfoStateProvider with ChangeNotifier {
  // ====================================
  // this is for quiz collections count availabe for current user in the cloud
  int _quizCollectionsCount;

  int get quizCollectionsCount => _quizCollectionsCount;

  void setQuizCollectionsCountTo(int update) {
    _quizCollectionsCount = update ?? 0;
    notifyMyListeners();
  }

  // the count of uploaded quizes
  int _uploadedQuizsCount;

  int get uploadedQuizsCount => _uploadedQuizsCount;

  void setUploadedQuizsCountTo(int update) {
    _uploadedQuizsCount = update ?? 0;
    notifyMyListeners();
  }

  // the count of uploaded pdfs
  int _uploadedPDFsCount;

  int get uploadedPDFsCount => _uploadedPDFsCount;

  void setUploadedPDFsCountTo(int update) {
    _uploadedPDFsCount = update ?? 0;
    notifyMyListeners();
  }

  // the count of uploaded videos
  int _uploadedVideosCount;

  int get uploadedVideosCount => _uploadedVideosCount;

  void setUploadedVideosCountTo(int update) {
    _uploadedVideosCount = update ?? 0;
    notifyMyListeners();
  }

// count of quizes drafts
  int _quizDraftsCount = 0;

  int get quizDraftsCount => _quizDraftsCount;

  void updateQuizDraftsCount() async {
    var results = await QuizAccessObject().fetchAllDrafts();
    _quizDraftsCount = results.length;
    notifyMyListeners();
  }

  Future<void> fetchQuizesCount() async {
    print('Fetching quiz count started');
    var response = await QuizClient().fetchQuizesCount();
    if (response.statusCode == 200) {
      _quizCollectionsCount = json.decode(response.message)['data'];
    } else {
      print('***********************************');
      print(response.message);
      print('***********************************');

      _quizCollectionsCount = 0;
      print('fetching inital quiz count done successfully');
    }
    notifyMyListeners();
    print('Fetching quiz count Ended');
  }

  // fetch uploaded materials count from local database
  Future<void> fetchUploadedMaterialsCount() async {
    print('Fetching my uploaded materials count Started');
    
    var res = await QuizAccessObject().getUploadedMaterials(MyUploaded.LECTURES);
    _uploadedPDFsCount = res?.length ?? 0;
    res = await QuizAccessObject().getUploadedMaterials(MyUploaded.QUIZES);
    _uploadedQuizsCount = res?.length ?? 0;
    res = await QuizAccessObject().getUploadedMaterials(MyUploaded.VIDEOS);
    _uploadedVideosCount = res?.length ?? 0;
    notifyMyListeners();
    print('Fetching my uploaded materials count Ended');
  }

  // ====================================

  bool showQuizWelcomeMessage = true;

  UserInfoStateProvider(User data) {
    print('initailizing USER_INFO_STATE_PROVIDER');
    if (data != null) {
      userData = data;
      fetchQuizesCount();
      GeneralVariablesService.getQuizWelcomeMessagePermission.then((value) {
        print('after setting up');
        print(value);
        print('after setting up');
        showQuizWelcomeMessage = value ?? true;
      });
      fetchUploadedMaterialsCount();
    }
    print('DONE _____initailizing USER_INFO_STATE_PROVIDER');
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
//      notifyMyListeners()();
//    }
//  }

  // ========================================================================================

  void setBottomNavBarVisibilityTo(bool update) {
    if (_isBottomNavBarVisible != update) {
      _isBottomNavBarVisible = update;
      notifyMyListeners();
    }
  }

  // visibility of the comment floating text field to add a comment
  bool _isCommentTextFieldVisible = false;

  bool get isCommentTextFieldVisible => _isCommentTextFieldVisible;

  void setCommentTextFieldVisibilityTo(bool update) {
    if (_isCommentTextFieldVisible != update) {
      _isCommentTextFieldVisible = update;
      notifyMyListeners();
    }
  }

  User userData;
  bool get isAcademic => HelperFucntions.isAcademic(this.userData.accountType);
  bool get isTeacher => HelperFucntions.isTeacher(this.userData.accountType);
  // void _loadUserData() async {
  //   var data = await FileSystemServices.getUserData();
  //   if (data != null && data != false) {}
  // }

  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
