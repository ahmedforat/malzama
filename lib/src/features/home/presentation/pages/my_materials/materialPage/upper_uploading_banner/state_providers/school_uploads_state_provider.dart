import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../models/users/school_teacher.dart';
import '../../../../../state_provider/user_info_provider.dart';

class SchoolUploadState with ChangeNotifier {
  String _title;
  String _description;
  String _targetStage;
  String _targetSchoolSection;

  File _lectureToUpload;
  String _videoId;
  File get lectureToUpload => _lectureToUpload;

//  bool _enabled = false;
//
//  bool get enabled => _enabled;

  String get targetStage => _targetStage;

  String get targetSchoolSection => _targetSchoolSection;

  String get title => _title;
  String get description => _description;
  String get videoId => _videoId;

  
  void updateTitle(String update) {
    if (update != null) {
      _title = update;
    }
  }

  void updateDescription(String update) {
    if (update != null) {
      _description = update;
    }
  }

  void updateVideoId(String update) {
    if (update != null) {
      _videoId = update;
    }
  }

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


   Map<String, dynamic> getMaterialData() {
    Map<String,dynamic> data = {
      'title': this._title,
      'description': this._description,
      'stage': this._targetStage,
      'topic': (locator.get<UserInfoStateProvider>().userData as SchoolTeacher).speciality,
      'school_section':_targetSchoolSection,
    };

    if (_lectureToUpload != null) {
      data['src'] = _lectureToUpload;
      data['upload_type'] = 'lectures';
    } else if (_videoId != null) {
      data['videoId'] = _videoId;
      data['upload_type'] = 'videos';
    }

    return data;
  }

  // // uplaoding method for dialogs
  // Future<ContractResponse> uploadNewLecture(Map<String,dynamic> data) async {
  //   Map data = await locator<DialogService>().showDialogOfUploadingNewLectureForSchools();
  //   setAllFieldsToNull();
  //   if (data != null) {
  //     locator<DialogService>().showDialogOfUploading();
  //     ContractResponse response = await DialogManagerUseCases.uploadNewMaterial(data,'lectures');
  //     locator<DialogService>().completeAndCloseDialog(null);
  //     return response;
  //   } else
  //     return null;
  // }

}
