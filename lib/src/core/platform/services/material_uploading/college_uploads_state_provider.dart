import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/material_uploading/material_uploader.dart';

import '../../../../features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import '../../../references/references.dart';
import '../dialog_services/dialog_service.dart';
import '../dialog_services/service_locator.dart';

class CollegeUploadingState extends StateProvider with ChangeNotifier {
  // the text of the button that gets tapped
  // when the user want to choose the file to upload

  String _uploadButtonText;

  String get uploadButtonText => _lectureToUpload == null
      ? 'Tap Here To Choose File'
      : lectureToUpload.path.split('/').last.length > 40 ? _lectureToUpload.path.split('/').last.substring(0, 40) : _lectureToUpload.path.split('/').last;

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


  var userData = locator<DialogService>().profilePageState.userData;
  String account_type = locator<DialogService>().profilePageState.userData.commonFields.account_type;


  // =========== Constructor ======================

  CollegeUploadingState() {
    // initialize the stage if the user is a college student
    // remember only school students can not upload any material
    if (account_type == 'unistudents') {
      _stage = int.parse(locator<DialogService>().profilePageState.userData.stage.toString());
    }

    // if the user is a student in the college of dentistry
    // set the topic list according to his/her stage
    if (new RegExp(r'سنان').hasMatch(userData.college)) {
      _updateTopicList();
    }
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
      notifyListeners();
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
      if (_semester != null) {
        _updateTopicList();
      }
      notifyListeners();
    }
  }

  // update lecture topic
  void updateLectureTopic(String update) {
    if (update != _topic) {
      _topic = update;
      notifyListeners();
    }
  }

  // pick lecture to upload and update
  Future<String> pickLectureToUpload() async {
    File lecture = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['pdf']);

   if(lecture != null){
      String fileExtension = lecture.path.split('.').last;
    if (fileExtension.toLowerCase() != 'pdf') {
      return 'only pdf documents are allowed';
    } else {
      _lectureToUpload = lecture;
      notifyListeners();
      return '';
    }
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
  Map<String, dynamic> _getMaterialData() {
    var data = {
      'title': this._title,
      'description': this._description,
      'stage': this._stage,
      'topic': this._topic,
      'university': userData.university,
      'college': userData.college,
      'section': userData.section,

    };


    

   

    // if the user is pharmacy or medicine
    if (!(new RegExp(r'سنان').hasMatch(userData.college))) {
      data['semester'] = _semester;
    }

    if (_lectureToUpload != null) {
      data['src'] = _lectureToUpload;
      data['upload_type'] = 'lectures';
    } else {
      data['videoId'] = _videoId;
      data['upload_type'] = 'videos';
    }

    return data;
  }


  // upload to the API
  Future<ContractResponse> upload()async{
    return await MaterialUploader.uploadNewMaterial(materialData: _getMaterialData());
  }
}
