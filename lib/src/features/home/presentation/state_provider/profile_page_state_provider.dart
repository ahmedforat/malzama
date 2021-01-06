import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:image_picker/image_picker.dart';
import 'package:malzama/src/core/api/api_client/clients/profile_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/platform/services/file_system_services.dart';

class ProfilePageState with ChangeNotifier {
  String _profilePictuesFolderPath;
  String _profilePicturesDirectory;
  String _coverPicturesDirectory;
  User _userData;
  String _localPath;
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
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _initializeLocalPaths().then((_) => loadProfilePictures().then((value) => loadUserData()));
  }

  // this is special for the drafts of quiz just to get the numbers of quiz collections we have in the drafts

  Future<void> loadUserData() async {
    print('loading user data');
    _userData = await FileSystemServices.getUserData();
    _bio = _userData.bio;
    _dataLoaded = true;
    notifyMyListeners();
  }

  // ============================================================================================================
  bool _isUploadingProfilePicture = false;
  bool _isUploadingCoverPicture = false;
  bool _isDeletingProfilePicture = false;
  bool _isDeletingCoverPicture = false;

  bool get isUploadingProfilePicture => _isUploadingProfilePicture;

  bool get isUploadingCoverPicture => _isUploadingCoverPicture;

  bool get isDeletingProfilePicture => _isDeletingProfilePicture;

  bool get isDeletingCoverPicture => _isDeletingCoverPicture;

  void setIsUploadingProfilePictureTo(bool update) {
    _isUploadingProfilePicture = update;
    notifyMyListeners();
  }

  void setIsUploadingCoverPictureTo(bool update) {
    _isUploadingCoverPicture = update;
    notifyMyListeners();
  }

  void setIsDeletingProfilePictureTo(bool update) {
    _isDeletingProfilePicture = update;
    notifyMyListeners();
  }

  void setIsDeletingCoverPictureTo(bool update) {
    _isDeletingCoverPicture = update;
    notifyMyListeners();
  }

  // ============================================================================================================
  Future<void> _uploadProfilePicture(File file) async {
    setIsUploadingProfilePictureTo(true);
    var extension = file.path.split('.').last;

    var url = await HelperFucntions.uploadPDFToCloud(file);
    if (url != null) {
      final String oldUrl = userData.profilePicture;
      var response = await ProfileClient().uploadPicture(url, 'profile_picture_ref', oldUrl: oldUrl);
      if (response is Success) {
        if (_profilePicture != null) {
          print('deleting profile picture ....');
          await Directory(_profilePicturesDirectory).delete(recursive: true);
          _profilePicture = null;
          notifyMyListeners();
          await Future.delayed(Duration(seconds: 1));
        }

        await Directory(_profilePicturesDirectory).create();
        var newBytes = await file.readAsBytes();
        var newFile = new File('$_profilePicturesDirectory/profile.$extension');
        await newFile.writeAsBytes(newBytes);
        await _initializeLocalPaths();
        await loadProfilePictures();
        await loadUserData();
        await Future.delayed(Duration(seconds: 3));
        locator<UserInfoStateProvider>().userData.profilePicture = url;
        await locator<UserInfoStateProvider>().updateUserInfo();
        _userData = locator<UserInfoStateProvider>().userData;
        setIsUploadingProfilePictureTo(false);
        print('process done');
      } else {
        setIsUploadingProfilePictureTo(false);
        showSnackBar(message: 'Failed to upload profile picture');
      }
    } else {
      setIsUploadingProfilePictureTo(false);
      showSnackBar(message: 'Failed to upload profile picture');
    }
  }

  // ============================================================================================================

  Future<void> _uploadCoverPicture(File file) async {
    setIsUploadingCoverPictureTo(true);
    print('isUploading cover = $isUploadingCoverPicture');
    var extension = file.path.split('.').last;
    var url = await HelperFucntions.uploadPDFToCloud(file);
    if (url != null) {
      final String oldUrl = userData.coverPicture;
      var response = await ProfileClient().uploadPicture(url, 'profile_cover_ref', oldUrl: oldUrl);
      if (response is Success) {
        if (_coverPicture != null) {
          await Directory(_coverPicturesDirectory).delete(recursive: true);
          _coverPicture = null;
          notifyMyListeners();
          await Future.delayed(Duration(milliseconds: 1000));
        }
        // //file.copySync('_profilePictuesFolderPath/cover.$extension');
        await Directory(_coverPicturesDirectory).create();
        var newFile = new File('$_coverPicturesDirectory/cover.$extension');
        var newBytes = await file.readAsBytes();
        await newFile.writeAsBytes(newBytes);
        _coverPicture = newFile;
        locator<UserInfoStateProvider>().userData.coverPicture = url;

        //await fetchCoverPictureFromServer();
        await locator<UserInfoStateProvider>().updateUserInfo();
        _userData = locator<UserInfoStateProvider>().userData;
        setIsUploadingCoverPictureTo(false);
        print('isUploading cover = $isUploadingCoverPicture');
        print('process done');
        _scaffoldKey.currentState.showBottomSheet((context) => Container(
              height: 50,
              color: Colors.yellow,
            ));
      } else {
        setIsUploadingCoverPictureTo(false);
        showSnackBar(message: 'Failed to upload cover picture');
      }
    } else {
      setIsUploadingCoverPictureTo(false);
      showSnackBar(message: 'Failed to upload cover picture');
    }
  }

  // ============================================================================================================
  Future<void> _deleteProfilePicture() async {
    setIsDeletingProfilePictureTo(true);
    final String oldUrl = userData.profilePicture;
    ContractResponse response = await ProfileClient().deletePicture('profile_picture_ref', oldUrl);
    if (response is Success) {
      locator<UserInfoStateProvider>().userData.profilePicture = null;
      locator<UserInfoStateProvider>().updateUserInfo();
      await _deleteLocalPicture(pictureName: 'profile');
      _profilePicture = null;
      setIsDeletingProfilePictureTo(false);
    } else {
      setIsDeletingProfilePictureTo(false);
      showSnackBar(message: 'Failed to delete profile picture');
    }
  }

  // ============================================================================================================
  Future<void> _deleteCoverPicture() async {
    setIsDeletingCoverPictureTo(true);
    final String oldUrl = userData.coverPicture;
    ContractResponse response = await ProfileClient().deletePicture('profile_cover_ref', oldUrl);
    if (response is Success) {
      locator<UserInfoStateProvider>().userData.coverPicture = null;
      locator<UserInfoStateProvider>().updateUserInfo();
      await _deleteLocalPicture(pictureName: 'cover');
      _coverPicture = null;
      setIsDeletingCoverPictureTo(false);
    } else {
      setIsDeletingCoverPictureTo(false);
      showSnackBar(message: 'Failed to delete cover picture');
    }
  }

  // ============================================================================================================
  Future<void> onCoverPictureOptionsHandler(BuildContext context, String value) async {
    if (value == null) {
      return;
    }
    if (value == 'view') {
      await _viewPicture(context, _coverPicture, 'cover');
      return;
    }
    if (value == 'delete') {
      _deleteCoverPicture();
      return;
    }
    ImageSource imageSource = value == 'camera' ? ImageSource.camera : ImageSource.gallery;
    PickedFile image = await ImagePicker().getImage(source: imageSource);

    if (image != null) {
      print('**' * 70);
      print(image);
      print('**' * 70);

      await _uploadCoverPicture(File(image.path));
    }
  }

  // ============================================================================================================
  Future<void> onProfilePictureOptionsHandler(BuildContext context, String value) async {
    if (value == null) {
      return;
    }
    if (value == 'view') {
      await _viewPicture(context, _profilePicture, 'profile');
      return;
    }
    if (value == 'delete') {
      _deleteProfilePicture();
      return;
    }

    ImageSource imageSource = value == 'camera' ? ImageSource.camera : ImageSource.gallery;
    PickedFile image = await ImagePicker().getImage(source: imageSource);

    if (image != null) {
      await _uploadProfilePicture(new File(image.path));
    }
  }

  // ============================================================================================================

  Future<void> _viewPicture(BuildContext context, File picture, String tagName) async {
    Widget imageViewer = Hero(
      tag: tagName,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: Navigator.of(context,rootNavigator: true).pop,
          ),
        ),
        body: PhotoView(imageProvider: FileImage(picture)),
      ),
    );
    //locator<UserInfoStateProvider>().setBottomNavBarVisibilityTo(false);
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => imageViewer));
    //locator<UserInfoStateProvider>().setBottomNavBarVisibilityTo(true);
  }

  // ============================================================================================================
  bool get isProfilePictureClickable => !_isDeletingProfilePicture && !_isUploadingProfilePicture;

  bool get isCoverPictureClickable => !_isUploadingCoverPicture && !_isDeletingCoverPicture;

  // ============================================================================================================

  Future<void> _deleteLocalPicture({@required String pictureName}) async {
    String path = pictureName == 'profile' ? _profilePicturesDirectory : _coverPicturesDirectory;
    await Directory(path).delete(recursive: true);
  }

  // ============================================================================================================

  Future<void> _initializePictures() async {
    print('inside _initializePictures()');
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
          await fetchCoverPictureFromServer();
        } else {
          _coverPicture = File(files.first.path);
          await fetchProfilePictureFromServer();
        }
      }
      notifyMyListeners();
    } else {
      fetchCoverPictureFromServer();
      fetchProfilePictureFromServer();
    }
  }

  // ============================================================================================================

  // ============================================================================================================
  Future<void> _initializeProfilePucturesPath() async {
    print('inside _initializeProfilePucturesPath()');
    Directory d = await getApplicationDocumentsDirectory();
    _profilePictuesFolderPath = '${d.path}/profile_pictures';
    Directory(_profilePictuesFolderPath).createSync();
  }

  // ============================================================================================================

  Future<void> _initializeLocalPaths() async {
    Directory dir = await getApplicationDocumentsDirectory();
    _localPath = dir.path;
    _profilePicturesDirectory = '$_localPath/profilePictures';
    _coverPicturesDirectory = '$_localPath/coverPictures';
  }

// ============================================================================================================

  Future<void> loadProfilePictures() async {
    Directory(_profilePicturesDirectory).createSync();
    var files = Directory(_profilePicturesDirectory).listSync();
    if (files.isEmpty) {
      await fetchProfilePictureFromServer();
    } else {
      _profilePicture = files.first;
    }
    Directory(_coverPicturesDirectory).createSync();
    files = Directory(_coverPicturesDirectory).listSync();
    if (files.isEmpty) {
      fetchCoverPictureFromServer();
    } else {
      _coverPicture = files.first;
    }
  }

  // ============================================================================================================

  Future<void> fetchProfilePictureFromServer() async {
    var _myProfilePicture = locator<UserInfoStateProvider>().userData.profilePicture;
    if (_myProfilePicture == null) {
      return;
    }
    var res = await get(_myProfilePicture);
    if (res.statusCode == 200) {
      var extension = res.headers['content-type'].split('/').last;
      _profilePicture = File('$_profilePicturesDirectory/profile.$extension');
      _profilePicture.writeAsBytesSync(res.bodyBytes);
      notifyMyListeners();
    }
  }

  // ============================================================================================================
  Future<void> fetchCoverPictureFromServer() async {
    var _myCoverPicture = locator<UserInfoStateProvider>().userData.coverPicture;
    if (_myCoverPicture == null) {
      return;
    }
    var res = await get(_myCoverPicture);
    if (res.statusCode == 200) {
      var extension = res.headers['content-type'].split('/').last;
      _coverPicture = File('$_coverPicturesDirectory/cover.$extension');
      _coverPicture.writeAsBytesSync(res.bodyBytes);
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
      await locator<UserInfoStateProvider>().updateUserInfo();
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
