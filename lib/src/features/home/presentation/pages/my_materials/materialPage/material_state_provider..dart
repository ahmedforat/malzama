import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/functions/material_functions.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/teacher_access_object.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_collection_model.dart';

class MaterialStateProvider with ChangeNotifier {
  User userDataMap;
  String account_type;

  Future<void> _loadUserData() async {
    print('loading user data');
    userDataMap = await FileSystemServices.getUserData();
    account_type = this.userDataMap.accountType;
    notifyMyListeners();
  }

  MaterialStateProvider() {
    _loadUserData();
    fetchMyPDFsFromDB();
    fetchMyVideosFromDB();
    fetchMyQuizesFromDB();
  }

  List<StudyMaterial> _myPDFs = [];
  List<StudyMaterial> _myVideos = [];
  List<QuizCollection> _myQuizes = [];

  get myPDFs => _myPDFs;

  get myVideos => _myVideos;

  List<QuizCollection> get myQuizes => _myQuizes;

  // ===============================================================================================
  // fetching indicators

  // for quizes
  bool _isFetchingQuizes = false;

  bool get isFetchingQuizes => _isFetchingQuizes;

  void setIsFetchingQuizesTo(bool update) {
    if (update != null) {
      _isFetchingQuizes = update;
      notifyMyListeners();
    }
  }

  // for PDFS
  bool _isFetchingPDFs = false;

  bool get isFetchingPDFs => _isFetchingPDFs;

  void setIsFetchingPDFsTo(bool update) {
    if (update != null) {
      _isFetchingPDFs = update;
      notifyMyListeners();
    }
  }

  // for Videos
  bool _isFetchingVideos = false;

  bool get isFetchingVideos => _isFetchingVideos;

  void setIsFetchingVideosTo(bool update) {
    if (update != null) {
      _isFetchingVideos = update;
      notifyMyListeners();
    }
  }

  // ===============================================================================================

  Future<void> fetchMyPDFsFromDB() async {
    print('fetching PDFS from local db');
    setIsFetchingPDFsTo(true);
    _myPDFs = await TeacherAccessObject().fetchAllPDFS();

    if (_myPDFs == null) {
      _myPDFs = [];
    }
    print(_myPDFs.length);
    setIsFetchingPDFsTo(false);
  }

  Future<void> fetchMyVideosFromDB<VIDEO>() async {
    print('fetching Videos from local db');
    setIsFetchingVideosTo(true);
    _myVideos = await TeacherAccessObject().fetchAllVideos();

    if (_myVideos == null) {
      _myVideos = [];
    }
    print(_myVideos.length);
    setIsFetchingVideosTo(false);
  }

  Future<void> fetchMyQuizesFromDB() async {
    print('updating. . .....');
    setIsFetchingQuizesTo(true);
    var res = await QuizAccessObject().getUploadedMaterials(MyUploaded.QUIZES);
    print('==========================================');
    print(res);
    print('==========================================');
    var quizes = res.map<QuizCollection>((e) => new QuizCollection.fromJSON(e)).toList();

    _myQuizes = quizes;
    setIsFetchingQuizesTo(false);
  }

  Future<bool> deleteMaterialAt(BuildContext context, int pos,String materialType) async {

    ContractResponse contractResponse = await MaterialFunctions.deleteMaterial(
      id: null,
      collectionName: null,
      materialType: materialType,
    );
    return contractResponse is Success;
  }

  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('MaterialStateProvider has been disposed');
    super.dispose();
  }
}
