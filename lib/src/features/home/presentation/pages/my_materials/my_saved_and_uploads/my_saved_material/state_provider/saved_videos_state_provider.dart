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

import '../../../../videos/videos_navigator/state/video_state_provider.dart';

class MySavedVideoStateProvider extends MaterialStateRepository with ChangeNotifier {
  User userData;

  MySavedVideoStateProvider() {
    loadCredentialData();
    fetchInitialData();
  }

  // ==========================================================================================
  @override
  String get collectionName => isAcademic ? 'univideos' : 'schvideos';

  // ==========================================================================================

  /// videos

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

  /// List of  Saved videos Ids that we get from the UserInfoStateProvider
  List<String> _savedVideosIds;

  List<String> get savedVideosIds => _savedVideosIds;

  // ===============================================================================================================

  /// List of already fetched saved Videos
  List<StudyMaterial> _savedVideos = [];

  List<StudyMaterial> get savedVideos => _savedVideos;

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

  /// this method is for Initial Fetching of Saved videos
  @override
  Future<void> fetchInitialData() async {
    _failedInitialFetch = null;

    if (_savedVideosIds.isEmpty) {
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

  // this method is for Pagination Fetching of Saved videos
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

    List<StudyMaterial> fetchedVideos = getFetchedMaterialsFromResponse(response);
    if (_endOfResults || _savedVideos.isEmpty) {
      _savedVideos = fetchedVideos;
    } else {
      _savedVideos.addAll(fetchedVideos);
    }
    _endOfResults = _savedVideos.length == _savedVideosIds.length || (fetchedVideos.isEmpty && fetchingType == FetchingType.PAGINATION);
  }

  // ===============================================================================================================

  /// this method is called when any fetching process succeed;
  void _onFetchFailure(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failedInitialFetch = true;
      _failureMessage = HelperFucntions.getFailureMessage(response, 'videos', true);
      return;
    }
    _failedPagination = true;
    _failureMessage = 'Failed to load more videos';
  }

  // ===============================================================================================================
  /// to know whether we have  ids that are not fetched yet

  bool get anymoreFetch => _savedVideosIds.isNotEmpty;

// ===============================================================================================================

  /// this method return the fetching params which are (collection , list of ids) respectivly
  List<String> _getFetchingParams({bool isRefreshing = false}) {
    List<String> ids;

    if (isRefreshing) {
      final List<String> fetchedIds = _savedVideos.map<String>((video) => video.id).toList();
      ids = _savedVideosIds.where((id) => !fetchedIds.contains(id)).toList();
      return ids;
    }

    final int unfetchedCount = _savedVideosIds.sublist(_savedVideos.length).length;
    final int endIndex = _savedVideos.length + (unfetchedCount > 7 ? 7 : unfetchedCount);
    ids = _savedVideosIds.sublist(_savedVideos.length, endIndex);

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
      _savedVideos.addAll(data);
      notifyMyListeners();
    }
  }

  // ===============================================================================================================

  @override
  void appendToMaterialsOnRefreshFrom(List<StudyMaterial> data) {
    if (data.isNotEmpty) {
      _savedVideos.insertAll(0, data);
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
    _savedVideosIds = userData.savedVideos ?? [];
  }

  // ===============================================================================================================
  /// getter of fetched videos
  @override
  List<StudyMaterial> get materials => _savedVideos;

  // ===============================================================================================================

  /// called when the user tap on the bookmark button which indicate unsaving cause the unsaved one get removed
  /// and not appear in the saved list
  @override
  Future<void> onMaterialSaving(int pos) async {
    String id = _savedVideos[pos].id;
    removeMaterialAt(pos);
    await locator<VideoStateProvider>().onMaterialSavingFromExternal(id);
    if (_savedVideos.isEmpty) {
      fetchInitialData();
      return;
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
    List<String> idsList = _getFetchingParams(isRefreshing: true);
    print('video refresh');
    if (idsList.isEmpty) {
      print('video refresh');
      showSnackBar('There are no more saved videos to load', seconds: 5);
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
    final String _message = response is NoInternetConnection ? 'No internet connection' : 'Failed to refresh!';
    showSnackBar(_message, seconds: 5);
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
    _savedVideos[pos].comments.removeWhere((comment) => comment == id);
    locator<VideoStateProvider>().removeFromComments(id, pos);
    notifyMyListeners();
  }

// ===============================================================================================================
  @override
  void removeMaterialAt(int pos) {
    _savedVideos.removeAt(pos);
    notifyMyListeners();
  }

  @override
  void replaceMaterialWith(StudyMaterial newMaterial) {
    final int index = _savedVideos.indexWhere((element) => element.id == newMaterial.id);
    if (index > -1) {
      _savedVideos[index] = newMaterial;
      notifyMyListeners();
    }
  }
}
