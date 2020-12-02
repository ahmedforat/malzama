import 'dart:convert';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../../core/api/api_client/clients/common_materials_client.dart';
import '../../../../../../../../core/api/contract_response.dart';
import '../../../../../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import '../../../../../../../../core/platform/services/dialog_services/dialog_service.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../../../core/references/references.dart';
import '../../../../../../models/users/college_student.dart';
import '../../../../../../models/users/college_user.dart';
import '../../../../../state_provider/quiz_uploading_state_provider.dart';
import '../../../../../state_provider/user_info_provider.dart';

class CollegeUploadingState extends AbstractStateProvider with ChangeNotifier {
  // scaffold key of the uploading form
  GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool _isSnackBarActive = false;

  // Constructor

  bool _forEditing;

  bool get forEdit => _forEditing;

  bool _keepTheSameUploadedLecture = false;

  bool get keepTheSameUploadedLecture => _keepTheSameUploadedLecture;

  void setKeepTheSameUploadedLectureTo(bool update) {
    _keepTheSameUploadedLecture = update;
    notifyMylisteners();
  }

  void parseDataToBeEdit(Map<String, dynamic> data) {
    _title = data['title'];
    _description = data['description'];
    _stage = int.parse(data['stage'].toString());
    _semester = data['semester'] == null ? null : int.parse(data['semester']);
    _topic = data['topic'];
    if (data['material_type'] == 'video') {
      _videoId = References.getFullYouTubeUrl(data['src']);
    } else {
      File file = new File(data['localPath']);
      if (file.existsSync()) {
        _lectureToUpload = file;
      } else {
        _keepTheSameUploadedLecture = true;
      }
    }
  }

  // the text of the button that gets tapped
  // when the user want to choose the file to upload

  String get uploadButtonText => _lectureToUpload == null
      ? 'Tap Here To Choose File'
      : lectureToUpload.path.split('/').last.length > 40
          ? _lectureToUpload.path.split('/').last.substring(0, 40)
          : _lectureToUpload.path.split('/').last;

  // ========================================================================================

  // =========  form fields  ===============
  String _title;
  String _description;
  int _stage;
  int _semester;
  String _topic;
  File _lectureToUpload;
  String _videoId;

  List<String> _topicList;

  // ========= Fields Getters =============
  String get title => _title;

  String get description => _description;

  int get stage => _stage;

  int get semester => _semester;

  String get topic => _topic;

  File get lectureToUpload => _lectureToUpload;

  String get videoId => _videoId;

  List<String> get topicList => _topicList;

  CollegeUser userData = locator<UserInfoStateProvider>().userData;
  String accountType = locator<UserInfoStateProvider>().userData.accountType;

  // =========== Constructor ======================

  CollegeUploadingState({bool forEdit = false, Map<String, dynamic> data}) {
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _forEditing = forEdit;
    if (_forEditing) {
      parseDataToBeEdit(data);
      notifyMylisteners();
    }
    print('initializing college uploading state');
    // initialize the stage if the user is a college student
    // remember only school students can not upload any material
    if (accountType == 'unistudents') {
      _stage = int.parse((userData as CollegeSutdent).stage.toString());
    }

    // if the user is a student in the college of dentistry
    // set the topic list according to his/her stage
    if (userData.isDental && accountType == 'unistudents') {
      _updateTopicList();
      print('======================================');
      print('topic list updated');
      print(_topicList);
      print('=======================================');
    }

    print('End of state Constructor');
  }

  // ========= Update Topic List Method =========================
  void _updateTopicList() {
    _topicList = References.getSuitaleCollegeMaterialList(_stage, userData.college, semester: _semester);
  }

  // ===================== Update Methods =============================================
  @override
  void updateSemester(int update) {
    if (update != _semester) {
      _semester = update;
      _topic = null;

      // sometimes the user set the semester before the stage
      // so this if statement will help get arrount this issue
      // which when fetching the topic list
      // we fetch it by stage and semester
      // and it return an empty list when one of the args is empty
      if (_stage != null) {
        _updateTopicList();
      }
      notifyMylisteners();
    }
  }

  // update title
  void updateTitle(String update) {
    if (update != null) {
      _title = update;
    }
  }

  // update description
  void updateDescription(String update) {
    if (update != null) {
      _description = update;
    }
  }

  // update VideoID
  void updateVideoId(String update) {
    if (update != null) {
      _videoId = update;
    }
  }

  // update Target Stage
  void updateTargetStage(int update) {
    if (update != _stage) {
      _stage = update;
      _topic = null;

      // sometimes the user set the semester before the stage
      // so this if statement will help get arrount this issue
      // which when fetching the topic list
      // we fetch it by stage and semester
      // and it return an empty list when one of the args is empty
      if (userData.isDental || _semester != null) {
        _updateTopicList();
      }
      notifyMylisteners();
    }
  }

  /// update lecture topic
  void updateLectureTopic(String update) {
    if (update != _topic) {
      _topic = update;
      notifyMylisteners();
    }
  }

  // pick lecture to upload and update
  Future<String> _pickLectureToUpload() async {
    File lecture = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['pdf']);

    if (lecture != null) {
      String fileExtension = lecture.path.split('.').last;
      if (fileExtension.toLowerCase() != 'pdf') {
        return 'only pdf documents are allowed';
      } else {
        _lectureToUpload = lecture;
        // _uploadButtonText =
        notifyMylisteners();
        return '';
      }
    }
    return null;
  }

  Future<String> pickLectureFile(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isPermanentlyDenied) {
      return await showDialog(
          context: context,
          builder: (context) {
            final String text = Platform.isAndroid
                ? 'You must ensure app access to your device files\n'
                    'go to settings -> privacy ->  Manager -> Files and media -> malzama\n'
                    'and allow access to media '
                : 'this app require to access your files, allow it manually from your device settings';
            return AlertDialog(
              content: Text(text),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text('Ok'),
                ),
              ],
            );
          });
    } else if (status.isGranted) {
      return await _pickLectureToUpload();
    } else {
      return null;
    }
  }

  // set all fields to null
  void setAllFieldsToNull() {
    _stage = null;
    _topic = null;
    _lectureToUpload = null;
    _topicList = null;
    _semester = null;
  }

  // get material data
  // this method is called when a call to the API
  Future<Map<String, dynamic>> _getMaterialData() async {
    var data = {
      'title': this._title,
      'description': this._description,
      'stage': this._stage.toString(),
      'topic': this._topic,
      'university': userData.university,
      'college': userData.college,
      'section': userData.section,
      'src': _lectureToUpload ?? _videoId,
    };

    // if the user is pharmacy or medicine
    if (!(new RegExp(r'سنان').hasMatch(userData.college))) {
      data['semester'] = _semester;
    }
    final bool isTeacher = HelperFucntions.isTeacher(accountType);
    data['uuid'] = userData.uuid;
    if (isTeacher) {
      data['uuid'] = data['uuid'].toString() + '$stage';
    }

    return data;
  }

  /// [upload to the API]
  Future<void> upload() async {
    final String uploadType = _lectureToUpload == null ? 'videos' : 'lectures';

    Map<String, dynamic> payload = await _getMaterialData();
    if (uploadType == 'lectures') {
      payload['local_path'] = _lectureToUpload.path;
      print('===================================================================');
      print('local path == ' + payload['local_path']);
      print('===================================================================');
    }
    locator<DialogService>().showDialogOfUploading();
    ContractResponse response = await CommonMaterialClient().uploadNewMaterial(payload: payload, uploadType: uploadType);

    if (response is Success) {
      final text = uploadType.substring(0, uploadType.length - 1);
      var uploadedMaterial = json.decode(response.message);
      Map<String, dynamic> data = uploadedMaterial['data'];
      final storeName = uploadType == 'lectures' ? MyUploaded.LECTURES : MyUploaded.VIDEOS;

      if (data['material_type'] == 'lecture') {
        data['local_path'] = _lectureToUpload.path;
      }
      await QuizAccessObject().saveUploadedMaterial(storeName, data);

      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfSuccess(message: 'Your $text is uploaded successfully');
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfFailure(message: response.message ?? 'Failed to upload, try again');
    }
  }

  void showSnackBar(String message) async {
    if (!_isSnackBarActive) {
      _isSnackBarActive = true;
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ))
          .closed
          .then(
            (SnackBarClosedReason value) => _isSnackBarActive = false,
          );
    }
  }

  bool _isDisposed = false;

  void notifyMylisteners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('college uploading state has been disposed');
    super.dispose();
  }
}
