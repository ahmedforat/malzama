import 'dart:async';

import 'package:malzama/src/features/home/presentation/state_provider/my_materials_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/pdf_viewer_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';

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
  QuizUploadingState quizUploadingState;
  MyMaterialStateProvider myMaterialStateProvider;



  // ********************************************** showing dialog template **********************************

    Future showDialog(Function dialog){
      _dialogCompleter = new Completer();
      _isDailogOpened = true;
      dialog();
      return _dialogCompleter.future;
    }

  // *********************************************************************************************************


  //******
  //******
  //******
  //******
  //******
  //******
  //******
  //******
  //******


// ************************************** Closing the Dialog **************************************************
  // close tha dialog
  Function _dialogCloseListener;

  void registerCloseDialogListner(Function listener) {
    _dialogCloseListener = listener;
  }


  void completeAndCloseDialog(value) {
    print('dialog has ended and closed');
    if (_dialogCompleter != null) _dialogCompleter.complete(value);
    _isDailogOpened = false;
    _dialogCompleter = null;
    _dialogCloseListener();
    print('closing dialog');
  }
// *************************************************************************************************************


  //****
  //****
  //****
  //****
  //****
  //****
  //****
  //****



  //******************************************* Dialog of loading and uploading ****************************************
// show dialog of uploading 
  Function _showDialogOfUploading;

  void registerShowDialogOfUploading(Function listener) {
    _showDialogOfUploading = listener;
  }

  Future showDialogOfUploading() => showDialog(_showDialogOfUploading);
  // --------------------------------------

  // show dialog of loading PDF 
  Function _showDialogOfLoadingPDF;

  void registerShowDialogOfLoadingPDF(Function listener) {
    _showDialogOfLoadingPDF = listener;
  }

  Future showDialogOfLoadingPDF() => showDialog(_showDialogOfLoadingPDF);

  //****************************************************************************************************************


  //****
  //****
  //****
  //****
  //****
  //****
  //****
  //****



  // ************************************************* dialog of success & failure ***********************************


  // Dialog of success  as a message

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
  // --------------------------------------

 // show dialog of Failure as a message
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
  //****************************************************************************************************************


  //****
  //****
  //****
  //****
  //****
  //****
  //****
  //****



  // *************************************** uploading for schools **********************************************
  // show dialog of uploading new lecture for schools
  Function _showDialogOfUploadingNewLectureForSchools;

  void registerShowDialogOfUploadingLectureForSchools(Function listener) {
    _showDialogOfUploadingNewLectureForSchools = listener;
  }

  Future showDialogOfUploadingNewLectureForSchools()  => showDialog(_showDialogOfUploadingNewLectureForSchools);

  // --------------------------------------

  // show dialog of uploading new video for schools
  Function _showDialogOfUploadingNewVideoForSchools;

  void registerShowDialogOfUploadingVideoForSchools(Function listener) {
    _showDialogOfUploadingNewVideoForSchools = listener;
  }

  Future showDialogOfUploadingNewVideo() => showDialog(_showDialogOfUploadingNewVideoForSchools);


  // ******************************************************************************************************


  //****
  //****
  //****
  //****
  //****
  //****
  //****
  //****
  //****



  // *************************************** uploading for universities **********************************************

  // show dialog of uploading new lecture for universities
  Function _showDialogOfUploadingNewLectureForUniversities;

  void registerShowDialogOfUploadingLectureForUniversities(Function listener) {
    _showDialogOfUploadingNewLectureForUniversities = listener;
  }
  Future showDialogOfUploadingNewLectureForUniversities() => showDialog(_showDialogOfUploadingNewLectureForUniversities);

  // -----------------------------


  // show dialog of uploading new video for universities
  Function _showDialogOfUploadingNewVideoForUniversities;

  void registerShowDialogOfUploadingVideoForUniversities(Function listener) {
    _showDialogOfUploadingNewVideoForUniversities = listener;
  }
  Future showDialogOfUploadingNewVideoForUniversities() => showDialog(_showDialogOfUploadingNewVideoForUniversities);

// **************************************************************************************************************



  //*****
  //*****
  //*****
  //*****
  //*****
  //*****
  //*****
  //*****


// ***************************************** Dialogs of Editing Profile info ********************************************
  // show dialog of editing info
  Function _showDialogOfEditingInfo;

  void registerShowDialogOfEditingInfo(Function listener) {
    _showDialogOfEditingInfo = listener;
  }

  Future showDialogOfEditingInfo() => showDialog(_showDialogOfEditingInfo);


  // *************************************  Profile Pictures Dialogs ****************************************


  // show dialog of choosing image source
  Function _showDialogOfChoosingImageSource;
  void registerShowDialogOfChoosingImageSource(Function listener) {
    _showDialogOfChoosingImageSource = listener;
  }

  Future<void> showDialogeOfChoosingImageSource() async {
    _dialogCompleter = new Completer();
    _showDialogOfChoosingImageSource();
  }

  // -------------------------------------


  // show dialog of editing and viewing profile picture
  Function _showDialogOfProfilePicture;

  void registerShowDialogOfProfilePicture(Function listener) {
    _showDialogOfProfilePicture = listener;
  }

  Future<dynamic> showDialogOfProfilePicture() => showDialog(_showDialogOfProfilePicture);

  // ----------------------------------------

// show dialog of editing and viewing cover picture
  Function() _showDialogOfCoverPicture;

  void registerShowDialogOfCoverPicture(Function listener) {
    _showDialogOfCoverPicture = listener;
  }

  Future showDialogOfCoverPicture() => showDialog(_showDialogOfCoverPicture);

// ******************************************************************************************************



}
