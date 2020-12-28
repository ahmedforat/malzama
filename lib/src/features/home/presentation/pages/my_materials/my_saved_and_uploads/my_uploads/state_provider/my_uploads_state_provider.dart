import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/api/api_client/clients/common_materials_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/materials/college_material.dart';
import 'package:malzama/src/features/home/models/materials/school_material.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_collection_model.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/my_saved_and_uploads_contract.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/video_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

class MyUploadsStateProvider extends MySavedAndUploadsCommonState with ChangeNotifier {
  User userData;

  GlobalKey<ScaffoldState> _lecturesScaffoldKey;
  GlobalKey<ScaffoldState> _videosScaffoldKey;
  GlobalKey<ScaffoldState> _quizesScaffoldKey;

  GlobalKey<ScaffoldState> get lecturesScaffoldKey => _lecturesScaffoldKey;

  GlobalKey<ScaffoldState> get videosScaffoldKey => _videosScaffoldKey;

  GlobalKey<ScaffoldState> get quizesScaffoldKey => _quizesScaffoldKey;

  MyUploadsStateProvider() {
    _lecturesScaffoldKey = new GlobalKey<ScaffoldState>();
    _videosScaffoldKey = new GlobalKey<ScaffoldState>();
    _quizesScaffoldKey = new GlobalKey<ScaffoldState>();
    _pageController = new PageController();
    userData = locator<UserInfoStateProvider>().userData;
    launchFetching();
  }

  // =========================================================================================================================================
  bool get isAcademic => userData.isAcademic;

  // =========================================================================================================================================
  // Change the Color of the TabBar singel tab color when the tabIndex get changed
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void updateCurrentTabIndx(int update) {
    _currentTabIndex = update;
    notifiyMyListeners();
  }

  // =========================================================================================================================================

  PageController _pageController;

  PageController get pageController => _pageController;

  // =========================================================================================================================================

  void onPageChange(int index) {
    updateCurrentTabIndx(index);
  }

  // =========================================================================================================================================

  bool _isDisposed = false;

  void notifiyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('My Uploads StateProvider has been disposed');
    super.dispose();
  }

  // =========================================================================================================================================
  bool _isFetching;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    _isFetching = update;
    notifiyMyListeners();
  }

  //
  // =========================================================================================================================================
  bool _isFetchingQuizes;

  bool get isFetchingQuizes => _isFetchingQuizes;

  void setIsFetchingQuizesTo(bool update) {
    _isFetchingQuizes = update;
    notifiyMyListeners();
  }

// =========================================================================================================================================
  bool _isFetchingLectures;

  bool get isFetchingLectures => _isFetchingLectures;

  void setIsFetchingLecturesTo(bool update) {
    _isFetchingLectures = update;
    notifiyMyListeners();
  }

// =========================================================================================================================================
  bool _isFetchingVideos;

  bool get isFetchingVideos => _isFetchingVideos;

  void setIsFetchingVideosTo(bool update) {
    _isFetchingVideos = update;
    notifiyMyListeners();
  }

// =========================================================================================================================================

  List<QuizCollection> _uploadedQuizes = [];
  List<StudyMaterial> _uploadedLectures = [];
  List<StudyMaterial> _uploadedVideos = [];

  List<QuizCollection> get uploadedQuizes => _uploadedQuizes;

  List<StudyMaterial> get uploadedLectures => _uploadedLectures;

  List<StudyMaterial> get uploadedVideos => _uploadedVideos;

  // =========================================================================================================================================

  void appendToQuizes(List<QuizCollection> quizes) {
    if (quizes.isNotEmpty) {
      _uploadedQuizes.addAll(quizes);
      notifiyMyListeners();
    }
  }

  void appendToLectures(List<StudyMaterial> lectures) {
    if (lectures.isNotEmpty) {
      _uploadedLectures.addAll(lectures);
      notifiyMyListeners();
    }
  }

  void appendToVideos(List<StudyMaterial> videos) {
    if (videos.isNotEmpty) {
      _uploadedVideos.addAll(videos);
      notifiyMyListeners();
    }
  }

// =========================================================================================================================================
  void removeLecture(int pos) {
    _uploadedLectures.removeAt(pos);
    notifiyMyListeners();
  }

  void removeVideo(int pos) {
    _uploadedVideos.removeAt(pos);
    notifiyMyListeners();
  }

  void removeQuiz(int pos) {
    _uploadedQuizes.removeAt(pos);
    notifiyMyListeners();
  }

  // =========================================================================================================================================

  void updateQuizAtById(QuizCollection collection) {
    final int index = _uploadedQuizes.indexWhere((element) => element.id == collection.id);
    if (index > 0) {
      _uploadedQuizes[index] = collection;
      notifiyMyListeners();
    }
  }

  void updateQuizItemAtCollection(String collectionId, int itemIndex, QuizEntity item) {
    final int index = _uploadedQuizes.indexWhere((element) => element.id == collectionId);
    if (index > 0) {
      _uploadedQuizes[index].quizItems[itemIndex] = _uploadedQuizes[index].quizItems[itemIndex].copyWith(item);
      notifiyMyListeners();
    }
  }

  void updateLectureAtById(StudyMaterial studyMaterial) {
    final int index = _uploadedLectures.indexWhere((element) => element.id == studyMaterial.id);
    if (index > 0) {
      _uploadedLectures[index] = studyMaterial;
      notifiyMyListeners();
    }
  }

  void updateVideoAtById(StudyMaterial studyMaterial) {
    final int index = _uploadedVideos.indexWhere((element) => element.id == studyMaterial.id);
    if (index > 0) {
      _uploadedVideos[index] = studyMaterial;
      notifiyMyListeners();
    }
  }

  // =========================================================================================================================================

  Future<void> fetchQuizes() async {
    setIsFetchingQuizesTo(true);
    final List<Map<String, dynamic>> _quizes = await QuizAccessObject().getUploadedMaterials(MyUploaded.QUIZES);
    if (_quizes.isNotEmpty) {
      List<QuizCollection> mappedQuizes = _quizes.map<QuizCollection>((quiz) => new QuizCollection.fromJSON(quiz)).toList();
      _uploadedQuizes = mappedQuizes;
    }
    setIsFetchingQuizesTo(false);
  }

  StudyMaterial _jsonParser(data) {
    return isAcademic ? CollegeMaterial.fromJSON(data) : SchoolMaterial.fromJSON(data);
  }

  Future<void> fetchLectures() async {
    setIsFetchingLecturesTo(true);
    final List<Map<String, dynamic>> _lectures = await QuizAccessObject().getUploadedMaterials(MyUploaded.LECTURES);
    if (_lectures.isNotEmpty) {
      List<StudyMaterial> mappedLectures = _lectures.map<StudyMaterial>(_jsonParser).toList();
      _uploadedLectures = mappedLectures;
    }
    setIsFetchingLecturesTo(false);
  }

  Future<void> fetchVideos() async {
    setIsFetchingVideosTo(true);
    final List<Map<String, dynamic>> _videos = await QuizAccessObject().getUploadedMaterials(MyUploaded.VIDEOS);
    if (_videos.isNotEmpty) {
      List<StudyMaterial> mappedVideos = _videos.map<StudyMaterial>(_jsonParser).toList();
      _uploadedVideos = mappedVideos;
    }
    setIsFetchingVideosTo(false);
  }

// =========================================================================================================================================

  void launchFetching() {
    fetchLectures();
    fetchVideos();
    fetchQuizes();
  }

  Future<void> onQuizEdit(BuildContext context, int pos) async {
    Navigator.of(context).pushNamed(
      RouteNames.EDIT_UPLOADED_QUIZ,
      arguments: _uploadedQuizes[pos],
    );
  }

  Future<void> onQuizDelete(BuildContext context, int pos) async {
    locator<DialogService>().showDialogOfLoading(message: 'deleting ....');
    final String collectionName = isAcademic ? 'uniquizes' : 'schquizes';
    final String id = _uploadedQuizes[pos].id;
    ContractResponse response = await CommonMaterialClient().deleteMaterial(collectionName: collectionName, materialId: id);
    if (response is Success) {
      _uploadedQuizes.removeAt(pos);
      notifiyMyListeners();
      QuizAccessObject().deleteUploadedMaterial(MyUploaded.QUIZES, id: id);
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfSuccess(message: 'quiz collection has been deleted');
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfFailure(message: 'Failed to delete this collection');
    }
  }

  Future<void> onMaterialDelete(BuildContext context, int pos, String materialName) async {
    locator<DialogService>().showDialogOfLoading(message: 'deleting ....');
    final String collectionName = isAcademic ? 'uni$materialName' : 'sch$materialName';
    final String id = materialName == 'videos' ? _uploadedVideos[pos].id : _uploadedLectures[pos].id;
    ContractResponse response = await CommonMaterialClient().deleteMaterial(collectionName: collectionName, materialId: id);
    if (response is Success) {
      materialName == 'videos' ? _uploadedVideos.removeAt(pos) : _uploadedLectures.removeAt(pos);
      notifiyMyListeners();
      if (materialName == 'videos') {
        final int index = locator<VideoStateProvider>().materials.indexWhere((element) => element.id == id);
        if (index > -1) {
          locator<VideoStateProvider>().removeMaterialAt(index);
        }
      } else {
        final int index = locator<PDFStateProvider>().materials.indexWhere((element) => element.id == id);
        if (index > -1) {
          locator<PDFStateProvider>().removeMaterialAt(index);
        }
      }
      final String storeName = materialName == 'videos' ? MyUploaded.VIDEOS : MyUploaded.LECTURES;
      QuizAccessObject().deleteUploadedMaterial(storeName, id: id);
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfSuccess(message: 'deleted');
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfFailure(message: 'Failed to delete this ${materialName.substring(0, materialName.length - 1)}');
    }
  }

  Future<void> onMaterialEdit(BuildContext context, int pos, bool isVideo) async {
    Map<String, dynamic> _args = {
      'isVideo': isVideo,
      'payload': isVideo ? _uploadedVideos[pos] : _uploadedLectures[pos],
    };
    final String routeName = userData.isAcademic ? RouteNames.EDIT_COLLEGE_MATERIAL : RouteNames.EDIT_SCHOLL_MATERIAL;
    Navigator.pushNamed(context, routeName, arguments: _args);
  }
}
