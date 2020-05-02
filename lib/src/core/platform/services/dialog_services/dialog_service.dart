import 'dart:async';

import 'package:malzama/src/features/home/presentation/state_provider/my_materials_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/pdf_viewer_state_provider.dart';

import '../../../../features/home/presentation/state_provider/profile_page_state_provider.dart';

class DialogService {
  String pdfUrl;
  String pdfLocalPath;
  int pdfSize;

  PDFSource pdfSource ;

  bool _isDailogOpened = false;
  bool get isDialogOpened => _isDailogOpened;
  Completer _dialogCompleter;


  ProfilePageState profilePageState;
  MyMaterialStateProvider myMaterialStateProvider;

  // close tha dialog
  Function _dialogCloseListener;

  void registerCloseDialogListner(Function listener) {
    _dialogCloseListener = listener;
  }

// show dialog of uploading new video
  Function _showDialogOfUploadingNewVideo;

  void registerShowDialogOfUploadingVideo(Function listener) {
    _showDialogOfUploadingNewVideo = listener;
  }

  Future showDialogOfUploadingNewVideo() {
    _dialogCompleter = new Completer<Map<String,dynamic>>();
    _isDailogOpened = true;
    _showDialogOfUploadingNewVideo();
    return _dialogCompleter.future;
  }


// show dialog of uploading 
  Function _showDialogOfUploading;

  void registerShowDialogOfUploading(Function listener) {
    _showDialogOfUploading = listener;
  }

  Future showDialogOfUploading() {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfUploading();
    return _dialogCompleter.future;
  }


  // show dialog of loading PDF 
  Function _showDialogOfLoadingPDF;

  void registerShowDialogOfLoadingPDF(Function listener) {
    _showDialogOfLoadingPDF = listener;
  }

  Future showDialogOfLoadingPDF() {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfLoadingPDF();
    return _dialogCompleter.future;
  }

  // show dialog of success 
  Function _showDialogOfSuccess;

  void registerShowDialogOfSuccess(Function({String message}) listener) {
    _showDialogOfSuccess = listener;
  }

  Future showDialogOfSuccess({String message}) {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfSuccess(message:message);
    return _dialogCompleter.future;
  }

 // show dialog of Failure
  Function _showDialogOfFailure;

  void registerShowDialogOfFailure(Function({String message}) listener) {
    _showDialogOfFailure = listener;
  }

  Future showDialogOfFailure({String message}) {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfFailure(message:message);
    return _dialogCompleter.future;
  }
  // show dialog of uploading new lecture
  Function _showDialogOfUploadingNewLecture;

  void registerShowDialogOfUploadingLecture(Function listener) {
    _showDialogOfUploadingNewLecture = listener;
  }

  Future showDialogOfUploadingNewLecture() {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfUploadingNewLecture();
    return _dialogCompleter.future;
  }

  // show dialog of editing info
  Function _showDialogOfEditingInfo;

  void registerShowDialogOfEditingInfo(Function listener) {
    _showDialogOfEditingInfo = listener;
  }

  Future showDialogOfEditingInfo() {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfEditingInfo();
    return _dialogCompleter.future;
  }

  // show dialog of choosing image source

  Function _showDialogOfChoosingImageSource;
  void registerShowDialogOfChoosingImageSource(Function listener) {
    _showDialogOfChoosingImageSource = listener;
  }

  Future<void> showDialogeOfChoosingImageSource() async {
    _dialogCompleter = new Completer();
    _showDialogOfChoosingImageSource();
  }

  // show dialog of editing and viewing profile picture
  Function _showDialogOfProfilePicture;

  void registerShowDialogOfProfilePicture(Function listener) {
    _showDialogOfProfilePicture = listener;
  }

  Future<dynamic> showDialogOfProfilePicture() {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfProfilePicture();
    return _dialogCompleter.future;
  }

  // show dialog of cover picture
  Function() _showDialogOfCoverPicture;

  void registerShowDialogOfCoverPicture(Function listener) {
    _showDialogOfCoverPicture = listener;
  }

  Future<dynamic> showDialogOfCoverPicture() {
    _dialogCompleter = new Completer();
    _isDailogOpened = true;
    _showDialogOfCoverPicture();
    return _dialogCompleter.future;
  }

  void completeAndCloseDialog(value) {
    print('dialog has ended and closed');
    if (_dialogCompleter != null) _dialogCompleter.complete(value);
    _isDailogOpened = false;
    _dialogCompleter = null;
    _dialogCloseListener();
    print('closing dialog');
  }
}
