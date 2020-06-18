import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';

import '../dialog_service.dart';
import '../service_locator.dart';
import '../use_cases.dart';

class CollegeUploadingState extends StateProvider with ChangeNotifier {
  int _stage;
  File _lectureToUpload;
  int _semester;
  String _topic;
  List<String> _topicList;
  String college = locator<DialogService>().profilePageState.userData.college;
  String account_type = locator<DialogService>().profilePageState.userData.commonFields.account_type;

  CollegeUploadingState() {
    if (account_type == 'unistudents') {
      _stage = int.parse(locator<DialogService>().profilePageState.userData.stage.toString());
    }
    if (new RegExp(r'سنان').hasMatch(college)) {
      _updateTopicList();
    }
  }

  void _updateTopicList() {
    _topicList = References.getSuitaleCollegeMaterialList(_stage, college, semester: _semester);
  }

  int get stage => _stage;

  String get topic => _topic;

  File get lectureToUpload => _lectureToUpload;

  int get semester => _semester;

  List<String> get topicList => _topicList;

  @override
  void updateSemester(int update) {
    if (update != _semester) {
      _semester = update;
      _topic = null;
      _updateTopicList();
      notifyListeners();
    }
  }

  void updateTargetStage(int update) {
    if (update != _stage) {
      _topic = null;
      _updateTopicList();
      _stage = update;

      notifyListeners();
    }
  }

  void updateLectureTopic(String update) {
    if (update != _topic) {
      _topic = update;
      notifyListeners();
    }
  }

  void updateLectureToUpload(File update) {
    if (update != _lectureToUpload) {
      _lectureToUpload = update;
      notifyListeners();
    }
  }

  void setAllFieldsToNull() {
    _stage = null;
    _topic = null;
    _lectureToUpload = null;
    _topicList = null;
    _semester = null;
  }

//  Future<ContractResponse> uploadNewLecture() async {
//    Map data = await locator<DialogService>().showDialogOfUploadingNewLecture();
//    setAllFieldsToNull();
//    if (data != null) {
//      locator<DialogService>().showDialogOfUploading();
//      ContractResponse response =
//      await DialogManagerUseCases.uploadNewLecture(lectureData: data);
//      locator<DialogService>().completeAndCloseDialog(null);
//      return response;
//    } else
//      return null;
//  }

  Future<ContractResponse> uploadNewVideo() async {
    Map data = await locator<DialogService>().showDialogOfUploadingNewVideoForUniversities();
    setAllFieldsToNull();
    if (data != null) {
      locator<DialogService>().showDialogOfUploading();
      ContractResponse response = await DialogManagerUseCases.uploadNewVideo(data);
      locator<DialogService>().completeAndCloseDialog(null);
      return response;
    } else
      return null;
  }
}
