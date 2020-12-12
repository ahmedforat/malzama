import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/api/api_client/clients/common_materials_client.dart';
import '../../../../../../core/api/api_client/clients/video_and_pdf_client.dart';
import '../../../../../../core/api/contract_response.dart';
import '../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import '../../../../../../features/home/presentation/state_provider/user_info_provider.dart';
import '../../../../models/materials/study_material.dart';
import '../../../../models/users/user.dart';

class PDFStateProvider extends MaterialStateRepository with ChangeNotifier {
  PDFStateProvider() {
    loadCredentialData();
    fetchInitialData();
  }

  User userData;
  List<StudyMaterial> _pdfList = [];

  List<StudyMaterial> get materials => _pdfList;

  // ==============================================================================================================
  /// Failure message when we get an error during the fetching process
  String _failureMessage;

  @override
  String get failureMessage => _failureMessage;

  // ==============================================================================================================
  @override
  String get collectionName => isAcademic ? 'unilectures' : 'schlectures';

  // ==============================================================================================================

  bool _isAcademic;

  @override
  bool get isAcademic => _isAcademic;

  // ==============================================================================================================

  bool _failureOfInitialFetch = false;

  @override
  bool get failureOfInitialFetch => _failureOfInitialFetch;

  // ==============================================================================================================

  bool _endOfResults = false;

  @override
  bool get endOfResults => _endOfResults;

  // ==============================================================================================================

  bool _isPagintaionFailed = false;

  @override
  bool get isPagintaionFailed => _isPagintaionFailed;

  // ==============================================================================================================
  bool _isFetching = false;

  @override
  bool get isFetching => _isFetching;

  @override
  void setIsFetchingTo(bool update) {
    _isFetching = update;
    notifyMyListeners();
  }

  // ==============================================================================================================

  bool _isPaginating = false;

  @override
  bool get isPaginating => _isPaginating;

  @override
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

  Future<void> fetchInitialData() async {
    _pdfList = [];
    _failureOfInitialFetch = null;
    setIsFetchingTo(true);

    ContractResponse response = await VideosAndPDFClient().fetch(idFactor: null, collectionName: collectionName);
    if (response is Success) {
      _onFetchingSuccess(response, FetchingType.INITIAL);
    } else {
      _onFetchingFailure(response, FetchingType.INITIAL);
    }
    setIsFetchingTo(false);
  }

  // ==============================================================================================================

  Future<void> fetchForPagination() async {
    _isPagintaionFailed = null;
    setIsPaginatingTo(true);

    ContractResponse response = await VideosAndPDFClient().fetch(collectionName: collectionName, idFactor: _pdfList.last.id);
    if (response is Success) {
      _onFetchingSuccess(response, FetchingType.PAGINATION);
    } else {
      _onFetchingFailure(response, FetchingType.PAGINATION);
    }
    setIsPaginatingTo(false);
  }

  // ==============================================================================================================
  /// this method is called when any fetching process succeed;
  void _onFetchingSuccess(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failureOfInitialFetch = false;
    } else {
      _isPagintaionFailed = false;
    }
    List<StudyMaterial> fetched = getFetchedMaterialsFromResponse(response);
    if (_endOfResults || _pdfList.isEmpty) {
      _pdfList = fetched;
    } else {
      _pdfList.addAll(fetched);
    }
    _endOfResults = fetched.length < 10 || fetched.isEmpty && fetchingType == FetchingType.PAGINATION;
  }

// ===============================================================================================================

  /// this method is called when any fetching process fails;
  void _onFetchingFailure(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failureOfInitialFetch = true;
      _failureMessage = HelperFucntions.getFailureMessage(response, 'lectures', false);
      return;
    }
    _isPagintaionFailed = true;
    _failureMessage = 'Failed to load more lectures';
  }

  // ==============================================================================================================
  void appendToMaterialsFrom(List<StudyMaterial> data) {
    if (data.isNotEmpty) {
      _pdfList.addAll(data);
      notifyMyListeners();
    }
  }

  // ==============================================================================================================

  @override
  void appendToMaterialsOnRefreshFrom(List<StudyMaterial> data) {
    if (data.isNotEmpty) {
      _pdfList.insertAll(0, data);
      notifyMyListeners();
    }
  }

// ================================================================================================================
  Future<void> onRefresh() async {
    if (_pdfList.isEmpty || _endOfResults) {
      fetchInitialData();
      return;
    }

    ContractResponse response = await VideosAndPDFClient().fetchOnRefresh(collection: collectionName, idFactor: materials.first.id);
    if (response is Success) {
      List<StudyMaterial> fetchedLectures = getFetchedMaterialsFromResponse(response);
      appendToMaterialsOnRefreshFrom(fetchedLectures);
      return;
    }
    final String errorMessage = response is NoInternetConnection ? 'No internet connection!' : 'Failed to load lectures!';

    showSnackBar(errorMessage, seconds: 5);
  }

  // ==============================================================================================================
  void appendToComments(String id, int pos) {
    _pdfList[pos].comments.add(id);
    notifyMyListeners();
  }

  // ==============================================================================================================

  void removeFromComments(String id, int pos) {
    _pdfList[pos].comments.removeWhere((comment) => comment == id);
    notifyMyListeners();
  }

  // ==============================================================================================================
// update isSaved status of material

  @override
  Future<void> onMaterialSaving(int pos) async {
    _pdfList[pos].isSaved = !_pdfList[pos].isSaved;
    notifyMyListeners();
    final String indicator = _pdfList[pos].isSaved ? 'add' : 'pull';
    final String id = materials[pos].id;
    await _onMaterialSavingDelegate(id, 'saved_lectures', indicator);
  }

// ==============================================================================================================
  @override
  Future<void> onMaterialSavingFromExternal(String id) async {
    final StudyMaterial lecture = _pdfList.firstWhere((element) => element.id == id, orElse: () => null);
    if (lecture != null) {
      lecture.isSaved = false;
    }
    await _onMaterialSavingDelegate(id, 'saved_lectures', 'pull');
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
        userInfoState.userData.savedLectures.remove(id);
      } else {
        userInfoState.userData.savedLectures.add(id);
      }
      await userInfoState.updateUserInfo();
      userInfoState.notifyMyListeners();
      notifyMyListeners();
    }
  }

  // ==============================================================================================================

  @override
  void removeMaterialAt(int pos) {
    _pdfList.removeAt(pos);
    if (_pdfList.isEmpty) {
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

// ===============================================================================================================
}
