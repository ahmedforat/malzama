import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';

import '../../../../core/platform/local_database/access_objects/teacher_access_object.dart';
import '../../../../core/platform/local_database/models/uploaded_pdf_and_video_model.dart';


class MyMaterialStateProvider with ChangeNotifier {
DialogService dialogService;
  List<UploadedPDF> _myPDFs = [];
  List<UploadedVideo> _myVideos = [];


  List<UploadedPDF> get myPDFs => _myPDFs;
  List<UploadedVideo> get myVideos => _myVideos;

  MyMaterialStateProvider(){
    fetchMyPDFsFromDB();
    fetchMyVideosFromDB();
     dialogService = locator.get<DialogService>();
    dialogService.myMaterialStateProvider = this;
  }

  Future<void> fetchMyPDFsFromDB()async{
    print('fetching PDFS from local db');
    _myPDFs = await TeacherAccessObject().fetchAllPDFS();
    if(_myPDFs == null){
      _myPDFs = [];
    }
    print(_myPDFs.length);
    notifyListeners();
  }

  Future<void> fetchMyVideosFromDB()async{
    print('fetching Videos from local db');
    _myVideos = await TeacherAccessObject().fetchAllVideos();
    if(_myVideos == null){
      _myVideos = [];
    }
    print(_myVideos.length);
    notifyListeners();
  }

}

