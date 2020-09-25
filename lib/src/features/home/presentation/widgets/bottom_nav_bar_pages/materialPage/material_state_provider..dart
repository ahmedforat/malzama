

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/teacher_access_object.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/core/references/references.dart';

class MaterialStateProvider<PDF extends BaseUploadingModel,VIDEO extends BaseUploadingModel> with ChangeNotifier {
  Map<String,dynamic> userDataMap;
  String account_type;
  Future<void> _loadUserData() async {
    print('loading user data');
     userDataMap = await FileSystemServices.getUserData();
     account_type = this.userDataMap['account_type'];
    notifyListeners();
  }

  MaterialStateProvider(){
    _loadUserData();
    fetchMyPDFsFromDB();
    fetchMyVideosFromDB();
  }

  var _myPDFs = [];
  var _myVideos = [];


   get myPDFs => _myPDFs;
  get myVideos => _myVideos;



  Future<void> fetchMyPDFsFromDB()async{
    print('fetching PDFS from local db');
    var data = await TeacherAccessObject().fetchAllPDFS<PDF>();
    if(HelperFucntions.isAcademic(account_type)){
      _myPDFs = List<CollegeUploadedPDF>.from(data);
    }else{
      _myPDFs = List<SchoolUploadedPDF>.from(data);
    }

    if(_myPDFs == null){
      _myPDFs = [];
    }
    print(_myPDFs.length);
    notifyListeners();
  }

  Future<void> fetchMyVideosFromDB<VIDEO>()async{
    print('fetching Videos from local db');
    var data  = await TeacherAccessObject().fetchAllVideos();

    if(HelperFucntions.isAcademic(account_type)){
      _myVideos = List<CollegeUploadedVideo>.from(data);
    }else{
      _myVideos = List<SchoolUploadedVideo>.from(data);
    }
    if(_myVideos == null){
      _myVideos = [];
    }
    print(_myVideos.length);
    notifyListeners();
  }


  @override
  void dispose() {
    print('MaterialStateProvider has been disposed');
    super.dispose();
  }

}