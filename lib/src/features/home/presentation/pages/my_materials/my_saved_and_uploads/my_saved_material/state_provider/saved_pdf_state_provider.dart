import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

import '../../../../../../../../core/api/api_client/clients/video_and_pdf_client.dart';
import '../../../../../../../../core/api/contract_response.dart';
import '../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../models/materials/study_material.dart';
import '../../../../../../models/users/user.dart';
import '../../../../../state_provider/user_info_provider.dart';

import '../../../../lectures_pages/state/pdf_state_provider.dart';

class MySavedPDFStateProvider extends MaterialStateRepository with ChangeNotifier {
  User userData;


  MySavedPDFStateProvider() {
    loadCredentialData();
    fetchInitialData();
  }

  // ==========================================================================================

  /// lectuers

  // Scaffold key to control the display of snackBar and other bottom sheet widgets
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // ===============================================================================================================

  @override
  String get collectionName => isAcademic ? 'unilectures' : 'schlectures';

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
    print('Fetching ..... ');
    print(savedLectuersIds);
    _savedLectures = [];
    _failedInitialFetch = null;

    if (_savedLecturesIds.isEmpty) {
      _failedInitialFetch = false;
      notifyMyListeners();
      return;
    }
    setIsFetchingTo(true);

    List<String> idsList = _getFetchingParams();

    ContractResponse response = await VideosAndPDFClient().fetchSavedMaterials(
      collection: collectionName,
      ids: idsList,
    );

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
    List<String> idsList = _getFetchingParams();
    if (idsList.isEmpty) {
      _failedPagination = false;
      _endOfResults = true;
      setIsPaginatingTo(false);
      return;
    }
    ContractResponse response = await VideosAndPDFClient().fetchSavedMaterials(
      collection: collectionName,
      ids: idsList,
    );

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
    List<StudyMaterial> fetched = getFetchedMaterialsFromResponse(response);
    if (_endOfResults || _savedLectures.isEmpty) {
      _savedLectures = fetched;
    } else {
      _savedLectures.addAll(fetched);
    }
    _endOfResults = _savedLectures.length == _savedLecturesIds.length || (fetched.isEmpty && fetchingType == FetchingType.PAGINATION);
  }

  // ===============================================================================================================

  /// this method is called when any fetching process succeed;
  void _onFetchFailure(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failedInitialFetch = true;
      _failureMessage = HelperFucntions.getFailureMessage(response, 'lectures', true);
      return;
    }
    _failedPagination = true;
    _failureMessage = 'Failed to load more lectures';
  }

// ===============================================================================================================

  /// this method return the fetching params which are (collection , list of ids) respectivly
  List<String> _getFetchingParams({bool isRefreshing = false}) {
    List<String> ids;
    if (isRefreshing) {
      final List<String> fetchedIds = _savedLectures.map<String>((lecture) => lecture.id).toList();
      ids = _savedLecturesIds.where((id) => !fetchedIds.contains(id)).toList();
      return ids;
    }

    final int unfetchedCount = _savedLecturesIds.sublist(_savedLectures.length).length;
    final int endIndex = _savedLectures.length + (unfetchedCount > 7 ? 7 : unfetchedCount);
    ids = _savedLecturesIds.sublist(_savedLectures.length, endIndex);

    return ids;
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
    print('MySavedPDFStateProvider has been disposed');
    super.dispose();
  }

  // ===============================================================================================================
  /// not necessary here because it is implemented due the abstract class MaterialStateRepo
  @override
  void appendToComments(String id, int pos) {
    _savedLectures[pos].comments.add(id);
    locator<PDFStateProvider>().appendToComments(id, pos);
    notifyMyListeners();
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

  @override
  void appendToMaterialsOnRefreshFrom(List<StudyMaterial> data) {
    if (data.isNotEmpty) {
      _savedLectures.insertAll(0, data);
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
    await locator<PDFStateProvider>().onMaterialSavingFromExternal(id);
    if (_savedLectures.isEmpty) {
      fetchInitialData();
    }
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
    if (_savedLectures.isEmpty || _endOfResults) {
      print('refresh as new fetch');
      fetchInitialData();
      return;
    }
    print('refresh as normal');
    List<String> idsList = _getFetchingParams(isRefreshing: true);
    if (idsList.isEmpty) {
      final String message = 'There are no more saved lectures to load';
      showSnackBar(message, seconds: 5);
      return;
    }
    ContractResponse response = await VideosAndPDFClient().fetchSavedMaterials(
      collection: collectionName,
      ids: idsList,
    );

    if (response is Success) {
      List<StudyMaterial> fetchedData = getFetchedMaterialsFromResponse(response);
      appendToMaterialsOnRefreshFrom(fetchedData);
      return;
    }
    final String message = response is NoInternetConnection ? 'No internet connection' : 'Failed to load lectures';
    showSnackBar(message, seconds: 5);
  }

  // ===============================================================================================================
  // show snack bar
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

  // ===============================================================================================================
  /// not Necessary
  @override
  void removeFromComments(String id, int pos) {
    _savedLectures[pos].comments.removeWhere((comment) => comment == id);
    locator<PDFStateProvider>().removeFromComments(id, pos);
    notifyMyListeners();
  }

// ===============================================================================================================
  @override
  void removeMaterialAt(int pos) {
    _savedLectures.removeAt(pos);
    notifyMyListeners();
  }

  @override
  void replaceMaterialWith(StudyMaterial newMaterial) {
    final int index = _savedLectures.indexWhere((element) => element.id == newMaterial.id);
    if (index > -1) {
      _savedLectures[index] = newMaterial;
      notifyMyListeners();
    }
  }
}
