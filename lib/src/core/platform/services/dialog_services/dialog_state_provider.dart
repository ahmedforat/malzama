import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_manger.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/platform/services/dialog_services/use_cases.dart';

class DialogStateProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setIsLoadingTo(bool update) {
    if (update != null) {
      _isLoading = update;
      notifyListeners();
    }
  }

  File _lecture;

  File get lecture => _lecture;

  void updateLecture(File update) {
    if (update != null) {
      _lecture = update;
      notifyListeners();
    }
  }
}

class SchoolUploadState with ChangeNotifier {
  String _targetStage;
  String _targetSchoolSection;

  File _lectureToUpload;

  File get lectureToUpload => _lectureToUpload;

  bool _enabled = false;

  bool get enabled => _enabled;

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
    Map data = await locator<DialogService>().showDialogOfUploadingNewLecture();
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
