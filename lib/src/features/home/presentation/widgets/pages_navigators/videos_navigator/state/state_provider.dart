import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/local_caches/cached_user_info.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

class DisplayVideosPageState<T extends BaseUploadingModel> extends BaseStateProvider {
  List<T> _videos;
  int _videosCount;

  List<T> get videos => _videos;

  int get videosCount => _videosCount;

  bool _isFetching = false;

  bool get isFetching => _isFetching;


  void setIsFetchingTo(bool update) {
    if (update != null && _isFetching != update) {
      _isFetching = update;
      notifyListeners();
    }
  }



  DisplayVideosPageState() {
    setIsFetchingTo(true);
    fetchVideos();
  }

  Future<ContractResponse> fetchVideos() async {
    final Map<String, String> headers = {'Accept': 'application/json', 'authorization': await CachingServices.getField(key: 'token')};

    final String accountType = await UserCachedInfo().getRecord('account_type');
    final String url = Api.fetchMaterialUrlFor(accountType: accountType, materialType: 'videos');

    Response response;

    try {

      response = await get(Uri.encodeFull(url), headers: headers).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _videos = [];

      

        if (data != null && data.length != 0) {
          final isAcademic = HelperFucntions.isAcademic(accountType);
          data.forEach((item) {
            _videos.add(isAcademic ? CollegeUploadedVideo.fromJSON(item) : SchoolUploadedVideo.fromJSON(item));
          });
        }

        _videosCount = _videos.length;
        if(isFetching){
          setIsFetchingTo(false);
        }else{
          notifyListeners();
        }
        
      } else {
        _videos = [];
        _videosCount = -1;
         if(isFetching){
          setIsFetchingTo(false);
        }else{
          notifyListeners();
        }
        return InternalServerError();
      }
    } on TimeoutException {
      print('timeout while fetching videos for display');
      _videos = [];
      _videosCount = -1;
      if(isFetching){
          setIsFetchingTo(false);
        }else{
          notifyListeners();
        }
      return ServerNotResponding();
    } catch (err) {
      print(err);
      _videos = [];
      _videosCount = -1;
       if(isFetching){
          setIsFetchingTo(false);
        }else{
          notifyListeners();
        }
      return NewBugException(message: err.toString());
    }
  }

  @override
  List<BaseUploadingModel> get materialItems => _videos;

  @override
  void setState() {
    notifyListeners();
  }
}
