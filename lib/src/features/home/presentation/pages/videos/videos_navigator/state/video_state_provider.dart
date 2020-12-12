import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/models/users/user.dart';

import '../../../../../../../core/api/api_client/clients/common_materials_client.dart';
import '../../../../../../../core/api/api_client/clients/video_and_pdf_client.dart';
import '../../../../../../../core/api/contract_response.dart';
import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../../features/home/models/materials/study_material.dart';
import '../../../../state_provider/user_info_provider.dart';
import '../../../lectures_pages/state/material_state_repo.dart';

class VideoStateProvider extends MaterialStateRepository with ChangeNotifier {
  VideoStateProvider() {
    loadCredentialData();
    fetchInitialData();
  }

  User userData;

  // ==============================================================================================================

  List<StudyMaterial> _videosList = [];

  List<StudyMaterial> get materials => _videosList;

  // ==============================================================================================================

  @override
  String get collectionName => isAcademic ? 'univideos' : 'schvideos';

  // ==============================================================================================================
  String _failureMessage;

  @override
  String get failureMessage => _failureMessage;

  // ==============================================================================================================
  bool _isAcademic;

  bool get isAcademic => _isAcademic;

  // ==============================================================================================================

  bool _failureOfInitialFetch = false;

  bool get failureOfInitialFetch => _failureOfInitialFetch;

  // ==============================================================================================================

  bool _endOfResults = false;

  bool get endOfResults => _endOfResults;

  // ==============================================================================================================

  bool _isPagintaionFailed = false;

  bool get isPagintaionFailed => _isPagintaionFailed;

  // ==============================================================================================================
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    _isFetching = update;
    notifyMyListeners();
  }

  // ==============================================================================================================

  bool _isPaginating = false;

  bool get isPaginating => _isPaginating;

  void setIsPaginatingTo(bool update) {
    _isPaginating = update;
    notifyMyListeners();
  }

  // ==============================================================================================================
  Future<void> loadCredentialData() async {
    userData = locator<UserInfoStateProvider>().userData;
    _isAcademic = HelperFucntions.isAcademic(userData.accountType);
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  // ==============================================================================================================

  /// fetch initial videos
  Future<void> fetchInitialData() async {
    _videosList = [];
    _failureOfInitialFetch = null;
    setIsFetchingTo(true);
    ContractResponse response = await VideosAndPDFClient().fetch(collectionName: collectionName, idFactor: null);
    if (response is Success) {
      _onFetchingSuccess(response, FetchingType.INITIAL);
    } else {
      _onFetchingFailure(response, FetchingType.INITIAL);
    }
    setIsFetchingTo(false);
  }

  // ==============================================================================================================

  /// fetch videos in pagination style
  Future<void> fetchForPagination() async {
    _isPagintaionFailed = null;
    setIsPaginatingTo(true);
    ContractResponse response = await VideosAndPDFClient().fetch(collectionName: collectionName, idFactor: _videosList.last.id);
    if (response is Success) {
      _onFetchingSuccess(response, FetchingType.PAGINATION);
    } else {
      _onFetchingFailure(response, FetchingType.PAGINATION);
    }
    setIsPaginatingTo(false);
  }

  // ==============================================================================================================

  void _onFetchingSuccess(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failureOfInitialFetch = false;
    } else {
      _isPagintaionFailed = false;
    }
    List<StudyMaterial> fetchedVideos = getFetchedMaterialsFromResponse(response);
    if (_endOfResults || _videosList.isEmpty) {
      _videosList = fetchedVideos;
    } else {
      _videosList.addAll(fetchedVideos);
    }
    _endOfResults = fetchedVideos.length < 10 || (fetchedVideos.isEmpty && fetchingType == FetchingType.PAGINATION);
  }

// ===============================================================================================================
  /// this method is called when any fetching process succeed;
  void _onFetchingFailure(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failureOfInitialFetch = true;
      _failureMessage = HelperFucntions.getFailureMessage(response, 'videos', false);
      return;
    }
    _isPagintaionFailed = true;
    _failureMessage = 'Failed to load more videos';
  }

  // ==============================================================================================================

  void appendToMaterialsFrom(List<StudyMaterial> data) {
    if (data.isNotEmpty) {
      _videosList.addAll(data);
      notifyMyListeners();
    }
  }

  // ==============================================================================================================

  @override
  void appendToMaterialsOnRefreshFrom(List<StudyMaterial> data) {
    if (data.isNotEmpty) {
      _videosList.insertAll(0, data);
      notifyMyListeners();
    }
  } // ==============================================================================================================

  Future<void> onRefresh() async {
    if (_videosList.isEmpty || _endOfResults) {
      fetchInitialData();
      return;
    }
    ContractResponse response = await VideosAndPDFClient().fetchOnRefresh(collection: collectionName, idFactor: _videosList.first.id);
    if (response is Success) {
      List<StudyMaterial> fetchedMaterials = getFetchedMaterialsFromResponse(response);
      appendToMaterialsFrom(fetchedMaterials);
      return;
    }
    final String errorMessage = response is NoInternetConnection ? 'No internet connection!' : 'Failed to load videos!';
    showSnackBar(errorMessage, seconds: 5);
  }

// =========================================================================================================

  void appendToComments(String id, int pos) {
    _videosList[pos].comments.add(id);
    notifyMyListeners();
  }

// ==============================================================================================================

  void removeFromComments(String id, int pos) {
    _videosList[pos].comments.removeWhere((commentId) => commentId == id);
    notifyMyListeners();
  }

// =========================================================================================================

  @override
  Future<void> onMaterialSaving(int pos) async {
    _videosList[pos].isSaved = !_videosList[pos].isSaved;
    notifyMyListeners();
    final String indicator = _videosList[pos].isSaved ? 'add' : 'pull';
    final String id = materials[pos].id;
    await _onMaterialSavingDelegate(id, 'saved_videos', indicator);
  }

// ==============================================================================================================

  Future<void> onMaterialSavingFromExternal(String id) async {
    final StudyMaterial lecture = _videosList.firstWhere((element) => element.id == id, orElse: () => null);
    if (lecture != null) {
      lecture.isSaved = false;
    }

    await _onMaterialSavingDelegate(id, 'saved_videos', 'pull');
  }

// ==============================================================================================================

  Future<void> _onMaterialSavingDelegate(String id, String fieldName, String indicator) async {
    ContractResponse response = await CommonMaterialClient().saveMaterial(
      id: id,
      fieldName: fieldName,
      indicator: indicator,
    );
    if (response is Success) {
      UserInfoStateProvider userInfoState = locator<UserInfoStateProvider>();
      if (indicator == 'pull') {
        userInfoState.userData.savedVideos.remove(id);
      } else {
        userInfoState.userData.savedVideos.add(id);
      }
      await userInfoState.updateUserInfo();
      userInfoState.notifyMyListeners();
      notifyMyListeners();
    }
  }

// ==============================================================================================================

  @override
  void removeMaterialAt(int pos) {
    _videosList.removeAt(pos);
    if (_videosList.isEmpty) {
      fetchInitialData();
      return;
    }
    notifyMyListeners();
  }

// ==============================================================================================================

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

// ==============================================================================================================

  bool _isSnackBarVisible = false;

  @override
  Future<void> showSnackBar(String message, {int seconds}) async {
    if (_isSnackBarVisible) {
      return;
    }
    _isSnackBarVisible = true;
    _scaffoldKey.currentState
        .showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: seconds ?? 3),
          ),
        )
        .closed
        .then((value) => _isSnackBarVisible = false);
  }

  // ==============================================================================================================

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

// ==============================================================================================================
}
