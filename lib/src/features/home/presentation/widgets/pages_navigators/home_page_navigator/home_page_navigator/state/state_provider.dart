import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/local_caches/cached_user_info.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:http/http.dart' as http;

class DisplayHomePageStateProvider<P extends BaseUploadingModel> extends BaseStateProvider  {
  DisplayHomePageStateProvider() {
    setIsFetchingTo(true);
    fetchPDFs();
  }

  void setState(){
    notifyListeners();
  }
  
  List<P> _myPDFs;
  int _myPDFSCount = -1;

  List<P> get myPDFS => _myPDFs;

  int get myPDFSCount => _myPDFSCount;

  void appendToPDFS(P update) {
    if (update != null) {
      _myPDFs.add(update);
      notifyListeners();
    }
  }


  bool _isFetching = false;

  bool get isFetching => _isFetching;


  void setIsFetchingTo(bool update) {
    if (update != null && _isFetching != update) {
      _isFetching = update;
      notifyListeners();
    }
  }

  void _onFetchingFailed(){
    _myPDFs = [];
    _myPDFSCount = -1;
    setIsFetchingTo(false);
  }

  Future<void> fetchPDFs() async {
    print('fetching ......');
    final String accountType = await UserCachedInfo().getRecord('account_type');
    http.Response response;

    // url
    final String url = Api.fetchMaterialUrlFor(accountType: accountType, materialType: 'lectures');

    // headers
    Map<String, String> _headers = {
      'authorization': await CachingServices.getField(key: 'token'),
      'Accept': 'application/json',
    };

    try {
      response = await http.get(Uri.encodeFull(url), headers: _headers).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        var lecturesData = json.decode(response.body);
        if (lecturesData.length == 0) {
         if(_myPDFs == null || _myPDFs.length == 0){
            _myPDFs = [];
         }
          _myPDFSCount = _myPDFs.length;
          setIsFetchingTo(false);
          notifyListeners();

          return;
        }
        print(lecturesData);
        _myPDFs = [];
        lecturesData.forEach(
          (item) {
            _myPDFs.add(HelperFucntions.isAcademic(accountType) ? CollegeUploadedPDF.fromJSON(item) : SchoolUploadedPDF.fromJSON(item));
          },
        );
        print(_myPDFs);
        _myPDFSCount = _myPDFs.length;
        setIsFetchingTo(false);
        notifyListeners();
      }else{
       _onFetchingFailed();
      }
    } on TimeoutException {
      _onFetchingFailed();
      print('req timout');
    } catch (err) {
      _onFetchingFailed();
      print('error while fetching material for the home page');
      print(err);
    }

    @override
    void dispose() {
      print('We are disposed fuck ');
      super.dispose();
    }
  }

  @override
  List<BaseUploadingModel> get materialItems => _myPDFs;
}
