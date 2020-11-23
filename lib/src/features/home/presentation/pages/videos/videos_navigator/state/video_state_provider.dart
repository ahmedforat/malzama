import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';

import '../../../../../../../core/api/api_client/clients/video_and_pdf_client.dart';
import '../../../../../../../core/api/contract_response.dart';
import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../core/platform/local_database/local_caches/cached_user_info.dart';
import '../../../../../../../core/references/references.dart';
import '../../../../../models/materials/study_material.dart';

class VideoStateProvider with ChangeNotifier implements MaterialStateRepo {

  VideoStateProvider(){
    loadCredentialData();
  }
  List<StudyMaterial> _videosList = [];

  List<StudyMaterial> get materials => _videosList;

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
    var accountType = await UserCachedInfo().getRecord('account_type');
    _isAcademic = HelperFucntions.isAcademic(accountType);
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    _failureOfInitialFetch = false;
    setIsFetchingTo(true);
    var collectionName = _isAcademic ? 'univideos' : 'schvideos';
    ContractResponse response = await VideosAndPDFClient().fetch(collectionName: collectionName, idFactor: null);
    if (response is Success) {
      List responseBody = json.decode(response.message);
      if (responseBody.isNotEmpty) {
        appendToMaterialsFrom(responseBody);
      }
    }else{
      _failureOfInitialFetch = true;
    }
    setIsFetchingTo(false);
  }

  Future<void> fetchForPagination() async {
    _isPagintaionFailed = false;
    setIsPaginatingTo(true);
    var collectionName = _isAcademic ? 'univideos' : 'schvideos';
    ContractResponse response = await VideosAndPDFClient().fetch(collectionName: collectionName, idFactor: _videosList.last.id);
    if (response is Success) {
      List responseBody = json.decode(response.message);
      if (responseBody.isNotEmpty) {
        appendToMaterialsFrom(responseBody);
      } else {
        _endOfResults = true;
      }
    } else {
      _isPagintaionFailed = true;
    }

    setIsPaginatingTo(false);
  }

  void appendToMaterialsFrom(List<Map<String, dynamic>> data) {
    data.forEach((element) {
      _videosList.add(References.getProperStudyMaterial(element, isAcademic));
    });
  }


  Future<void> onRefresh()async{
    var collectionName = _isAcademic ? 'univideos' : 'schvideos';
    ContractResponse response = await VideosAndPDFClient().fetch(collectionName: collectionName, idFactor: _videosList.last?.id);
    if(response is Success){
      List data = json.decode(response.message);
      if(data.isNotEmpty){
        appendToMaterialsFrom(data);
        notifyMyListeners();
      }
    }

  }

  // =========================================================================================================


  void appendToComments(String id,int pos){
    _videosList[pos].comments.add(id);
    notifyMyListeners();
  }


  void removeFromComments(String id,int pos){
    _videosList[pos].comments.removeWhere((comment) => comment == id);
    notifyMyListeners();
  }
  // =========================================================================================================
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
}
