import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/api_client/clients/profile_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/platform/services/file_system_services.dart';

class ProfilePageState with ChangeNotifier {
  String _profilePictuesFolderPath;
  User _userData;

  String _bio;

  String get bio => _bio;

  void updateBio(String update) {
    _bio = update;
    notifyMyListeners();
  }

  User get userData => _userData;

  void updateUserData(update) {
    if (update != null) {
      _userData = update;
      notifyMyListeners();
    }
  }

  bool _dataLoaded = false;

  bool get dataLoaded => _dataLoaded;

  File _profilePicture;
  File _coverPicture;
  final String defaultProfilePicture = 'assets/default_profile_picture.png';
  final String defaultCoverPicture = 'assets/default_cover_picture.jpg';

  File get profilePicture => _profilePicture;

  File get coverPicture => _coverPicture;

  ProfilePageState() {
    print('constructuing new value');
    _initializePictures();
    loadUserData();
  }

  // this is special for the drafts of quiz just to get the numbers of quiz collections we have in the drafts

  Future<void> loadUserData() async {
    print('loading user data');
    _userData = await FileSystemServices.getUserData();
    _dataLoaded = true;
    notifyMyListeners();
  }

  // ============================================================================================================

  Future<void> uploadProfilePicture(File file) async {
    var extension = file.path.split('.').last;

    var url = await HelperFucntions.uploadPDFToCloud(file);
    if (url != null) {
      var response = await ProfileClient().editOrDeleteProfilePicture(true, url, 'profile_picture_ref');
      if (response is Success) {
        Directory(_profilePictuesFolderPath).createSync();
        file.copySync('_profilePictuesFolderPath/profile.$extension');
        _profilePicture = File('_profilePictuesFolderPath/profile.$extension');
      }
    }
  }

  // ============================================================================================================

  Future<void> uploadCoverPicture(File file) async {
    var extension = file.path.split('.').last;
    var url = await HelperFucntions.uploadPDFToCloud(file);
    if (url != null) {
      var response = await ProfileClient().editOrDeleteProfilePicture(true, url, 'profile_cover_ref');
      if (response is Success) {
        Directory(_profilePictuesFolderPath).createSync();
        file.copySync('_profilePictuesFolderPath/cover.$extension');
        _coverPicture = File('_profilePictuesFolderPath/cover.$extension');
      }
    }
  }

  // ============================================================================================================

  // ============================================================================================================

  Future<void> _initializePictures() async {
    Directory d = await getApplicationDocumentsDirectory();
    _profilePictuesFolderPath = '${d.path}/profile_pictures';
    Directory(_profilePictuesFolderPath).createSync();

    var files = Directory(_profilePictuesFolderPath).listSync();
    if (files.isNotEmpty) {
      if (files.length == 2) {
        var first = files.first.path.split('/').last.split('.').first;
        _profilePicture = first == 'profile' ? File(files.first.path) : File(files.last.path);
        _coverPicture = first == 'cover' ? File(files.first.path) : File(files.last.path);
      } else {
        var first = files.first.path.split('/').last.split('.').first;
        if (first == 'profile') {
          _profilePicture = File(files.first.path);
        } else {
          _coverPicture = File(files.first.path);
        }
      }
      notifyMyListeners();
    }
  }

  // ============================================================================================================
  bool _isDeletingBio = false;

  bool get isDeletingBio => _isDeletingBio;

  void setIsDeletingBio(bool update) {
    _isDeletingBio = update;
    notifyMyListeners();
  }

  // ============================================================================================================

  Future<void> deleteBio(BuildContext context) async {
    String message;
    setIsDeletingBio(true);
    ContractResponse response = await ProfileClient().deleteBio();
    if (response is Success) {
      locator<UserInfoStateProvider>().userData.bio = null;
      locator<UserInfoStateProvider>().updateUserInfo();
      locator<UserInfoStateProvider>().notifyMyListeners();

      message = 'Bio deleted';
      _bio = null;
    } else {
      message = 'Failed to delete bio';
    }
    setIsDeletingBio(false);
    await Future.delayed(Duration(milliseconds: 200));
    showSnackBar(message: message);
  }

  // ============================================================================================================
  GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool _isSnackBarVisible = false;

  showSnackBar({String message, int seconds}) {
    if (_isSnackBarVisible) {
      return;
    }
    _isSnackBarVisible = true;
    _scaffoldKey.currentState
        .showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: seconds ?? 4),
          ),
        )
        .closed
        .then((value) => _isSnackBarVisible = false);
  }

  // ============================================================================================================
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
}
