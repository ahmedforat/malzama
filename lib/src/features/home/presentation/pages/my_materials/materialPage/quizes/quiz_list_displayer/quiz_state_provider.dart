import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

import '../../../../../../../../core/api/api_client/clients/common_materials_client.dart';
import '../../../../../../../../core/api/api_client/clients/quiz_client.dart';
import '../../../../../../../../core/api/contract_response.dart';
import '../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../models/users/user.dart';
import '../../../../../state_provider/user_info_provider.dart';
import '../quiz_collection_model.dart';

enum FetchingType { INITIAL, PAGINATION }

class QuizStateProvider extends QuizStateRepository with ChangeNotifier {
  QuizStateProvider() {
    loadCredentialData();
    fetchInitialData();
  }

  @override
  void appendToComments(String id, int pos) {
    print('do nothind');
  }

  @override
  void appendToMaterialsFrom(List<QuizCollection> data) {
    if (data.isNotEmpty) {
      _quizCollections.addAll(data);
      notifyMyListeners();
    }
  }

  // =========================================================================================

  bool _endOfResults = false;

  @override
  bool get endOfResults => _endOfResults;

  // =========================================================================================
  // failed initialFetching
  bool _failureOfInitialFetch = false;

  @override
  bool get failureOfInitialFetch => _failureOfInitialFetch;

  // =========================================================================================

  String _failureMessage;

  String get failureMessage => _failureMessage;

  // =========================================================================================

  bool _hasQuizes = false;

  @override
  bool get hasQuizes => _hasQuizes;

  // =========================================================================================

  @override
  Future<void> fetchInitialData() async {
    _failureOfInitialFetch = null;
    setIsFetchingTo(true);
    ContractResponse response = await QuizClient().fetchQuizHeaders();
    if (response is Success) {
      _onFetchingSuccess(response, FetchingType.INITIAL);
    } else {
      _onFetchingFailure(response, FetchingType.INITIAL);
    }
    setIsFetchingTo(false);
  }

  // =========================================================================================

  @override
  Future<void> fetchForPagination() async {
    _isPaginationFailed = null;
    setIsPaginatingTo(true);
    ContractResponse response = await QuizClient().fetchQuizHeaders(idFactor: _quizCollections.last.id);

    if (response is Success) {
      _onFetchingSuccess(response, FetchingType.PAGINATION);
    } else {
      _onFetchingFailure(response, FetchingType.PAGINATION);
    }

    setIsPaginatingTo(false);
  }

  // =========================================================================================

  void _onFetchingSuccess(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failureOfInitialFetch = false;
    } else {
      _isPaginationFailed = false;
    }

    List<QuizCollection> fetchedQuizes = getFetchedDataFromResponse(response);
    if (_endOfResults || _quizCollections.isEmpty) {
      _quizCollections = fetchedQuizes;
    } else {
      _quizCollections.addAll(fetchedQuizes);
    }
    _hasQuizes = _quizCollections.isNotEmpty;
    _endOfResults = fetchedQuizes.length < 10 || fetchedQuizes.isEmpty && fetchingType == FetchingType.PAGINATION;
  }

  // =========================================================================================

  void _onFetchingFailure(ContractResponse response, FetchingType fetchingType) {
    if (fetchingType == FetchingType.INITIAL) {
      _failureOfInitialFetch = true;
      _failureMessage = HelperFucntions.getFailureMessage(response, 'quizes', false);
      _hasQuizes = _quizCollections.isNotEmpty;
      return;
    }
    _isPaginationFailed = true;
    _failureMessage = 'Failed to Load quizes';
  }

  // =========================================================================================

  User userData;

  @override
  bool get isAcademic => userData.isAcademic;

// =========================================================================================

  // for initial fetching of quizes
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    if (update != null) {
      _isFetching = update;
      notifyMyListeners();
    }
  }

  // =========================================================================================

  // for pagination
  bool _isPaginating = false;

  bool get isPaginating => _isPaginating;

  void setIsPaginatingTo(bool update) {
    if (update != null) {
      _isPaginating = update;
      notifyMyListeners();
    }
  }

  // =========================================================================================

  // failed initialFetching
  bool _isPaginationFailed = false;

  @override
  bool get isPaginationFailed => _isPaginationFailed;

// =========================================================================================

  @override
  Future<void> loadCredentialData() async {
    userData = locator<UserInfoStateProvider>().userData;
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

// =========================================================================================
// quizCollections
  List<QuizCollection> _quizCollections = [];

  @override
  List<QuizCollection> get materials => _quizCollections;

  // =========================================================================================

  @override
  Future<void> onMaterialSaving(int pos) async {
    final String id = _quizCollections[pos].id;
    _quizCollections[pos].isSaved = !_quizCollections[pos].isSaved;
    final String indicator = _quizCollections[pos].isSaved ? 'add' : 'pull';
    notifyMyListeners();
    ContractResponse response = await CommonMaterialClient().saveMaterial(
      id: id,
      indicator: indicator,
      fieldName: 'saved_quizes',
    );

    if (response is Success) {
      if (indicator == 'pull') {
        locator<UserInfoStateProvider>().userData.savedQuizes.remove(id);
      } else {
        locator<UserInfoStateProvider>().userData.savedQuizes.add(id);
      }
      await locator<UserInfoStateProvider>().updateUserInfo();
      locator<UserInfoStateProvider>().notifyMyListeners();
      _hasQuizes = _quizCollections.isNotEmpty;
      notifyMyListeners();
    }
  }

  // =========================================================================================

  @override
  Future<void> onMaterialSavingFromExternal(String id) async {
    print('do nothing');
  }

  // =========================================================================================

  @override
  Future<void> onRefresh() async {
    ContractResponse response = await QuizClient().fetchQuizHeaders(idFactor: _quizCollections.first.id);
    if (response is Success) {
      List<QuizCollection> fetchedQuizes = getFetchedDataFromResponse(response);
      appendToMaterialsOnRefreshFrom(fetchedQuizes);
      return;
    }
    final String errorMessage = response is NoInternetConnection ? 'No internet connection' : 'Failed to load more quizes';
    showSnackBar(errorMessage, seconds: 5);
  }

  // =========================================================================================

  @override
  void removeFromComments(String id, int pos) {
    print('do nothing');
  }

  // =========================================================================================

  void updateMaterialAt(int pos, QuizCollection update) {
    _quizCollections[pos] = new QuizCollection.fromJSON({...update.toJSON()});
    notifyMyListeners();
  }

  void updateMaterialById(QuizCollection update) {
    final int index = _quizCollections.indexWhere((element) => element.id == update.id);
    if (index > 0) {
      _quizCollections[index] = update;
      notifyMyListeners();
    }
  }

  // =========================================================================================

  @override
  void removeMaterialAt(int pos) {
    _quizCollections.removeAt(pos);
    _hasQuizes = _quizCollections.isNotEmpty;
    notifyMyListeners();

    // if (_quizCollections.isEmpty) {
    //   fetchInitialData();
    //   return;
    // }
  }

  // =========================================================================================

  /// Scaffold Key for Snack bar display and other tasks
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // =========================================================================================
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

  // =========================================================================================
  /// Change Notifier State Provider related
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

  @override
  void appendToMaterialsOnRefreshFrom(List<QuizCollection> data) {
    if (data.isNotEmpty) {
      _quizCollections.insertAll(0, data);
      _hasQuizes = _quizCollections.isNotEmpty;
      notifyMyListeners();
    }
  }

// =========================================================================================

  void updateQuizItemInCollection(String collectionId, int itemIndex, QuizEntity entity) {
    final int index = _quizCollections.indexWhere((element) => element.id == collectionId);
    if (index > 0) {
      _quizCollections[index].quizItems[itemIndex] = _quizCollections[index].quizItems[itemIndex].copyWith(entity);
      notifyMyListeners();
    }
  }
}
