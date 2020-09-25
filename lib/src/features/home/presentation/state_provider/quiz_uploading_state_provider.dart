import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';

import '../../../../core/api/contract_response.dart';
import '../../../../core/platform/services/caching_services.dart';
import '../../../../core/platform/services/network_info.dart';
import '../widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';

class StateProvider {
  int semester;
  void updateSemester(int update){

  }
}

class QuizUploadingState extends StateProvider with ChangeNotifier {
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

  QuizUploadingState() {
    print('a new instance of quiz uploader state provider has been created');
    // initialize the currentPageIndex of the pageView which will diplay the list of quizes
    _currentPageIndex = 0;

    // just in case the account_type is academic student and he is in dentistery college
    // so we must load the data cause they are static and could not be changed
    locator<DialogService>().quizUploadingState = this;
    String account_type = locator<DialogService>().profilePageState.userData.commonFields.account_type;
    String college;
    int stage;
    if (account_type == 'unistudents') {
      college = locator<DialogService>().profilePageState.userData.college;
      stage = int.parse(locator<DialogService>().profilePageState.userData.stage);

      if (new RegExp(r'سنان').hasMatch(college)) {
        _topicList = References.getSuitaleCollegeMaterialList(stage, college);
      }
    }
  }

  // update topicList upon changing the semester (in case of medicine or pharmacy) and / or
  // changing the stage for all types of user (except students of school of course casue they are not
  // authorized to publish quizez be default

  void updateTopicList() {
    ProfilePageState profilePageState = locator<DialogService>().profilePageState;
    String account_type = profilePageState.userData.commonFields.account_type;

    if (account_type == 'schteachers') {
      return;
    }

    String college = profilePageState.userData.college;

    int studentStage;
    if (account_type == 'unistudents') {
      studentStage = int.parse(profilePageState.userData.stage);
    }

    _topicList = References.getSuitaleCollegeMaterialList(studentStage ?? stage, college, semester: this.semester);
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
    String account_type = locator<DialogService>().profilePageState.userData.commonFields.account_type;
    ProfilePageState profilePageState = locator<DialogService>().profilePageState;
    String college;
    if (account_type == 'uniteachers') {
      college = profilePageState.userData.college;
    }
    if (update != null) {
      _stage = update;
      _topic = null;
      if (new RegExp(r'سنان').hasMatch(college) || (isPharmacyOrMedicine(profilePageState)) && _semester != null) {
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
      bool updateTopicListForUniteachers = account_type == 'uniteachers' && (isPharmacyOrMedicine(profilePageState) || new RegExp(r'سنان').hasMatch(college)) && _stage != null;
      bool updateTopicListForStudents = account_type == 'unistudents' && ((isPharmacyOrMedicine(profilePageState) && _semester != null) || new RegExp(r'سنان').hasMatch(college));
      if (updateTopicListForUniteachers || updateTopicListForStudents) {
        updateTopicList();
      }

      notifyListeners();
    }
  }

  // get the credentials
  Map<String, dynamic> getCredentials() {
    String account_type = locator<DialogService>().profilePageState.userData.commonFields.account_type;
    ProfilePageState profilePageState = locator<DialogService>().profilePageState;
    Map<String, dynamic> credentials = {'title': this._title, 'description': this._description, 'topic': this._topic};

    if (account_type == 'uniteachers' || account_type == 'schteachers') {
      credentials['stage'] = this._stage;
    }
    if (account_type == 'unistudents') {
      credentials['stage'] = profilePageState.userData.stage;
    }
    if (isPharmacyOrMedicine(profilePageState)) {
      credentials['semester'] = this._semester;
    }
    if (account_type == 'schteachers') {
      credentials['topic'] = profilePageState.userData.speciality;
    }

    return credentials;
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

  // import data from draft
  void importFromDrafts(Map<String, dynamic> data) {
    var credentials = data['credentials'];
    var quizItems = data['quizItems'];
      print('Hello World');
    _title = credentials['title'];
    _description = credentials['description'];

    _stage = int.parse(credentials['stage']);
    _semester = credentials['semester'];
    _draftStoreIndex = data['index'];
    updateTopicList();
    updateTopic(credentials['topic']);
    _quizList = quizItems as List<QuizEntity>;
    for (int i = 0; i < _quizList.length; i++) {
      updateQuizViewMode(i);
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
  Future<ContractResponse> upload() async {
    final bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }
    String accountType = locator<DialogService>().profilePageState.userData.commonFields.account_type;
    Map<String, dynamic> _body = {};
    _body.addAll(getCredentials());

    if (accountType == 'uniteachers' || accountType == 'unistudents') {
      _body['college'] = locator<DialogService>().profilePageState.userData.college;
    } else {
      // Hello World
    }
    _body['quizItems'] = _quizList.map((quiz) => quiz.toJSON()).toList();
    final String _url = Api.getSuitableUrl(accountType: accountType) + '/upload-new-quiz';
    Map<String, String> _headers = {'authorization': await CachingServices.getField(key: 'token'), 'content-type': 'application/json', 'Accept': 'application/json'};

    http.Response response;
    try {
      response = await http.post(Uri.encodeFull(_url), body: _body, headers: _headers).timeout(Duration(seconds: 20));

      switch (response.statusCode) {
        case 201:
          return Success201(message: 'Your quiz uploaded successfully');
          break;

        case 500:
          return InternalServerError();
          break;

        case 403:
          return ForbiddenAccess(message: 'You are not authorized user');
          break;

        default:
          return NewBugException(message: 'Unhandled statusCode ${response.statusCode}');
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      return NewBugException(message: err.toString());
    }
  }

  @override
  void dispose() {
    print('quiz uploader satate provider has been disposed successfully');
    super.dispose();
  }
}
