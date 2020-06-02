import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'dart:io';

import '../dialog_service.dart';
import '../service_locator.dart';
import '../use_cases.dart';

class SchoolUploadState with ChangeNotifier {
  String _targetStage;
  String _targetSchoolSection;

  File _lectureToUpload;

  File get lectureToUpload => _lectureToUpload;

//  bool _enabled = false;
//
//  bool get enabled => _enabled;

  String get targetStage => _targetStage;

  String get targetSchoolSection => _targetSchoolSection;

  void updateTargetStage(String update) {
    if (update != _targetStage) {
      _targetStage = update;
      notifyListeners();
    }
  }

  void updateTargetSchoolSection(String update) {
    if (update != _targetSchoolSection) {
      _targetSchoolSection = update;
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
    _targetSchoolSection = null;
    _targetStage = null;
    _lectureToUpload = null;
  }

  Future<ContractResponse> uploadNewLecture() async {
    Map data = await locator<DialogService>().showDialogOfUploadingNewLectureForSchools();
    setAllFieldsToNull();
    if (data != null) {
      locator<DialogService>().showDialogOfUploading();
      ContractResponse response =
      await DialogManagerUseCases.uploadNewLecture(lectureData: data);
      locator<DialogService>().completeAndCloseDialog(null);
      return response;
    } else
      return null;
  }

  Future<ContractResponse> uploadNewVideo() async {
    Map data = await locator<DialogService>().showDialogOfUploadingNewVideo();
    setAllFieldsToNull();
    if (data != null) {
      locator<DialogService>().showDialogOfUploading();
      ContractResponse response =
      await DialogManagerUseCases.uploadNewVideo(data);
      locator<DialogService>().completeAndCloseDialog(null);
      return response;
    } else
      return null;
  }
}
