import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/general_variables.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_draft_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/functions/comments_functions.dart';

import '../../../../core/api/contract_response.dart';
import '../../../../core/platform/services/caching_services.dart';
import '../../../../core/platform/services/network_info.dart';
import '../widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';

class StateProvider {
  int semester;

  void updateSemester(int update) {}
}

class QuizUploadingState extends StateProvider with ChangeNotifier {
  bool _isCheckBoxChecked = false;

  bool get isCheckBoxChecked => _isCheckBoxChecked;

  void setIsCheckBoxChecked(bool update) {
    if (update != null) {
      _isCheckBoxChecked = update;
      notifyListeners();
    }
  }

  // =========================================================================
  // this is for schools
  String _schoolSection;

  String get schoolSection => _schoolSection;

  void updateSchoolSection(String update) {
    if (update != null) {
      _schoolSection = update;
      notifyListeners();
    }
  }

  // =========================================================================

  // =================================================================
  // SnackBar status (to tell if the SnackBar is already open or not)

  bool _isSnackBarActive = false;

  bool get isSnackBarActive => _isSnackBarActive;

  void setIsSnackBarActiveTo(bool update) {
    if (update != null) {
      _isSnackBarActive = update;
    }
  }

  // ====================================================================
  // ==========================================
  // this for making time to fetch whether we show the quiz welcome message or not
  // from the local database
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool showQuizWelcomeMessage = true;

  void setIsLoadingTo(bool update) {
    if (update != null) {
      _isLoading = update;
      notifyListeners();
    }
  }

  // ==========================================

  void _fabAppearanceListener() {
    if (scrollController.offset > scrollController.position.maxScrollExtent * 0.9) {
      locator<DialogService>().quizUploadingState.setFabVisibilityTo(true);
    } else {
      locator<DialogService>().quizUploadingState.setFabVisibilityTo(false);
    }
  }

  void initializeFabListener() {
    scrollController.addListener(_fabAppearanceListener);
  }

  ScrollController _scrollController;
  PageController _pageController;
  GlobalKey<ScaffoldState> _scaffoldKey;

  //int _draftStoreIndex;

  ScrollController get scrollController => _scrollController;

  PageController get pageController => _pageController;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool _fromDrafts = false;

  bool get fromDrafts => _fromDrafts;

  String _title, _description, _topic;
  int _semester, _stage, _currentPageIndex, _draftStoreIndex;
  bool _isFabVisible = false, _hasDrafts = false;

  bool get isFabVisible => _isFabVisible;

  String get title => _title;

  String get description => _description;

  String get topic => _topic;

  int get semester => _semester;

  int get stage => _stage;

  int get currentPageIndex => _currentPageIndex;

  int get draftStoreIndex => _draftStoreIndex;

  List<String> _topicList;

  List<String> get topicList => _topicList;

  bool get hasDrafts => _hasDrafts;

  void updateHasDrafts(bool update) {
    if (update != null) {
      _hasDrafts = update;
      notifyListeners();
    }
  }

  // Animate to Page
  Future<void> animateToPage(int page) async {
    if (page != null) {
      await pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Animate to Bottom
  Future<void> animateToBottom() async {
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // handler called when the list of quizes to be uploaded is less than 10
  Future<void> onQuizBelowLimitHandler() async {
    if (quizList.any((quiz) => quiz.isEmpty)) {
      var targetPos = quizList.indexWhere((quiz) => quiz.isEmpty);
      print('this is the targetPos $targetPos');
      await pageController.animateToPage(targetPos, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      print('inside the appending');
      appendToQuizList(new QuizEntity());
      var targetPos = quizList.indexOf(quizList.last);
      pageController.animateToPage(targetPos, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  // handler called when there is at least one quiz item that has no answers
  Future<void> onQuizHasNoAnswersHandler() async {
    await animateToBottom();
    int targetPos = quizList.indexOf(quizList.firstWhere((quiz) => !quiz.hasAnswers));
    await animateToPage(targetPos);
  }

  /// this handler called when user hit the FloatingActionButton Of adding a new quiz item
  void onAddNewQuizItemHandler() async {
    if (quizList.length == 0 || scrollController.offset < scrollController.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((timer) => animateToBottom());
    }

    // make sure that the last quiz is complete with all it's fields
    // cause the add button does not add a new quiz item unless the last one is complete
    QuizEntity lastOne;
    if (quizList.length != 0) {
      lastOne = quizList.last;
    }
    if (lastOne != null && lastOne.isEmpty) {
      animateToPage(quizList.length - 1);
      showSnackBar(text: 'Please save the current quiz item then add another one');
    } else {
      appendToQuizList(new QuizEntity());

      if (_currentPageIndex != _quizList.length - 2) {
        print('hard way');
        pageController.jumpToPage(_quizList.length - 2);
        await Future.delayed(Duration(milliseconds: 30));
        await animateToPage(_quizList.length - 1);
      } else {
        print('easy way');
        await Future.delayed(Duration(milliseconds: 30));
        animateToPage(_quizList.length - 1);
      }
    }
  }

  QuizUploadingState(bool fromDrafts) {
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    _pageController = new PageController(viewportFraction: 0.955);
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _fromDrafts = fromDrafts;

    if (_fromDrafts) {
      scrollController.addListener(_fabAppearanceListener);
    }

    print('a new instance of quiz uploader state provider has been created');
    // initialize the currentPageIndex of the pageView which will diplay the list of quizes
    _currentPageIndex = 0;

    // just in case the account_type is academic student and he is in dentistery college
    // so we must load the data cause they are static and could not be changed
    locator<DialogService>().quizUploadingState = this;
    String account_type = locator<DialogService>().profilePageState.userData.commonFields.account_type;
    String college;
    if (account_type == 'unistudents') {
      college = locator<DialogService>().profilePageState.userData.college;
      _stage = int.parse(locator<DialogService>().profilePageState.userData.stage);

      if (new RegExp(r'سنان').hasMatch(college)) {
        _topicList = References.getSuitaleCollegeMaterialList(stage, college);
      }
    }
  }

  // update topicList upon changing the semester (in case of medicine or pharmacy) and / or
  // changing the stage for all types of user (except students of school of course casue they are not
  // authorized to publish quizes by default

  void updateTopicList() {
    ProfilePageState profilePageState = locator<DialogService>().profilePageState;
    String account_type = profilePageState.userData.commonFields.account_type;

    if (account_type == 'schteachers') {
      return;
    }

    String college = profilePageState.userData.college;

    _topicList = References.getSuitaleCollegeMaterialList(stage, college, semester: this.semester);
    notifyListeners();
  }

// update quiz title
  void updateTitle(String update) {
    if (update != _title) {
      _title = update;
      notifyListeners();
    }
  }

// update quiz description
  void updateDescription(String update) {
    if (update != _description) {
      _description = update;
      notifyListeners();
    }
  }

// update quiz topic
  void updateTopic(String update) {
    if (update != _topic) {
      _topic = update;
      notifyListeners();
    }
  }

// update topic list
  void updateStage(int update) {
    ProfilePageState profilePageState = locator<DialogService>().profilePageState;
    String account_type = profilePageState.userData.commonFields.account_type;

    String college;
    if (account_type == 'uniteachers') {
      college = profilePageState.userData.college;
    }
    if (update != null) {
      _stage = update;
      _topic = null;
      if (new RegExp(r'سنان').hasMatch(college) || (HelperFucntions.isPharmacyOrMedicine(profilePageState)) && _semester != null) {
        print('our conidtion was met');
        updateTopicList();
      } else {
        print('our condition was not met');
      }
      notifyListeners();
    }
  }

// update semester (first or second course)
// for pharmacy and medicne maybe
  void updateSemester(int update) {
    String account_type = locator<DialogService>().profilePageState.userData.commonFields.account_type;
    ProfilePageState profilePageState = locator<DialogService>().profilePageState;
    String college = profilePageState.userData.college;
    if (update != null) {
      _semester = update;
      _topic = null;

      bool updateTopicListForUniteachers = account_type == 'uniteachers' &&
          (HelperFucntions.isPharmacyOrMedicine(profilePageState) || new RegExp(r'سنان').hasMatch(college)) &&
          _stage != null;
      bool updateTopicListForStudents = account_type == 'unistudents' &&
          ((HelperFucntions.isPharmacyOrMedicine(profilePageState) && _semester != null) || new RegExp(r'سنان').hasMatch(college));
      if (updateTopicListForUniteachers || updateTopicListForStudents) {
        updateTopicList();
      }


      notifyListeners();
    }
  }


  // showSnackBar
  Future<void> showSnackBar({
    @required String text,
    int duration,
  }) async {
    if (!_isSnackBarActive) {
      _isSnackBarActive = true;
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(
            content: Text(text),
            duration: Duration(milliseconds: duration ?? 4000),
          ))
          .closed
          .then((_) => _isSnackBarActive = false);
    }
  }

  // get the credentials
  QuizCredentials getCredentials() {
    ProfilePageState profilePageState = locator<DialogService>().profilePageState;
    String account_type = profilePageState.userData.commonFields.account_type;

    QuizCredentials quizCredentials = new QuizCredentials()
      ..title = _title
      ..topic = _topic
      ..description = _description
      ..semester = _semester.toString() ?? 'unknown'
      ..stage = account_type == 'unistudents' ? profilePageState.userData.stage.toString() : _stage.toString();
    if (account_type != 'schteachers') {
      quizCredentials
        ..college = profilePageState.userData.college
        ..university = profilePageState.userData.university
        ..section = profilePageState.userData.section;
    } else {
      quizCredentials
        ..schoolSection = _schoolSection
        ..topic = profilePageState.userData.speciality;
    }

    return quizCredentials;
  }

  // update the status of Floating action button visibility (which is used to add a new quiz item)

  void setFabVisibilityTo(bool update) {
    if (update != null) {
      _isFabVisible = update;
      notifyListeners();
    }
  }

// quiz list
// general
  List<QuizEntity> _quizList = [];

  List<QuizEntity> get quizList => _quizList;

  void updateQuizList(List<QuizEntity> update) {
    if (update != null) {
      _quizList = update;
      notifyListeners();
    }
  }

  void removeQuizItemAt(int pos) {
    if (pos != null) {
      if (pos == _quizList.length - 1) {
        pageController.animateToPage(
          _quizList.length - 2,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _currentPageIndex = _quizList.length - 2;
      }
      _quizList.removeAt(pos);
      if (_quizList.length == 0) {
        scrollController.removeListener(_fabAppearanceListener);
        _isFabVisible = false;
      }
      notifyListeners();
    }
  }

  // import data from draft
  void importFromDrafts(QuizDraftEntity data) {
    print(data);
    var credentials = data.credentials;

    _quizList = data.quizItems;
    print('Hello World');
    _title = credentials.title;
    _description = credentials.description;

    _stage = int.parse(credentials.stage.toString());
    _semester = int.parse(credentials.semester);
    _draftStoreIndex = data.storeIndex;
    updateTopicList();
    updateTopic(credentials.topic);

    for (int i = 0; i < _quizList.length; i++) {
      _quizList[i].inReviewMode = true;
    }
    notifyListeners();
  }

  void appendToQuizList(QuizEntity quiz) {
    if (quiz != null) {
      quiz.answers = [];
      quiz.options = [];
      _quizList.add(quiz);
      notifyListeners();
    }
  }

  void saveCurrentQuizEntity(int pos, QuizEntity quiz) {
    _quizList[pos] = quiz;
    notifyListeners();
  }

  // switch the quiz view mode so the animation switcher can animate between the 2 pages
  // the on review mode page and the on edit mode page
  void updateQuizViewMode(int pos) {
    if (pos != null) {
      _quizList[pos].inReviewMode = !_quizList[pos].inReviewMode;
      notifyListeners();
    }
  }

  void updateCurrentPageIndex(update) {
    if (update != null) {
      _currentPageIndex = update;
      notifyListeners();
    }
  }

  void setState() => notifyListeners();

// reset all fields to null
  void reset() {
    _title = null;
    _description = null;
    _topic = null;
    _stage = null;
    _semester = null;
    _quizList = null;
    notifyListeners();
  }

// upload new quiz
  Future<void> upload(BuildContext context) async {
    QuizCredentials credentials = getCredentials();
    var payload = Map<String, dynamic>();
    payload['questions'] = _quizList.map((e) => e.toJSON()).toList();
    payload.addAll(credentials.toJSON());

    print('================================================');
    payload['upload_type'] = 'quizes';
    print('================================================');
    print(payload);

    locator<DialogService>().showDialogOfUploading();
    ContractResponse contractResponse = await HttpMethods.post(body: payload, url: Api.UPLOAD_NEW_MATERIAL);
    locator<DialogService>().completeAndCloseDialog(null);
    if (contractResponse is Success) {
      var responseBody = json.decode(contractResponse.message);
      for (int i = 0; i < responseBody['data']['list_of_IDs'].length; i++) {
        _quizList[i].id = responseBody['data']['list_of_IDs'][i].toString();
      }
      QuizDraftEntity quizDraftEntity = new QuizDraftEntity(
        storeIndex: null,
        quizItems: _quizList,
        credentials: credentials,
        id: responseBody['_id'],
      );
      await QuizAccessObject().saveUploadedQuiz(quizDraftEntity.toJSON());
      if (_fromDrafts) {
        await QuizAccessObject().removeDrftAt(index: _draftStoreIndex);
        locator<DialogService>().profilePageState.updateQuizDraftsCount();
      }
      Navigator.of(context).pop();
      locator<DialogService>().showDialogOfSuccess(message: 'quiz uploaded Successfully');
    } else {
      print(contractResponse.message);
      locator<DialogService>().showDialogOfFailure(message: 'Failed to upload quiz, try again');
    }
  }

  @override
  void dispose() {
    print('quiz uploader satate provider has been disposed successfully');
    locator<DialogService>().quizUploadingState = null;
    scrollController.removeListener(_fabAppearanceListener);
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }
}
