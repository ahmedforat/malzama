import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/api/contract_response.dart';
import '../../../../../../../../core/api/http_methods.dart';
import '../../../../../../../../core/api/routes.dart';
import '../../../../../../../../core/functions/material_functions.dart';
import '../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import '../../../../../../../../core/platform/services/dialog_services/dialog_service.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../state_provider/user_info_provider.dart';
import '../../material_state_provider..dart';
import '../quiz_collection_model.dart';

class QuizDisplayerStateProvider with ChangeNotifier {
  bool _isDisposed = false;
  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  QuizDisplayerStateProvider() {
    startInitializeFetching();
  }

  // =============================================================================
  // failed initialFetching
  bool _failedToFetchQuizes = false;

  bool get failedToFetchQuizes => _failedToFetchQuizes;

  void setFailedToFetchQuizesTo(bool update) {
    _failedToFetchQuizes = update;
    notifyMyListeners();
  }

  // =============================================================================

  // =============================================================================
  // failed initialFetching
  bool _failedToPaginateQuizes = false;

  bool get failedToPaginateQuizes => _failedToPaginateQuizes;

  void setFailedToPaginateQuizes(bool update) {
    _failedToPaginateQuizes = update;
    notifyMyListeners();
  }

  // =============================================================================

  // =============================================================================
  // for initial fetching
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    if (update != null) {
      _isFetching = update;
      notifyMyListeners();
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
      notifyMyListeners();
    }
  }

  bool _endOfResults = false;

  bool get endOfResult => _endOfResults;

  // =============================================================================

  // =============================================================================
// quizCollections
  List<QuizCollection> _quizCollections = [];

  List<QuizCollection> get quizCollections => _quizCollections;

  void appendToQuizCollections(QuizCollection collection) {
    if (collection != null) {
      _quizCollections.add(collection);
      notifyMyListeners();
    }
  }

  // =============================================================================

  // =============================================================================
  // NetWorking

  // basic fetching method
  Future<ContractResponse> _fetchQuizCollections({String id}) async {
    String url = Api.FETCH_QUIZES_HEADERS;

    url += '?idFactor=$id';

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
    ContractResponse response = await _fetchQuizCollections(id: quizCollections.last.id);
    if (response is Success) {
      _failedToPaginateQuizes = false;
      var responseBody = json.decode(response.message);
      if (responseBody.length == 0) {
        _endOfResults = true;
      } else {
        List<QuizCollection> newFetchedCollections = responseBody.map<QuizCollection>((item) => new QuizCollection.fromJSON(item)).toList();
        _quizCollections.addAll(newFetchedCollections);
      }
    } else {
      _failedToPaginateQuizes = true;
      ;
    }
    setIsPaginatingTo(false);
  }


  Future<void> deleteQuizCollectionAt(BuildContext context,int pos)async{
    Navigator.of(context).pop();
    await Future.delayed(Duration(milliseconds: 230));
    locator<DialogService>().showDialogOfLoading(message: 'deleting');
    final String id = _quizCollections[pos].id;
    UserInfoStateProvider userInfo = Provider.of<UserInfoStateProvider>(context,listen:false);
    final String collectionName = HelperFucntions.isAcademic(userInfo.userData.accountType) ? 'uniquizes' : 'schquizes';

    ContractResponse contractResponse = await MaterialFunctions.deleteMaterial(id: id, collectionName: collectionName);
    if(contractResponse is Success){
      print('deleted');
      await QuizAccessObject().deleteUploadedMaterial(MyUploaded.QUIZES,id: id);
      _quizCollections.removeAt(pos);
      MaterialStateProvider stateProvider = Provider.of<MaterialStateProvider>(context,listen:false);
      await stateProvider.fetchMyQuizesFromDB();
      notifyMyListeners();
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfSuccess(message: 'quiz collection deleted succesfully');

    }else{
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfFailure(message: 'Failed to delete quiz collection!');
    }

  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
