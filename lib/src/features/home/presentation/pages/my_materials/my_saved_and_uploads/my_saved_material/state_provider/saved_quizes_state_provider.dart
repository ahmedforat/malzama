import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_collection_model.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

import '../../../../../../../../core/api/api_client/clients/common_materials_client.dart';
import '../../../../../../../../core/api/api_client/clients/quiz_client.dart';
import '../../../../../../../../core/api/api_client/clients/video_and_pdf_client.dart';
import '../../../../../../../../core/api/contract_response.dart';
import '../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../models/users/user.dart';
import '../../../../../state_provider/user_info_provider.dart';


class MySavedQuizStateProvider extends QuizStateRepository with ChangeNotifier {
  User userData;

  MySavedQuizStateProvider() {
    loadCredentialData();
    fetchInitialData();
  }

  // ==========================================================================================
  String get collectionName => isAcademic ? 'uniquizes' : 'schquizes';

  // ==========================================================================================

  bool _hasQuizes = false;

  @override
  bool get hasQuizes => _hasQuizes;

  // ==========================================================================================

  /// Quizes

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

  bool _isPaginationFailed = false;

  bool get isPaginationFailed => _isPaginationFailed;

  // ===============================================================================================================

  /// List of  Saved Quizes Ids that we get from the UserInfoStateProvider
  List<String> _savedQuizesIds;

  List<String> get savedQuizesIds => _savedQuizesIds;

  // ===============================================================================================================

  /// List of already fetched saved Quizes
  List<QuizCollection> _savedQuizes = [];

  List<QuizCollection> get savedQuizes => _savedQuizes;

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

  /// this method is for Initial Fetching of Saved quizes
  @override
  Future<void> fetchInitialData() async {
    _savedQuizes = [];
    _failedInitialFetch = null;
    setIsFetchingTo(true);
    if (_savedQuizesIds.isEmpty) {
      _failedInitialFetch = false;
      _hasQuizes = false;
      setIsFetchingTo(false);
      return;
    }

    List<String> idsList = _getFetchingParams();

    ContractResponse response = await QuizClient().fetchSavedQuizesHeaders(
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

  // this method is for Pagination Fetching of Saved Quizes
  @override
  Future<void> fetchForPagination() async {
    _isPaginationFailed = null;
    setIsPaginatingTo(true);
    List<String> idsList = _getFetchingParams();
    if (idsList.isEmpty) {
      _isPaginationFailed = false;
      _endOfResults = true;
      setIsPaginatingTo(false);
    }
    ContractResponse response = await QuizClient().fetchSavedQuizesHeaders(
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
      _isPaginationFailed = false;
    }
    List<QuizCollection> fetchedQuizes = getFetchedDataFromResponse(response);
    if (_endOfResults || _savedQuizes.isEmpty) {
      _savedQuizes = fetchedQuizes;
    } else {
      _savedQuizes.addAll(fetchedQuizes);
    }
    _hasQuizes = _savedQuizes.isNotEmpty;
    _endOfResults = _savedQuizes.length == _savedQuizesIds.length || (fetchedQuizes.isEmpty && fetchingType == FetchingType.PAGINATION);
  }

  // ===============================================================================================================

  /// this method is called when any fetching process succeed;
  void _onFetchFailure(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failedInitialFetch = true;
      _failureMessage = HelperFucntions.getFailureMessage(response, 'quizes', true);
      return;
    }
    _isPaginationFailed = true;
    _failureMessage = 'Failed to load more quizes';
  }

  // ===============================================================================================================
  /// to know whether we have  ids that are not fetched yet

  bool get anymoreFetch => _savedQuizesIds.isNotEmpty;

// ===============================================================================================================

  /// this method return the fetching params which are (collection , list of ids) respectivly
  List<String> _getFetchingParams({bool isRefreshing = false}) {
    List<String> ids;

    if (isRefreshing) {
      final List<String> fetchedIds = _savedQuizes.map<String>((quiz) => quiz.id).toList();
      ids = _savedQuizesIds.where((id) => !fetchedIds.contains(id)).toList();
      return ids;
    }

    final int unfetchedCount = _savedQuizesIds.sublist(_savedQuizes.length).length;
    final int endIndex = _savedQuizes.length + (unfetchedCount > 7 ? 7 : unfetchedCount);
    ids = _savedQuizesIds.sublist(_savedQuizes.length, endIndex);

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
    print('nothing');
  }

  // ===============================================================================================================

  /// append To Materials from list of studyMaterial
  @override
  void appendToMaterialsFrom(List<QuizCollection> data) {
    if (data.isNotEmpty) {
      _savedQuizes.addAll(data);
      notifyMyListeners();
    }
  }

  // ===============================================================================================================

  @override
  void appendToMaterialsOnRefreshFrom(List<QuizCollection> data) {
    if (data.isNotEmpty) {
      _savedQuizes.insertAll(0, data);
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
    _savedQuizesIds = userData.savedQuizes ?? [];
  }

  // ===============================================================================================================
  /// getter of fetched Quizes
  @override
  List<QuizCollection> get materials => _savedQuizes;

  // ===============================================================================================================

  /// called when the user tap on the bookmark button which indicate unsaving cause the unsaved one get removed
  /// and not appear in the saved list
  @override
  Future<void> onMaterialSaving(int pos) async {
    String id = _savedQuizes[pos].id;
    removeMaterialAt(pos);
    _savedQuizesIds.remove(id);

    ContractResponse response = await CommonMaterialClient().saveMaterial(
      id: id,
      fieldName: 'saved_quizes',
      indicator: 'pull',
    );

    if (response is Success) {
      showSnackBar('removed from saved items');
      locator<UserInfoStateProvider>().userData.savedQuizes.remove(id);
      locator<UserInfoStateProvider>().notifyMyListeners();
      if (_savedQuizes.isEmpty) {
        _savedQuizesIds = locator<UserInfoStateProvider>().userData.savedQuizes;
        fetchInitialData();
      }
    }
    // locator<Q>().onMaterialSavingFromExternal(id);
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
    ContractResponse response = await VideosAndPDFClient().fetchSavedMaterials(
      collection: collectionName,
      ids: idsList,
    );

    if (response is Success) {
      List<QuizCollection> fetchedData = getFetchedDataFromResponse(response);
      appendToMaterialsFrom(fetchedData);
      return;
    }
    final String message = response is NoInternetConnection ? 'No internet connection' : 'Failed to load quizes';
    showSnackBar(message, seconds: 5);
  }

  // ===============================================================================================================
  // show snack bar
  bool _isSnackBarVisible = false;

  @override
  Future<void> showSnackBar(String message, {int seconds}) async {
    if (_isSnackBarVisible || _isDisposed) {
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
    print('nothing');
  }

// ===============================================================================================================
  @override
  void removeMaterialAt(int pos) {
    _savedQuizes.removeAt(pos);
    notifyMyListeners();
  }
}
