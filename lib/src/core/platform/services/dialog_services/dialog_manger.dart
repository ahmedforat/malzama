

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'dialog_service.dart';
import 'service_locator.dart';




class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({this.child});

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService dialogService = locator.get<DialogService>();

  @override
  void initState() {
    print('initializing the service locator');

    // ** register of closing dialog method
    dialogService.registerCloseDialogListner(_closeDialog);

    // registration of dialogs for profile info **************************************************************

    // // register dialog for profile picture
    // dialogService.registerShowDialogOfProfilePicture(_showDialogOfProfilePicture);
    //
    // // register dialog for profile cover picture
    // dialogService.registerShowDialogOfCoverPicture(_showDialogOfCoverPicture);
    //
    // // register dialog for choosing image source
    // dialogService.registerShowDialogOfChoosingImageSource(_showDialogOfChoosingImageSource);
    //
    // // register dialog for editing profile info
    // dialogService.registerShowDialogOfEditingInfo(_showDialogeOfProfileEditingInfo);

    //*******************************************************************************************************

    //***
    //***
    //***
    //***
    //***
    //***
    //***
    //***

    // registration of dialogs for schools ****************************************************************************

    // // ***** register dialog for uploading video for schools
    // dialogService.registerShowDialogOfUploadingVideoForSchools(_showDialogOfUploadingVideoForSchools);
    //
    // // ***** register dialog for uploading lecture for schools
    // dialogService.registerShowDialogOfUploadingLectureForSchools(_showDialogOfUploadingLectureForSchools);

    //*********************************************************************************************************************

    //***
    //***
    //***
    //***
    //***
    //***
    //***
    //***

    // registration of dialogs for universities  ****************************************************************************

    // // ***** register dialog for uploading lecture for universities
    // dialogService.registerShowDialogOfUploadingLectureForUniversities(_showDialogOfUploadingLectureForUniversities);
    //
    // // ***** register dialog for uploading video for universities
    // dialogService.registerShowDialogOfUploadingVideoForUniversities(_showDialogOfUploadingVideoForUniversities);

    //************************************************************************************************************************

    //***
    //***
    //***
    //***
    //***
    //***
    //***
    //***

    // registration of dialogs for universities  ****************************************************************************

    // ***** register dialog for Success message
    dialogService.registerShowDialogOfSuccess(showDialogOfSuccess);

    // ***** register dialog for Failure message
    dialogService.registerShowDialogOfFailure(showDialogOfFailure);

    //***********************************************************************************************************************

    //***
    //***
    //***
    //***
    //***
    //***
    //***
    //***

    // registration of loading and uploading **********************************************************************************

    // register dialog for loading pdf
   // dialogService.registerShowDialogOfLoadingPDF(showDialogOfLoadingPDF);

    // register dialog for uploading progress
    dialogService.registerShowDialogOfUploading(showDialogOfUploading);

    // register dialog for loading
    dialogService.registerShowDialogOfLoading(showDialogOfLoading);

    // ***********************************************************************************************************************
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  // void _showDialog() async {
  //   await showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => WillPopScope(
  //             onWillPop: () {
  //               print('inside the willpop of the alert dialog');
  //               dialogService.dialogComplete();
  //               return Future.value(false);
  //             },
  //             child: GestureDetector(
  //               onTap: () {
  //                 FocusScope.of(context).unfocus();
  //               },
  //               child: AlertDialog(
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                   content: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: <Widget>[
  //                       Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Text(
  //                           'Update Info',
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: ScreenUtil().setSp(50)),
  //                         ),
  //                       ),
  //                       TextFormField(),
  //                       TextFormField(),
  //                     ],
  //                   ),
  //                   actions: [
  //                     FlatButton(
  //                       child: Text('close'),
  //                       onPressed: dialogService.dialogComplete,
  //                     ),
  //                     FlatButton(
  //                       child: Text('Ok'),
  //                       onPressed: dialogService.dialogComplete,
  //                     ),
  //                   ]),
  //             ),
  //           ));
  // }

  GlobalKey<FormState> formKey;

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  // Future<void> _showDialogOfChoosingImageSource() {
  //
  //
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => dialogWrapper(
  //           closingCallback: () => dialogService.completeAndCloseDialog(null),
  //           child: AlertDialog(
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
  //             actions: <Widget>[
  //               FlatButton(child: Text('Close'), onPressed: () => dialogService.completeAndCloseDialog(null)),
  //             ],
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text('Choose image source'),
  //                 SizedBox(
  //                   height: ScreenUtil().setHeight(60),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: <Widget>[
  //                     FlatButton(
  //                       child: Icon(Icons.photo_camera),
  //                       onPressed: () async {
  //                         File newPhoto = await ImagePicker.pickImage(source: ImageSource.camera);
  //                         if (newPhoto != null) {
  //                           if (dialogService.profilePageState.target == 'profilePicture') {
  //                             await dialogService.profilePageState.updateProfilePicture(update: newPhoto);
  //                             dialogService.completeAndCloseDialog(null);
  //                           } else {
  //                             await dialogService.profilePageState.updateCoverPicture(update: newPhoto);
  //                             dialogService.completeAndCloseDialog(null);
  //                           }
  //                         }
  //                       },
  //                     ),
  //                     FlatButton(
  //                       child: Icon(Icons.photo_library),
  //                       onPressed: () async {
  //                         File newPhoto = await ImagePicker.pickImage(source: ImageSource.gallery);
  //                         if (newPhoto != null) {
  //                           await dialogService.profilePageState.updateProfilePicture(update: newPhoto);
  //                           dialogService.completeAndCloseDialog(null);
  //                         }
  //                       },
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           )));
  // }

  // void _showDialogOfProfilePicture() {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => dialogWrapper(
  //           closingCallback: () => dialogService.completeAndCloseDialog(null),
  //           child: Builder(
  //             builder: (context) => AlertDialog(
  //               content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //                 if (dialogService.profilePageState.profilePicture != null)
  //                   FlatButton(
  //                     child: Text('View Profile Picture'),
  //                     onPressed: () {
  //                       dialogService.completeAndCloseDialog(null);
  //                       Navigator.of(context).pushNamed('/display-profile-picture');
  //                     },
  //                   ),
  //                 FlatButton(
  //                   child: Text(dialogService.profilePageState.profilePicture == null ? 'Upload a picture' : 'Change Profile Picture'),
  //                   onPressed: () async {
  //                     dialogService.completeAndCloseDialog(null);
  //                     await dialogService.showDialogeOfChoosingImageSource();
  //                   },
  //                 ),
  //               ]),
  //               actions: <Widget>[
  //                 FlatButton(
  //                   child: Text('Close'),
  //                   onPressed: () {
  //                     dialogService.completeAndCloseDialog(null);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           )));
  // }

// show dialog of profile picture
//   void _showDialogOfCoverPicture() {
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => dialogWrapper(
//             closingCallback: () => dialogService.completeAndCloseDialog(null),
//             child: Builder(
//               builder: (context) => AlertDialog(
//                 content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                   if (dialogService.profilePageState.coverPicture != null)
//                     FlatButton(
//                       child: Text('View Profile Picture'),
//                       onPressed: () {
//                         dialogService.completeAndCloseDialog(null);
//                         Navigator.of(context).pushNamed('/view-cover-picture');
//                       },
//                     ),
//                   FlatButton(
//                     child: Text(dialogService.profilePageState.coverPicture == null ? 'upload a cover picture' : 'Change Profile Picture'),
//                     onPressed: () async {
//                       dialogService.completeAndCloseDialog(null);
//                       await dialogService.showDialogeOfChoosingImageSource();
//                     },
//                   ),
//                 ]),
//                 actions: <Widget>[
//                   FlatButton(
//                     child: Text('Close'),
//                     onPressed: () {
//                       dialogService.completeAndCloseDialog(null);
//                     },
//                   ),
//                 ],
//               ),
//             )));
//   }

  // Future<void> _showDialogeOfProfileEditingInfo() async {
  //   String firstName;
  //   String lastName;
  //   String email;
  //
  //   formKey = new GlobalKey<FormState>();
  //
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => dialogWrapper(
  //           closingCallback: () => dialogService.completeAndCloseDialog(null),
  //           child: AlertDialog(
  //             contentPadding: EdgeInsets.all(ScreenUtil().setSp(65)),
  //             title: Text('Update personal info'),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(ScreenUtil().setSp(15)),
  //             ),
  //             content: Form(
  //               key: formKey,
  //               child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //                 TextFormField(
  //                   maxLength: 11,
  //                   initialValue: dialogService.profilePageState.userData.commonFields.firstName,
  //                   validator: (val) {
  //                     if (val.trim().isEmpty) {
  //                       return 'this field is required';
  //                     } else if (val.trim().length < 3) {
  //                       return 'this field must be at least 3 characters long';
  //                     } else if (val.trim().length > 11) {
  //                       return 'this field must not be longer than 11 characters';
  //                     } else
  //                       return null;
  //                   },
  //                   onSaved: (val) {
  //                     firstName = val;
  //                   },
  //                   decoration: InputDecoration(labelText: 'FirstName'),
  //                 ),
  //                 TextFormField(
  //                   maxLength: 11,
  //                   initialValue: dialogService.profilePageState.userData.commonFields.lastName,
  //                   validator: (val) {
  //                     if (val.trim().isEmpty) {
  //                       return 'this field is required';
  //                     } else if (val.trim().length < 3) {
  //                       return 'this field must be at least 3 characters long';
  //                     } else if (val.trim().length > 11) {
  //                       return 'this field must not be longer than 11 characters';
  //                     } else
  //                       return null;
  //                   },
  //                   onSaved: (val) {
  //                     lastName = val;
  //                   },
  //                   decoration: InputDecoration(labelText: 'LastName'),
  //                 ),
  //                 TextFormField(
  //                   initialValue: dialogService.profilePageState.userData.commonFields.email,
  //                   validator: (val) {
  //                     if (val.trim().isEmpty) {
  //                       return 'this field is required';
  //                     } else if (!val.trim().contains('@')) {
  //                       return 'Please provide a valid email';
  //                     } else
  //                       return null;
  //                   },
  //                   onSaved: (val) {
  //                     email = val;
  //                   },
  //                   decoration: InputDecoration(labelText: 'Email'),
  //                 ),
  //               ]),
  //             ),
  //             actions: <Widget>[
  //               Builder(
  //                 builder: (ctx) => RaisedButton(
  //                   child: Text('cancel'),
  //                   onPressed: () {
  //                     dialogService.completeAndCloseDialog(null);
  //                   },
  //                 ),
  //               ),
  //               SizedBox(width: ScreenUtil().setWidth(30)),
  //               RaisedButton(
  //                 color: Colors.blueAccent,
  //                 child: Text(
  //                   'Update',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //                 onPressed: () async {
  //                   if (formKey.currentState.validate()) {
  //                     print('data is valid');
  //                     formKey.currentState.save();
  //                     Map<String, String> updates = {'firstName': firstName, 'lastName': lastName, 'email': email};
  //
  //                     ContractResponse response = await DialogManagerUseCases.updatePersonalInfo(updates);
  //                     dialogService.completeAndCloseDialog(null);
  //                     if (response is SnackBarException) {
  //                       if (response is AuthorizationBreaking) {
  //                         print('inside the authorization checking');
  //                         Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (_) => false);
  //                       } else {
  //                         print('inside checking the response type');
  //                         await showDialogOfFailure(message: response.message);
  //                       }
  //                     } else if (response is Success) {
  //                       showDialogOfSuccess();
  //                       Future.delayed(Duration(seconds: 4), () => dialogService.completeAndCloseDialog(null));
  //                     } else {
  //                       showDialogOfFailure(message: response.message);
  //                     }
  //                   }
  //                 },
  //               ),
  //               SizedBox(width: ScreenUtil().setWidth(20)),
  //             ],
  //           )));
  // }

  // show dialog of uploading video for schools
  // void _showDialogOfUploadingVideoForSchools() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => dialogWrapper(
  //         closingCallback: () => dialogService.completeAndCloseDialog(null),
  //         child: Builder(
  //           builder: (context) => UploadingVideoBodyForSchools(),
  //         )),
  //   );
  // }

  // // show dialog of uploading lecture for schools
  // void _showDialogOfUploadingLectureForSchools() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => dialogWrapper(
  //         closingCallback: () => dialogService.completeAndCloseDialog(null),
  //         child: Builder(
  //           builder: (context) => UploadingLectureBodyForSchools(),
  //         )),
  //   );
  // }

  // // show dialog of uploading lecture for universities
  // void _showDialogOfUploadingLectureForUniversities() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => dialogWrapper(
  //         closingCallback: () => dialogService.completeAndCloseDialog(null),
  //         child: Builder(
  //           builder: (context) => UploadingLectureBodyForUniversities(),
  //         )),
  //   );
  // }

  // // show dialog of uploading video for universities
  // void _showDialogOfUploadingVideoForUniversities() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => dialogWrapper(
  //         closingCallback: () => dialogService.completeAndCloseDialog(null),
  //         child: Builder(
  //           builder: (context) => UploadingVideoBodyForUniversities(),
  //         )),
  //   );
  // }

  Future<void> showDialogOfSuccess({@required String message}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(100),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1)),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  if (message != null)
                    Align(
                      alignment: Alignment.center,
                      child: Text(message),
                    ),
                ],
              ),
            )));
  }

  Future<void> showDialogOfFailure({String message}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(15)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.error_outline, size: ScreenUtil().setSp(100)),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Text('Oops!!'),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  Container(
                      constraints: BoxConstraints(),
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () => dialogService.completeAndCloseDialog(null),
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )));
  }

  Widget dialogWrapper({Function closingCallback, Widget child}) {
    return WillPopScope(
      child: child,
      onWillPop: () {
        closingCallback();
        return Future.value(false);
      },
    );
  }

  void showDialogOfUploading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => dialogWrapper(
            closingCallback: () {},
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
              ),
              child: Container(
                height: ScreenUtil().setHeight(400),
                padding: EdgeInsets.all(ScreenUtil().setSp(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Uploading ... please wait',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(50)),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              ),
            )));
  }

  void showDialogOfLoading({String message}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => dialogWrapper(
            closingCallback: () {},
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
              ),
              child: Container(
                height: ScreenUtil().setHeight(400),
                padding: EdgeInsets.all(ScreenUtil().setSp(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${message ?? 'Loading'}... please wait',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(50)),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              ),
            )));
  }

  // showDialogOfLoadingPDF() {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => dialogWrapper(
  //           closingCallback: () {},
  //           child: Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(
  //                 ScreenUtil().setSp(20),
  //               ),
  //             ),
  //             child: Selector<PdfViewerState, int>(
  //                 selector: (context, stateProvider) => stateProvider.progress,
  //                 builder: (context, progress, __) {
  //                   return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //                     Text(
  //                       'Loading  $progress %',
  //                     ),
  //                     LinearProgressIndicator(
  //                       value: double.parse('$progress.0'),
  //                     )
  //                   ]);
  //                 }),
  //           )));
  // }
}
