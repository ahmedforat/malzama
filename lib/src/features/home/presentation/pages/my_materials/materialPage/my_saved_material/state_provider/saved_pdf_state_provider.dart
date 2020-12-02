import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/api_client/clients/video_and_pdf_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

enum FetchingType {
  INITIAL,
  PAGINATION,
}

class MySavedPDFStateProvider with ChangeNotifier implements MaterialStateRepository {
  User userData;

  MySavedPDFStateProvider() {
    loadCredentialData();
    fetchInitialData();
  }

  // ==========================================================================================

  bool _noData = false;

  bool get noData => _noData;

  setNoDataTo(bool update) {
    _noData = update;
    notifyMyListeners();
  }

  /// lectuers
  ///
  ///
  ///

  // Scaffold key to control the display of snackBar and other bottom sheet widgets
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // ===============================================================================================================

  /// Failure message that get value when we encounter an error during the fetching process
  String _failureMessage;

  String get failureMessage => _failureMessage;

  // ===============================================================================================================

  /// Indicator of Failure of initial fetching process
  bool _failedInitialFetch = false;

  bool get failureOfInitialFetch => _failedInitialFetch;

  // ===============================================================================================================

  /// Indicator of End of data when we are doing pagination

  bool _endOfResults = false;

  bool get endOfResults => _endOfResults;

  // ===============================================================================================================

  /// Indicator of Failure of Pagination process

  bool _failedPagination = false;

  bool get isPagintaionFailed => _failedPagination;

  // ===============================================================================================================

  /// List of  Saved Lectures Ids that we get from the UserInfoStateProvider
  List<String> _savedLecturesIds;

  List<String> get savedLectuersIds => _savedLecturesIds;

  // ===============================================================================================================

  /// List of already fetched saved lectures
  List<StudyMaterial> _savedLectures = [];

  List<StudyMaterial> get savedLectures => _savedLectures;

  // ===============================================================================================================

  /// indicator of initial fetching
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    _isFetching = update;
    notifyMyListeners();
  }

  // ===============================================================================================================

  /// indicator of Pagination fetching
  bool _isPaginating = false;

  bool get isPaginating => _isPaginating;

  void setIsPaginatingTo(bool update) {
    _isPaginating = update;
    notifyMyListeners();
  }

  // ===============================================================================================================

  /// this method is for Initial Fetching of Saved lectures
  @override
  Future<void> fetchInitialData() async {
    _failedInitialFetch = null;
    setIsFetchingTo(true);
    if (_savedLecturesIds.isEmpty) {
      _noData = true;
      _failedInitialFetch = false;
      setIsFetchingTo(false);
      return;
    }

    List params = _getFetchingParams();

    ContractResponse response =
        await VideosAndPDFClient().fetchSavedMaterials(collection: params[0] as String, ids: params[1] as List<String>);

    if (response is Success) {
      _onFetchSuccess(response, FetchingType.INITIAL);
    } else {
      _onFetchFailure(response, FetchingType.INITIAL);
    }
    setIsFetchingTo(false);
  }

  // ===============================================================================================================

  // this method is for Pagination Fetching of Saved lectures
  @override
  Future<void> fetchForPagination() async {
    _failedPagination = null;
    setIsPaginatingTo(true);
    List params = _getFetchingParams();
    ContractResponse response =
        await VideosAndPDFClient().fetchSavedMaterials(collection: params[0] as String, ids: params[1] as List<String>);

    if (response is Success) {
      _onFetchSuccess(response, FetchingType.PAGINATION);
    } else {
      _onFetchFailure(response, FetchingType.PAGINATION);
    }
    setIsPaginatingTo(false);
  }

  // ===============================================================================================================

  /// this method is called when any fetching process succeed;
  void _onFetchSuccess(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failedInitialFetch = false;
    } else {
      _failedPagination = false;
    }
    Map<String, dynamic> data = json.decode(response.message);

    if ((data['data'] as List<dynamic>).isNotEmpty) {
      List<StudyMaterial> fetchcedLectures =
          (data['data'] as List<dynamic>).map<StudyMaterial>((e) => new StudyMaterial.fromJSON(e)).toList();
      _savedLectures.addAll(fetchcedLectures);
    } else {
      if (fetchingType == FetchingType.INITIAL) {
        _noData = _savedLectures.isEmpty;
      } else {
        _endOfResults = true;
      }
    }
  }

  // ===============================================================================================================

  /// this method is called when any fetching process succeed;
  void _onFetchFailure(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failedInitialFetch = true;
      _handleFailureMessage(response);
    } else {
      _failedPagination = true;
      _failureMessage = 'Failed to load more lectures';
    }
  }

  // ===============================================================================================================
  /// to know whether we have  ids that are not fetched yet

  bool get anymoreFetch => _savedLecturesIds.isNotEmpty;

  // ===============================================================================================================

  /// this method set the failure message to the proper value
  void _handleFailureMessage(ContractResponse response) {
    if (response is NoInternetConnection) {
      _failureMessage = 'Oops!! No Internet Connection\n make sure your device is connected to the internet and try again';
    } else {
      _failureMessage = 'Oops!!\n\nFailed to load saved lectures\n'
          'something went wrong \nor it might be the server is not responding\n';
    }
  }

// ===============================================================================================================

  /// this method return the fetching params which are (collection , list of ids) respectivly
  List<dynamic> _getFetchingParams({bool isRefreshing = false}) {
    List<String> ids;
    final String collection = userData.isAcademic ? 'unilectures' : 'schlectures';

    if (isRefreshing) {
      final List<String> fetchedIds = _savedLectures.map<String>((lecture) => lecture.id).toList();
      ids = _savedLecturesIds.where((id) => !fetchedIds.contains(id));
      return [collection, ids];
    }

    final int unfetchedCount = _savedLecturesIds.sublist(_savedLectures.length).length;
    final int endIndex = _savedLectures.length + (unfetchedCount > 7 ? 7 : unfetchedCount);
    ids = _savedLecturesIds.sublist(_savedLectures.length, endIndex);

    return [collection, ids];
  }

  // ===============================================================================================================

  /// Related to the ChangeNotifier State
  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('MySavedStateProvider has been disposed');
    super.dispose();
  }

  // ===============================================================================================================
  /// not necessary here because it is implemented due the abstract class MaterialStateRepo
  @override
  void appendToComments(String id, int pos) {
    print('do nothing');
  }

  // ===============================================================================================================

  /// append To Materials from list of studyMaterial
  @override
  void appendToMaterialsFrom(List<StudyMaterial> data) {
    if (data.isNotEmpty) {
      _savedLectures.addAll(data);
      notifyMyListeners();
    }
  }

  // ===============================================================================================================
  // to know whether the user is academic (uniteacher or unistudent) or not
  @override
  bool get isAcademic => userData.isAcademic;

  // ===============================================================================================================

  /// load essential data to work with
  @override
  Future<void> loadCredentialData() async {
    print('mySavedState Provider has been initialized');
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    userData = locator<UserInfoStateProvider>().userData;
    _savedLecturesIds = userData.savedLectures ?? [];
  }

  // ===============================================================================================================
  /// getter of fetched lectures
  @override
  List<StudyMaterial> get materials => _savedLectures;

  // ===============================================================================================================

  /// called when the user tap on the bookmark button which indicate unsaving cause the unsaved one get removed
  /// and not appear in the saved list
  @override
  Future<void> onMaterialSaving(int pos) async {
    String id = _savedLectures[pos].id;
    removeMaterialAt(pos);
    locator<PDFStateProvider>().onMaterialSavingFromExternal(id);
  }

  // ===============================================================================================================

  /// Not Neccessary
  @override
  Future<void> onMaterialSavingFromExternal(String id) async {
    print('do nothing');
  }

  // ===============================================================================================================
  @override
  Future<void> onRefresh() async {
    List<dynamic> params = _getFetchingParams(isRefreshing: true);
    ContractResponse response =
        await VideosAndPDFClient().fetchSavedMaterials(collection: params[0] as String, ids: params[1] as List<String>);

    if (response is Success) {
      Map<String, dynamic> data = json.decode(response.message);
      List<StudyMaterial> fetchedData =
          (data['data'] as List<dynamic>).map<StudyMaterial>((item) => new StudyMaterial.fromJSON(item)).toList();
      appendToMaterialsFrom(fetchedData);
    } else {
      final String message = response is NoInternetConnection ? 'No internet connection' : 'Failed to refresh';
      showSnackBar(message);
    }
  }

  // ===============================================================================================================
  // show snack bar
  bool _isSnackBarVisible = false;

  @override
  Future<void> showSnackBar(String message, {int seconds}) async {
    if (!_isSnackBarVisible) {
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
  }

  // ===============================================================================================================
  /// not Necessary
  @override
  void removeFromComments(String id, int pos) {
    print('nothing');
  }

// ===============================================================================================================
  @override
  void removeMaterialAt(int pos) {
    _savedLectures.removeAt(pos);
    if (_savedLectures.isEmpty) {
      fetchInitialData();
    } else {
      notifyMyListeners();
    }
  }
}
