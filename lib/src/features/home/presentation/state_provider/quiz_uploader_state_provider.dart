import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/api/api_client/clients/common_materials_client.dart';
import 'package:malzama/src/core/api/api_client/clients/quiz_client.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_list_displayer/quiz_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/api/contract_response.dart';
import '../../../../core/general_widgets/helper_functions.dart';
import '../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import '../../../../core/platform/services/dialog_services/dialog_service.dart';
import '../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../core/references/references.dart';
import '../../models/users/college_student.dart';
import '../../models/users/college_user.dart';
import '../../models/users/school_teacher.dart';
import '../../models/users/user.dart';
import '../pages/my_materials/materialPage/quizes/quiz_collection_model.dart';
import '../pages/my_materials/materialPage/quizes/quiz_draft_model.dart';
import '../pages/my_materials/materialPage/quizes/quiz_entity.dart';
import 'user_info_provider.dart';

abstract class AbstractStateProvider {
  int get semester;

  void updateSemester(int update);
}

class QuizUploaderState with ChangeNotifier implements AbstractStateProvider {
  User userData = locator<UserInfoStateProvider>().userData;

  // =========================================================
  /// quiz collection id just in case we are updating an uploaded quiz or updating a
  ///  quiz draft that has been imported from already uploaded quiz collection
  String _quizCollectionID;

  String get quizCollectionID => _quizCollectionID;

  // =========================================================

  bool _isDisposed = false;

  bool _isCheckBoxChecked = false;

  bool get isCheckBoxChecked => _isCheckBoxChecked;

  void setIsCheckBoxChecked(bool update) {
    if (update != null) {
      _isCheckBoxChecked = update;
      notifyMyListeners();
    }
  }

  // =========================================================================
  // this is for schools
  String _schoolSection;

  String get schoolSection => _schoolSection;

  void updateSchoolSection(String update) {
    if (update != null) {
      _schoolSection = update;
      notifyMyListeners();
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
      notifyMyListeners();
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

  bool _fromUploaded = false;

  bool get fromUploaded => _fromUploaded;

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

  TextEditingController _titleController;

  TextEditingController get titleController => _titleController;

  TextEditingController _descriptionController;

  TextEditingController get descriptionController => _descriptionController;

  String _failureMessage;

  String get failureMessage => _failureMessage;

  QuizCollection _currentCollection;

  bool get isUpdating => quizCollectionID != null;

  GlobalKey<FormState> _formKey;

  GlobalKey<FormState> get formKey => _formKey;

  /// ================================================================================================================
  //// those fields are just for optimization to decrease the size of the payload upon editing
  QuizCredentials _preEditCredentials;
  List<QuizEntity> _preEditQuizItems;

  /// ================================================================================================================

  void updateHasDrafts(bool update) {
    if (update != null) {
      _hasDrafts = update;
      notifyMyListeners();
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

  Future<void> _onLaunch({bool fromDrafts = false, bool fromUploads = false, Quiz payload}) async {
    setIsLoadingTo(true);
    assert(!fromDrafts || !fromUploaded, 'fromDrafts , fromUploaded  => only one of them can be true');
    _fromDrafts = fromDrafts;
    _fromUploaded = fromUploads;

    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    _currentPageIndex = 0;
    _pageController = new PageController(viewportFraction: 0.955);
    _scaffoldKey = new GlobalKey<ScaffoldState>();

    _titleController = new TextEditingController();
    _descriptionController = new TextEditingController();
    _formKey = new GlobalKey<FormState>();

    if (_fromDrafts || _fromUploaded) {
      if (_fromDrafts) {
        await importFromDrafts(payload as QuizDraftEntity);
      } else {
        await importFromUploadedToBeEdit(payload as QuizCollection);
      }
      scrollController.addListener(_fabAppearanceListener);
    }
    locator<DialogService>().quizUploadingState = this;

    String college;
    if (userData.accountType == 'unistudents') {
      college = (userData as CollegeSutdent).college;
      _stage = int.parse((userData as CollegeSutdent).stage.toString());

      if (new RegExp(r'سنان').hasMatch(college)) {
        _topicList = References.getSuitaleCollegeMaterialList(stage, college);
      }
    }
    setIsLoadingTo(false);
  }

  QuizUploaderState({bool fromDrafts = false, bool fromUploads = false, Quiz payload}) {
    assert(!fromDrafts || !fromUploaded, 'fromDrafts , fromUploaded  => only one of them can be true');

    print('a new instance of quiz uploader state provider has been created');
    _onLaunch(fromDrafts: fromDrafts, fromUploads: fromUploads, payload: payload);
  }

  // update topicList upon changing the semester (in case of medicine or pharmacy) and / or
  // changing the stage for all types of user (except students of school of course casue they are not
  // authorized to publish quizes by default

  void updateTopicList() {
    if (userData.accountType == 'schteachers') {
      return;
    }

    String college = (userData as CollegeUser).college;

    _topicList = References.getSuitaleCollegeMaterialList(stage, college, semester: this.semester);
    notifyMyListeners();
  }

// update quiz topic
  void updateTopic(String update) {
    if (update != _topic) {
      _topic = update;
      notifyMyListeners();
    }
  }

// update topic list
  void updateStage(int update) {
    String college;
    if (userData.accountType == 'uniteachers') {
      college = (userData as CollegeUser).college;
    }
    if (update != null) {
      _stage = update;
      _topic = null;
      if (new RegExp(r'سنان').hasMatch(college) || (HelperFucntions.isPharmacyOrMedicine()) && _semester != null) {
        print('our conidtion was met');
        updateTopicList();
      } else {
        print('our condition was not met');
      }
      notifyMyListeners();
    }
  }

// update semester (first or second course)
// for pharmacy and medicne maybe
  void updateSemester(int update) {
    String college = ((userData as CollegeUser)).college;
    if (update != null) {
      _semester = update;
      _topic = null;

      bool updateTopicListForUniteachers = userData.accountType == 'uniteachers' &&
          (HelperFucntions.isPharmacyOrMedicine() || new RegExp(r'سنان').hasMatch(college)) &&
          _stage != null;
      bool updateTopicListForStudents = userData.accountType == 'unistudents' &&
          ((HelperFucntions.isPharmacyOrMedicine() && _semester != null) || new RegExp(r'سنان').hasMatch(college));
      if (updateTopicListForUniteachers || updateTopicListForStudents) {
        updateTopicList();
      }

      notifyMyListeners();
    }
  }

  // showSnackBar
  Future<void> showSnackBar({@required String text, int duration}) async {
    if (_isSnackBarActive) {
      return;
    }
    _isSnackBarActive = true;
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(
          content: Text(text),
          duration: Duration(milliseconds: duration ?? 4000),
        ))
        .closed
        .then((_) => _isSnackBarActive = false);
  }

  /// ===========================================================================================================================
  /// methods called pre upload or update
  // get the credentials
  QuizCredentials getCredentials() {
    String account_type = userData.accountType;

    QuizCredentials quizCredentials = new QuizCredentials()
      ..title = _titleController.text
      ..topic = _topic
      ..description = _descriptionController.text
      ..semester = _semester.toString() ?? 'unknown'
      ..stage = account_type == 'unistudents' ? (userData as CollegeSutdent).stage.toString() : _stage.toString();
    if (account_type != 'schteachers') {
      quizCredentials
        ..college = (userData as CollegeUser).college
        ..university = (userData as CollegeUser).university
        ..section = (userData as CollegeUser).section;
    } else {
      quizCredentials
        ..school = (userData as SchoolTeacher).school
        ..schoolSection = (userData as SchoolTeacher).schoolSection
        ..topic = (userData as SchoolTeacher).speciality;
    }

    return quizCredentials;
  }

  /// ===========================================================================================================================
  // get payload

  Map<String, dynamic> getPayload() {
    QuizCredentials credentials = getCredentials();
    var payload = new Map<String, dynamic>();
    Map<String, dynamic> optimizedCredentials = {};
    List<QuizEntity> optimizedQuizItems = [];
    bool isCredentialModified = false;
    if (isUpdating) {
      // for credentials

      print('we are updating');
      Map<String, dynamic> preEditCrdentialsMap = _preEditCredentials.toJSON();
      if (preEditCrdentialsMap.toString() != credentials.toJSON().toString()) {
        isCredentialModified = true;
      }

      credentials.toJSON().entries.toList().forEach((item) {
        if (item.value.toString().trim() != preEditCrdentialsMap[item.key].toString().trim()) {
          print(item.key + ' has been modified and the new value is ${item.value}');
          optimizedCredentials[item.key] = item.value;
        }
      });

      bool areItemsIdentical = true;
      if (_quizList.length == _preEditQuizItems.length) {
        print('quiz items  and we are checking if there are items that has been modified');
        for (int i = 0; i < _quizList.length; i++) {
          if (_quizList[i].toJSON().toString() != _preEditQuizItems[i].toJSON().toString()) {
            areItemsIdentical = false;
            break;
          }
        }
        if (!areItemsIdentical) {
          print('ther some updates in the questions alreadt exsits');
          optimizedQuizItems = _quizList;
        } else {
          if (!isCredentialModified) {
            return null;
          }
        }
      } else {
        print('there are additional questions added');
        List<QuizEntity> quizListItemsWithId = _quizList.where((element) => element.id != null).toList();

        if (quizListItemsWithId.length == _preEditQuizItems.length) {
          print('there are no deletion in the already exisiting items and we are checking if the have been modified');
          for (int i = 0; i < _preEditQuizItems.length; i++) {
            if (quizListItemsWithId[i].toJSON().toString() != _preEditQuizItems[i].toJSON().toString()) {
              areItemsIdentical = false;
              break;
            }
          }
          if (areItemsIdentical) {
            print('there are no changes the already exisiting items but only newly added questions');
            optimizedQuizItems = _quizList.where((e) => e.id == null).toList();
          } else {
            print('there are changes in the the already exisiting items in addition to newly added questions');
            optimizedQuizItems = _quizList;
          }
        } else {
          print('some deletion occured');
          optimizedQuizItems = _quizList;
        }
      }
    } else {
      optimizedCredentials = credentials.toJSON();
      optimizedQuizItems = _quizList;
    }

    if (optimizedCredentials.isNotEmpty) {
      print('optimized credentials are not empty');
      payload.addAll(optimizedCredentials);
    }

    payload['questions'] = optimizedQuizItems.isEmpty ? null : optimizedQuizItems.map((e) => e.toJSON()).toList();
    payload['questionsCount'] = optimizedQuizItems.isEmpty ? null : _quizList.length;
    payload['uuid'] = userData.uuid;
    if (isUpdating) {
      payload['updateType'] = optimizedQuizItems.length == 0
          ? null
          : optimizedQuizItems.length < _quizList.length
              ? 'push'
              : 'set';
      payload['last_update'] = DateTime.now().toIso8601String();
      final String collectionName = userData.accountType == 'schteachers' ? 'schquizes' : 'uniquizes';
      payload['collectionName'] = collectionName;
      payload['_id'] = _quizCollectionID;
    }

    if (HelperFucntions.isTeacher(userData.accountType)) {
      payload['uuid'] = payload['uuid'] + _stage.toString();
    }

    return payload;
  }

  /// ===========================================================================================================================

  /// ===========================================================================================================================

  // update the status of Floating action button visibility (which is used to add a new quiz item)

  void setFabVisibilityTo(bool update) {
    if (update != null) {
      _isFabVisible = update;
      notifyMyListeners();
    }
  }

  /// ===========================================================================================================================
// quiz list
// general
  List<QuizEntity> _quizList = [];

  List<QuizEntity> get quizList => _quizList;

  void updateQuizList(List<QuizEntity> update) {
    if (update != null) {
      _quizList = update;
      notifyMyListeners();
    }
  }

  /// ===========================================================================================================================
  /// appending and removing from the quiz list
  void appendToQuizList(QuizEntity quiz) {
    if (quiz != null) {
      quiz.answers = [];
      quiz.options = [];
      _quizList.add(quiz);
      notifyMyListeners();
    }
  }

  // **************************************************************
  void removeQuizItemAt(int pos) {
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
    notifyMyListeners();
  }

  /// ===========================================================================================================================
  ///  importing already existing quiz collection
  // import data from draft
  Future<void> importFromDrafts(QuizDraftEntity data) async {
    print('importing from drafts');
    print(data);
    QuizCredentials credentials = data.credentials;

    _quizList = data.quizItems;
    print('Hello World');
    _titleController.text = credentials.title;
    _descriptionController.text = credentials.description;
    _quizCollectionID = data.id;
    _stage = int.parse(credentials.stage.toString());

    if (HelperFucntions.isPharmacyOrMedicine()) {
      _semester = int.parse(credentials.semester);
    }

    _draftStoreIndex = data.storeIndex;
    updateTopicList();
    updateTopic(credentials.topic);
    if (_quizList == null || _quizList.isEmpty) {
      _failureMessage = 'failed to load';
      await QuizAccessObject().removeDrftAt(index: _draftStoreIndex);
      locator<UserInfoStateProvider>().updateQuizDraftsCount();
    } else {
      for (int i = 0; i < _quizList.length; i++) {
        _quizList[i].inReviewMode = true;
      }
    }
  }

  /// ***********************************************************************************
  ///  import data from already uploaded collection
  ///  importing will be done from local and if it failed => it will be fetched from the cloud and be saved to local again
  Future<void> importFromUploadedToBeEdit(QuizCollection data) async {
    _currentCollection = data;
    print('importing from uploads');
    print(data);
    var credentials = data.credentials;
    _quizCollectionID = data.id;
    _quizList = data.quizItems ?? [];
    print('Hello World');
    _titleController.text = credentials.title;
    _descriptionController.text = credentials.description;

    _stage = int.parse(credentials.stage.toString());

    if (HelperFucntions.isPharmacyOrMedicine()) {
      _semester = int.parse(credentials.semester);
    }

    updateTopicList();
    updateTopic(credentials.topic);

    if (_quizList.isEmpty) {
      print('the data is not there so we are importing it either from local or cloud');
      await fetchAllQuestions();
    } else {
      print('the data is already cached');
    }

    if (_quizList.isNotEmpty) {
      for (int i = 0; i < _quizList.length; i++) {
        _quizList[i].inReviewMode = true;
      }
    } else {
      _failureMessage = 'Failed to load quiz questions';
    }
    _preEditCredentials = new QuizCredentials.fromJSON({...getCredentials().toJSON()});
    _preEditQuizItems = [];
    for (QuizEntity entity in _quizList) {
      _preEditQuizItems.add(entity.copy);
    }
  }

  /// ===========================================================================================================================

  Future<void> fetchAllQuestions() async {
    QuizCollection temp = await QuizAccessObject().getUploadedQuizById(MyUploaded.QUIZES, _quizCollectionID);
    if (temp != null) {
      print('Fetching done from local');
      _quizList = temp.quizItems;
      return;
    }

    print('Trying to fetch from cloud server');
    ContractResponse response = await QuizClient().fetchAllQuizQuestions(quizID: _quizCollectionID);
    if (response is Success) {
      Map<String, dynamic> data = json.decode(response.message);
      List<dynamic> questions = data['data']['questions'] as List<dynamic>;

      List<QuizEntity> fetchedQuestions = questions.map<QuizEntity>((question) => new QuizEntity.fromJSON(question)).toList();

      if (fetchedQuestions == null || fetchedQuestions.isEmpty) {
        _failureMessage = 'failed to load';
      }
      _quizList = fetchedQuestions;
      _currentCollection.quizItems = fetchedQuestions;
      _currentCollection.questionsCount = fetchedQuestions.length;
      await QuizAccessObject().saveUploadedMaterial(MyUploaded.QUIZES, _currentCollection.toJSON());
    } else {
      _failureMessage = 'failed to load';
    }
  }

  void saveCurrentQuizEntity(int pos, QuizEntity quiz) {
    _quizList[pos] = quiz;
    notifyMyListeners();
  }

  // switch the quiz view mode so the animation switcher can animate between the 2 pages
  // the on review mode page and the on edit mode page
  void updateQuizViewMode(int pos) {
    if (pos != null) {
      _quizList[pos].inReviewMode = !_quizList[pos].inReviewMode;
      notifyMyListeners();
    }
  }

  void updateCurrentPageIndex(update) {
    if (update != null) {
      _currentPageIndex = update;
      notifyMyListeners();
    }
  }

  void setState() => notifyMyListeners();

// reset all fields to null
  void reset() {
    _title = null;
    _description = null;
    _topic = null;
    _stage = null;
    _semester = null;
    _quizList = null;
    notifyMyListeners();
  }

  Future<void> saveToDraftsOnPressd(BuildContext context) async {
    // if the collection is not opened as an editing on an existing draft and there are no free stores
    if (_fromDrafts && !(await QuizAccessObject().hasAvailableStores())) {
      showSnackBar(
          text: 'Your drafts are full !!\n'
              'try to upload or delete some of them and try again');
    } else if (!_formKey.currentState.validate()) {
      // do nothing
      print('the main credentials is required like the title and description');
    } else if (_quizList.isEmpty || (quizList.length == 1 && quizList.first.isEmpty)) {
      showSnackBar(text: 'there is no quiz item to save');
    }
    // to clear the last quiz item if it is empty
    else {
      // all requirements are met and now we are gonna save the collection to the drafts
      // save to the local database

      // remove the last quiz item if it is not completed
      if (quizList.last.isEmpty) {
        print('last one is empty');
        quizList.removeLast();
      } else {
        print('last one is not empty');
      }

      // save the credentials fileds like title,description ... et cetera
      _formKey.currentState.save();
      QuizCredentials credentials = getCredentials();

      // if the current collection is from an exitsting drafts
      // so we delete the older one and replace it with the current one
      if (fromDrafts) {
        int storeIndex = draftStoreIndex;
        await QuizAccessObject().removeDrftAt(index: storeIndex);
      }

      // save to the database
      String id = quizCollectionID;
      print('just before saving ============================= id == $id');
      await QuizAccessObject().saveQuizItemsToDrafts(id, quizList, credentials);

      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Quiz has been saved successfully'),
        ),
      );

      await Future.delayed(Duration(milliseconds: 500));
      locator<UserInfoStateProvider>().updateQuizDraftsCount();

      Navigator.of(context).pop();
    }
  }

  Future<void> uplodButtonOnPressed(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (quizList.length < 10 || (quizList.length == 10 && quizList.last.isEmpty)) {
        WidgetsBinding.instance.addPostFrameCallback((timer) async {
          await animateToBottom();
          await Future.delayed(Duration(milliseconds: 70));
          showSnackBar(text: 'You must provide at least 10 quiz questions');
        });
        onQuizBelowLimitHandler();
      } else if (quizList.any((quiz) => !quiz.hasAnswers)) {
        await onQuizHasNoAnswersHandler();
        await Future.delayed(Duration(milliseconds: 70));
        showSnackBar(text: 'You must provide answer(s) !!');
      } else {
        // save the credentials
        _formKey.currentState.save();

        // call the uploading method to the server;

        final bool res = await upload(context);
        if (!res) {
          Navigator.of(context).pop();
        }
      }
    }
  }

// upload new quiz
  Future<bool> upload(BuildContext context) async {
    print('===' * 100);
    Map<String, dynamic> payload = getPayload();

    print('===' * 100);
    print('upload completed');

    if (payload == null) {
      print('there are no changes at all');
      print('payload == $payload');
      return false;
    }

    ContractResponse contractResponse;
    final String materialName = MyUploaded.QUIZES;
    if (isUpdating) {
      print('updating quiz collection');
      locator<DialogService>().showDialogOfLoading(message: 'Updating');
      contractResponse = await QuizClient().editEntireQuiz(payload: payload);
    } else {
      print('uploading new quiz collection');
      locator<DialogService>().showDialogOfUploading();
      contractResponse = await CommonMaterialClient().uploadNewMaterial(payload: payload, uploadType: 'quizes');
    }

    print(contractResponse.message);
    if (contractResponse is Success) {
      Map<String, dynamic> responseBody = json.decode(contractResponse.message);
      Map<String, dynamic> data = responseBody['data'];
      List<dynamic> idsList = data['ids_list'] as List<dynamic>;
      if (idsList.isEmpty) {
        print('do nothing');
      } else if (idsList.length == _quizList.length) {
        for (int i = 0; i < idsList.length; i++) {
          _quizList[i].id = idsList[i].toString();
        }
      } else {
        final int diff = _quizList.length - idsList.length;
        for (int i = 0; i < idsList.length; i++) {
          _quizList[diff + i].id = idsList[i].toString();
        }
      }

      if (isUpdating) {
        Map<String, dynamic> newPayload = _currentCollection.toJSON();
        payload.remove('updateType');
        payload.remove('questionsCount');
        payload.remove('questions');
        payload.remove('collectionName');
        List<MapEntry> entries = payload.entries.toList();
        if (entries.isNotEmpty) {
          for (var entry in entries) {
            newPayload[entry.key] = entry.value;
          }
        }
        await QuizAccessObject().deleteUploadedMaterial(materialName, id: _quizCollectionID);

        newPayload['questions'] = _quizList.map((e) => e.toJSON()).toList();
        newPayload['questionsCount'] = _quizList.length;
        payload = newPayload;
      } else {
        payload['_id'] = data['_id'];
        payload['post_date'] = data['post_date'];
        payload['author'] = await HelperFucntions.getAuthorPopulatedData();
        payload['questions'] = _quizList.map((e) => e.toJSON()).toList();
        payload['questionsCount'] = _quizList.length;
      }

      print('just before saving uploaded quiz to local database');

      if (isUpdating && NavigationService.getInstance().canWePopFromQuizesNavigator) {
        QuizStateProvider quizStateProvider = Provider.of<QuizStateProvider>(context, listen: false);
        quizStateProvider.updateMaterialById(new QuizCollection.fromJSON(payload));
      }

      if (isUpdating && NavigationService.getInstance().canWePopFromMyUploads) {
        MyUploadsStateProvider uploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);
        uploadsStateProvider.updateQuizAtById(new QuizCollection.fromJSON(payload));
      }
      await QuizAccessObject().saveUploadedMaterial(materialName, payload);

      if (_fromDrafts) {
        await QuizAccessObject().removeDrftAt(index: _draftStoreIndex);
        locator<UserInfoStateProvider>().updateQuizDraftsCount();
      }
      locator<DialogService>().completeAndCloseDialog(null);
      Navigator.of(context).pop();
      final String text = isUpdating ? 'updated' : 'uploaded';
      locator<DialogService>().showDialogOfSuccess(message: 'Quiz $text successfully');
      return true;
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      print(contractResponse.message);
      return false;
    }
  }

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('quiz uploader satate provider has been disposed successfully');
    locator<DialogService>().quizUploadingState = null;
    scrollController.removeListener(_fabAppearanceListener);
    scrollController.dispose();
    pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
