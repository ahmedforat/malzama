import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_collection_model.dart';

class QuizDisplayerStateProvider with ChangeNotifier {
  QuizDisplayerStateProvider() {
    startInitializeFetching();
  }

  // =============================================================================
  // failed initialFetching
  bool _failedToFetchQuizes = false;

  bool get failedToFetchQuizes => _failedToFetchQuizes;

  void setFailedToFetchQuizesTo(bool update) {
    _failedToFetchQuizes = update;
    notifyListeners();
  }

  // =============================================================================

  // =============================================================================
  // failed initialFetching
  bool _failedToPaginateQuizes = false;

  bool get failedToPaginateQuizes => _failedToPaginateQuizes;

  void setFailedToPaginateQuizes(bool update) {
    _failedToPaginateQuizes = update;
    notifyListeners();
  }

  // =============================================================================

  // =============================================================================
  // for initial fetching
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    if (update != null) {
      _isFetching = update;
      notifyListeners();
    }
  }

  // =============================================================================

  // =============================================================================
  // for pagination
  bool _isPaginating = false;

  bool get isPaginating => _isPaginating;

  void setIsPaginatingTo(bool update) {
    if (update != null) {
      _isPaginating = update;
      notifyListeners();
    }
  }

  // =============================================================================

  // =============================================================================
// quizCollections
  List<QuizCollection> _quizCollections = [];

  List<QuizCollection> get quizCollections => _quizCollections;

  void appendToQuizCollections(QuizCollection collection) {
    if (collection != null) {
      _quizCollections.add(collection);
      notifyListeners();
    }
  }

  // =============================================================================

  // =============================================================================
  // NetWorking

  // basic fetching method
  Future<ContractResponse> _fetchQuizCollections({String postDate}) async {
    String url = Api.FETCH_QUIZES_HEADERS;

    url += '?post_date=$postDate';

    ContractResponse contractResponse = await HttpMethods.get(url: url);
    return contractResponse;
  }

  // initial Fetching ...
  Future<void> startInitializeFetching() async {
    setIsFetchingTo(true);
    ContractResponse response = await _fetchQuizCollections();
    if (response is Success) {
      _failedToFetchQuizes = false;
      var responseBody = json.decode(response.message);
      print('=================================================');
      print(responseBody);
      print('=================================================');

      _quizCollections = responseBody.map<QuizCollection>((item) => new QuizCollection.fromJSON(item)).toList();
    } else {
      _failedToFetchQuizes = true;
    }
    setIsFetchingTo(false);
  }

  // pagination fetching
  Future<void> startPaginationFetching() async {
    setIsPaginatingTo(true);
    ContractResponse response = await _fetchQuizCollections(postDate: quizCollections.last.postDate);
    if (response is Success) {
      _failedToPaginateQuizes = false;
      var responseBody = json.decode(response.message);
      List<QuizCollection> newFetchedCollections = responseBody.map((item) => new QuizCollection.fromJSON(item)).toList();
      _quizCollections.addAll(newFetchedCollections);
    } else {
      _failedToPaginateQuizes = true;
      ;
    }
    setIsPaginatingTo(false);
  }
}
