import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';

import '../../../../core/platform/local_database/access_objects/teacher_access_object.dart';



class MyMaterialStateProvider<PDF extends BaseUploadingModel,VIDEO extends BaseUploadingModel> with ChangeNotifier {
DialogService dialogService;
  List<PDF> _myPDFs = [];
  List<VIDEO> _myVideos = [];


  List<PDF> get myPDFs => _myPDFs;
  List<VIDEO> get myVideos => _myVideos;

  MyMaterialStateProvider(){
    fetchMyPDFsFromDB();
    fetchMyVideosFromDB();
     dialogService = locator.get<DialogService>();
    dialogService.myMaterialStateProvider = this;
  }

  Future<void> fetchMyPDFsFromDB()async{
    print('fetching PDFS from local db');
    _myPDFs = await TeacherAccessObject().fetchAllPDFS<PDF>();
    if(_myPDFs == null){
      _myPDFs = [];
    }
    print(_myPDFs.length);
    notifyListeners();
  }

  Future<void> fetchMyVideosFromDB<VIDEO>()async{
    print('fetching Videos from local db');
    _myVideos = await TeacherAccessObject().fetchAllVideos();
    if(_myVideos == null){
      _myVideos = [];
    }
    print(_myVideos.length);
    notifyListeners();
  }

}

