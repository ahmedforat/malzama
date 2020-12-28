import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../../../core/platform/services/file_system_services.dart';
import '../../../../../../models/materials/study_material.dart';
import '../../../../../state_provider/user_info_provider.dart';
import '../../../../lectures_pages/state/pdf_state_provider.dart';

class PDFPlayerStateProvider with ChangeNotifier {
  // ======================================================================================
  // failed to load file
  bool _failedToLoad = false;

  bool get failedToLoad => _failedToLoad;

  // ======================================================================================

  /// is loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setIsLoadingTo(bool update) {
    _isLoading = update;
    notifyMyListeners();
  }

  // ======================================================================================
  // file as bytes
  List<int> _fileBytes = [];

// ======================================================================================
  /// progress of fetching
  double _progress = 0.0;

  double get progress => _progress;

  // ======================================================================================

  StudyMaterial _studyMaterial;

  StudyMaterial get studyMaterial => _studyMaterial;

  // ======================================================================================

  /// the path of the file
  String _path;

  String get path => _path;

  // ======================================================================================

  /// whether the file is to be fetched from the local storage or from the cloud
  bool _fromClound;

  bool get fromCloud => _fromClound;

  // ======================================================================================

  // pdf file size
  int _size;

  int get size => _size;

  // ======================================================================================

  // pdf loadedSize
  int _loadedSize;

  int get loadedSize => _loadedSize;

  // ======================================================================================

  // constructor
  PDFPlayerStateProvider(BuildContext context,int pos, {bool isUploaded = false}) {

    if(!isUploaded){
      print('T is PDFStateProvider}');
      _studyMaterial = Provider.of<PDFStateProvider>(context,listen: false).materials[pos];
    }else{
      print('T is MyUploadsStateProvider');
      _studyMaterial = Provider.of<MyUploadsStateProvider>(context,listen: false).uploadedLectures[pos];
    }

    print('inside constuctor===============================================================');
    print('\n\n\n\n\n\n\n\n');
    print(_studyMaterial.toJSON());
    print('\n\n\n\n\n\n\n\n');
    print('inside constuctor===============================================================');
    _size = _studyMaterial.size;
    initialize();
  }

  // ======================================================================================

  void initialize() async {
    setIsLoadingTo(true);
    String tempPath = await getCachedFilePath();
    if(tempPath != null){
      _path = tempPath;
      print('opening from the cached file path');
      setIsLoadingTo(false);
      return;
    }
    tempPath = await getMyLocalPath();
    if(tempPath != null){
      _path = tempPath;
      print('opening from the local file path');
      setIsLoadingTo(false);
      return;
    }
    print('fetching from the cloud');
    fetchFileFromCloud();

  }

  // ======================================================================================

  Future<void> fetchFileFromCloud() async {
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(studyMaterial.src));
    HttpClientResponse response = await request.close();

    response.listen(
      (chunk) {
        //print(chunk);
        if (_isDisposed) {
          return;
        }
        _fileBytes.addAll(chunk);
        //print('fetched size ${_fileBytes.length}');
        print('Round ======================================');
        print('loaded = ${_fileBytes.length}');
        print('total = $_size');
        _progress = double.parse((_fileBytes.length / _size).toStringAsFixed(2));
        print('Progress = $_progress');
        print('============================================');
        notifyMyListeners();
      },
      onDone: () async {
        print('On Done fetchig');
        if (_isDisposed) {
          print('processed killed');
          return;
        }

        final String ext = getFileExtenstion(studyMaterial.src);
        FileSystemServices.cacheFileToLocalStorage(bytes: _fileBytes, id: studyMaterial.id, ext: ext).then((value) {
          if (value != null) {
            _path = value;
          } else {
            _failedToLoad = true;
          }
          setIsLoadingTo(false);
        });
      },
      onError: () {
        print('=========================================================> Failure');
        _failedToLoad = true;
        setIsLoadingTo(false);
      },
      cancelOnError: true,
    );
  }

  // ======================================================================================

  /// return the file extension
  static String getFileExtenstion(String filePath) {
    final String path = filePath.split('?').first;
    return path.split('.').last;
  }

  // ======================================================================================
  Future<String> getCachedFilePath() async {
    final String ext = getFileExtenstion(_studyMaterial.src);
    String cachedFile = await FileSystemServices.isFileCached(id: _studyMaterial.id, ext: ext);
    return cachedFile;
  }

  // ======================================================================================

  Future<String> getMyLocalPath() async {
    final String id = locator<UserInfoStateProvider>().userData.id;
    final bool isMyLecture = id == _studyMaterial.author.id;
    File file = new File(_studyMaterial.localPath);
    return isMyLecture && file.existsSync() ? _studyMaterial.localPath : null;
  }

  // ======================================================================================

  // ======================================================================================

  void notifyMyListeners() {
    print('notifying ....');
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    print('PDFPlayerStateProvider  has been disposed');
    super.dispose();
  }
}

class PDFPayload {
  final bool fromClound;
  final String path;
  final int size;

  PDFPayload({@required this.path, @required this.fromClound, @required this.size});
}
