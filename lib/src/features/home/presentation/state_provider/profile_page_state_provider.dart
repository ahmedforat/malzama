import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/platform/services/caching_services.dart';
import '../../../../core/platform/services/dialog_services/dialog_service.dart';
import '../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../core/platform/services/file_system_services.dart';

class ProfilePageState with ChangeNotifier {
  File _lectureToUpload;

  File get lectureToUpload => _lectureToUpload;

  void updateLectureToUpload(File update) {
    if (update != null) {
      _lectureToUpload = update;
      notifyMyListeners();
    }
  }

  String target;

  DialogService _dialogService;
  dynamic _userData;

  dynamic get userData => _userData;

  void updateUserData(update) {
    if (update != null) {
      _userData = update;
      notifyMyListeners();
    }
  }

  bool _dataLoaded = false;

  bool get dataLoaded => _dataLoaded;

  int count = 0;

  File _profilePicture;
  File _coverPicture;

  File get profilePicture => _profilePicture;

  File get coverPicture => _coverPicture;

  Directory _directory;
  String _userPhotosPath;
  String _userCoverPath;

  ProfilePageState() {
    print('constructuing new value');
    _onPageLaunch();
    _loadUserData();

  }

  // this is special for the drafts of quiz just to get the numbers of quiz collections we have in the drafts



  Future<void> _loadUserData() async {
    print('loading user data');
    _userData = await FileSystemServices.getUserData();
    _dataLoaded = true;
    notifyMyListeners();
  }

  Future<void> _onPageLaunch() async {
    _dialogService = locator.get<DialogService>();

    _directory = await getApplicationDocumentsDirectory();

    _userPhotosPath = '${_directory.path}/user_photos';
    _userCoverPath = '${_directory.path}/user_covers';

    final coverPicPath = await CachingServices.getField(key: 'coverPicture');
    final profilPicPath = await CachingServices.getField(key: 'profilePicture');

    bool doesUserPhotoExist = await Directory(_userPhotosPath).exists();
    bool doesUserCoverExist = await Directory(_userCoverPath).exists();

    print('this is the profile path in the caching system');
    if (profilPicPath == null) {
      if (doesUserPhotoExist) {
        final userPhoto = Directory(_userPhotosPath);
        var allFiles = userPhoto.listSync();
        if (allFiles.length > 0) {
          await CachingServices.saveStringField(key: 'profilePicture', value: allFiles[0].path);
          _profilePicture = allFiles[0];
          notifyMyListeners();
          return;
        }
      } else {
        //await Directory(_userPhotosPath).delete(recursive:true);
        await new Directory(_userPhotosPath).create(recursive: true);
      }
    } else {
      if (doesUserPhotoExist) {
        bool doesFileExist = await File(profilPicPath).exists();
        if (doesFileExist) {
          _profilePicture = File(profilPicPath);
          notifyMyListeners();
        }
      } else {
        await Directory(_userPhotosPath).delete(recursive: true);
        await new Directory(_userPhotosPath).create(recursive: true);
      }
    }

    if (coverPicPath == null) {
      if (doesUserCoverExist) {
        final userCover = Directory(_userCoverPath);
        var allFiles = userCover.listSync();
        if (allFiles.length > 0) {
          await CachingServices.saveStringField(key: 'coverPicture', value: allFiles[0].path);
          _coverPicture = allFiles[0];
          notifyMyListeners();
          return;
        }
      } else {
        //await Directory(_userPhotosPath).delete(recursive:true);
        await new Directory(_userCoverPath).create(recursive: true);
      }
    } else {
      if (doesUserCoverExist) {
        bool doesFileExist = await File(coverPicPath).exists();
        if (doesFileExist) {
          _coverPicture = File(coverPicPath);
          notifyMyListeners();
        }
      } else {
        await Directory(_userPhotosPath).delete(recursive: true);
        await new Directory(_userPhotosPath).create(recursive: true);
      }
    }
  }

  void updateCounter() {
    count++;
    notifyMyListeners();
  }

// related to the dropDownButton of school stages inside the dialog of uploading new lecture
// for schools

  String _targetSchoolStage;

  String get targetSchoolStage => _targetSchoolStage;

  void updateTragetSchoolStage(String update) {
    if (update != null) {
      _targetSchoolStage = update;
      notifyMyListeners();
    }
  }

  String _targetSchoolSection;

  String get targetSchoolSection => _targetSchoolSection;

  void updateTragetSchoolSection(String update) {
    if (update != null) {
      _targetSchoolSection = update;
      notifyMyListeners();
    }
  }

  // update profile picture
  Future<void> updateProfilePicture({File update}) async {
    _profilePicture = null;
    final dir = Directory(_userPhotosPath);
    await dir.delete(recursive: true);
    await new Directory(_userPhotosPath).create(recursive: true);
    final extName = update.path.split('.').last;
    _profilePicture = await update.copy(_userPhotosPath + '/${DateTime.now().millisecond}.$extName');
    await CachingServices.saveStringField(key: 'profilePicture', value: '${_profilePicture.path}');
    notifyMyListeners();
  }

  // update cover picture
  Future<void> updateCoverPicture({File update}) async {
    _coverPicture = null;
    final dir = Directory(_userCoverPath);
    await dir.delete(recursive: true);
    await new Directory(_userCoverPath).create(recursive: true);
    final extName = update.path.split('.').last;
    _coverPicture = await update.copy(_userCoverPath + '/${DateTime.now().millisecond}.$extName');
    await CachingServices.saveStringField(key: 'coverPicture', value: '${_coverPicture.path}');
    notifyMyListeners();
  }

  // choosing image source dialog
  Future<void> showDialogeOfChoosingImageSource() async {
    await _dialogService.showDialogeOfChoosingImageSource();
  }

  Future showOnProfilePictureTappingDialoge() async {
    print('dialog has been started right now (of profile picture)');
   // _dialogService.profilePageState.target = 'profilePicture';
    var result = await _dialogService.showDialogOfProfilePicture();
    print('dialog has been ended right now (of profile picture)');
  }

  Future showOnCoverPictureTappingDialoge() async {
    print('dialog has been started right now (of cover picture)');
    target = null;
    var result = await _dialogService.showDialogOfCoverPicture();
    print('dialog has been ended right now (of cover picture)');
  }

  Future showDialogeOfEditingProfileData() async {
    var result = await _dialogService.showDialogOfEditingInfo();
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
    print('disposing ProfilePageState');
    super.dispose();
  }

// Future showDialogOfUploadingNewMaterial()async{
//   var result = await _dialogService.showDialogOfUploadingNewVideo();
// }
}
