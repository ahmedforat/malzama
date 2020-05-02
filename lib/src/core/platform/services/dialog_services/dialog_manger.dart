import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/teacher_access_object.dart';
import 'package:malzama/src/features/home/presentation/state_provider/my_materials_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/pdf_viewer_state_provider.dart';
import 'package:malzama/src/features/signup/usecases/signup_usecase.dart';
import 'package:provider/provider.dart';

import '../../../../features/home/presentation/state_provider/profile_page_state_provider.dart';
import '../../../api/contract_response.dart';
import '../../../references/references.dart';
import 'dialog_service.dart';
import 'dialog_state_provider.dart';
import 'service_locator.dart';
import 'use_cases.dart';

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
    dialogService.registerCloseDialogListner(_closeDialog);
    dialogService
        .registerShowDialogOfProfilePicture(_showDialogOfProfilePicture);
    dialogService.registerShowDialogOfChoosingImageSource(
        _showDialogOfChoosingImageSource);
    dialogService.registerShowDialogOfCoverPicture(_showDialogOfCoverPicture);
    dialogService
        .registerShowDialogOfEditingInfo(_showDialogeOfProfileEditingInfo);

    dialogService
        .registerShowDialogOfUploadingVideo(_showDialogOfUploadingVideo);

    dialogService
        .registerShowDialogOfUploadingLecture(_showDialogOfUploadingLecture);

    dialogService.registerShowDialogOfLoadingPDF(showDialogOfLoadingPDF);

    dialogService.registerShowDialogOfSuccess(showDialogOfSuccess);
    dialogService.registerShowDialogOfUploading(showDialogOfUploading);
    dialogService.registerShowDialogOfFailure(showDialogOfFailure);
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

  Future<void> _showDialogOfChoosingImageSource() {
    print(dialogService.profilePageState.userData);
    print('this is the target == ' +
        dialogService.profilePageState.target.toString());
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
              actions: <Widget>[
                FlatButton(
                    child: Text('Close'),
                    onPressed: () =>
                        dialogService.completeAndCloseDialog(null)),
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Choose image source'),
                  SizedBox(
                    height: ScreenUtil().setHeight(60),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.photo_camera),
                        onPressed: () async {
                          File newPhoto = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          if (newPhoto != null) {
                            if (dialogService.profilePageState.target ==
                                'profilePicture') {
                              await dialogService.profilePageState
                                  .updateProfilePicture(update: newPhoto);
                              dialogService.completeAndCloseDialog(null);
                            } else {
                              await dialogService.profilePageState
                                  .updateCoverPicture(update: newPhoto);
                              dialogService.completeAndCloseDialog(null);
                            }
                          }
                        },
                      ),
                      FlatButton(
                        child: Icon(Icons.photo_library),
                        onPressed: () async {
                          File newPhoto = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (newPhoto != null) {
                            await dialogService.profilePageState
                                .updateProfilePicture(update: newPhoto);
                            dialogService.completeAndCloseDialog(null);
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  void _showDialogOfProfilePicture() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: Builder(
              builder: (context) => AlertDialog(
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  if (dialogService.profilePageState.profilePicture != null)
                    FlatButton(
                      child: Text('View Profile Picture'),
                      onPressed: () {
                        dialogService.completeAndCloseDialog(null);
                        Navigator.of(context)
                            .pushNamed('/display-profile-picture');
                      },
                    ),
                  FlatButton(
                    child: Text(
                        dialogService.profilePageState.profilePicture == null
                            ? 'Upload a picture'
                            : 'Change Profile Picture'),
                    onPressed: () async {
                      dialogService.completeAndCloseDialog(null);
                      await dialogService.showDialogeOfChoosingImageSource();
                    },
                  ),
                ]),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      dialogService.completeAndCloseDialog(null);
                    },
                  ),
                ],
              ),
            )));
  }

// show dialog of profile picture
  void _showDialogOfCoverPicture() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: Builder(
              builder: (context) => AlertDialog(
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  if (dialogService.profilePageState.coverPicture != null)
                    FlatButton(
                      child: Text('View Profile Picture'),
                      onPressed: () {
                        dialogService.completeAndCloseDialog(null);
                        Navigator.of(context).pushNamed('/view-cover-picture');
                      },
                    ),
                  FlatButton(
                    child: Text(
                        dialogService.profilePageState.coverPicture == null
                            ? 'upload a cover picture'
                            : 'Change Profile Picture'),
                    onPressed: () async {
                      dialogService.completeAndCloseDialog(null);
                      await dialogService.showDialogeOfChoosingImageSource();
                    },
                  ),
                ]),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      dialogService.completeAndCloseDialog(null);
                    },
                  ),
                ],
              ),
            )));
  }

  Future<void> _showDialogeOfProfileEditingInfo() async {
    String firstName;
    String lastName;
    String email;

    formKey = new GlobalKey<FormState>();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: AlertDialog(
              contentPadding: EdgeInsets.all(ScreenUtil().setSp(65)),
              title: Text('Update personal info'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(15)),
              ),
              content: Form(
                key: formKey,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  TextFormField(
                    maxLength: 11,
                    initialValue: dialogService
                        .profilePageState.userData.commonFields.firstName,
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return 'this field is required';
                      } else if (val.trim().length < 3) {
                        return 'this field must be at least 3 characters long';
                      } else if (val.trim().length > 11) {
                        return 'this field must not be longer than 11 characters';
                      } else
                        return null;
                    },
                    onSaved: (val) {
                      firstName = val;
                    },
                    decoration: InputDecoration(labelText: 'FirstName'),
                  ),
                  TextFormField(
                    maxLength: 11,
                    initialValue: dialogService
                        .profilePageState.userData.commonFields.lastName,
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return 'this field is required';
                      } else if (val.trim().length < 3) {
                        return 'this field must be at least 3 characters long';
                      } else if (val.trim().length > 11) {
                        return 'this field must not be longer than 11 characters';
                      } else
                        return null;
                    },
                    onSaved: (val) {
                      lastName = val;
                    },
                    decoration: InputDecoration(labelText: 'LastName'),
                  ),
                  TextFormField(
                    initialValue: dialogService
                        .profilePageState.userData.commonFields.email,
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return 'this field is required';
                      } else if (!val.trim().contains('@')) {
                        return 'Please provide a valid email';
                      } else
                        return null;
                    },
                    onSaved: (val) {
                      email = val;
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                ]),
              ),
              actions: <Widget>[
                Builder(
                  builder: (ctx) => RaisedButton(
                    child: Text('cancel'),
                    onPressed: () {
                      dialogService.completeAndCloseDialog(null);
                    },
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(30)),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      print('data is valid');
                      formKey.currentState.save();
                      Map<String, String> updates = {
                        'firstName': firstName,
                        'lastName': lastName,
                        'email': email
                      };

                      ContractResponse response =
                          await DialogManagerUseCases.updatePersonalInfo(
                              updates);
                      dialogService.completeAndCloseDialog(null);
                      if (response is SnackBarException) {
                        if (response is AuthorizationBreaking) {
                          print('inside the authorization checking');
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/signup-page', (_) => false);
                        } else {
                          print('inside checking the response type');
                          await showDialogOfFailure(message: response.message);
                        }
                      } else if (response is Success) {
                        showDialogOfSuccess();
                        Future.delayed(Duration(seconds: 4),
                            () => dialogService.completeAndCloseDialog(null));
                      } else {
                        showDialogOfFailure(message: response.message);
                      }
                    }
                  },
                ),
                SizedBox(width: ScreenUtil().setWidth(20)),
              ],
            )));
  }

  void _showDialogOfUploadingVideo() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => dialogWrapper(
          closingCallback: () => dialogService.completeAndCloseDialog(null),
          child: Builder(
            builder: (context) => UploadingVideoBody(),
          )),
    );
  }

  void _showDialogOfUploadingLecture() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => dialogWrapper(
          closingCallback: () => dialogService.completeAndCloseDialog(null),
          child: Builder(
            builder: (context) => UploadingLectureBody(),
          )),
    );
  }

  Future<void> showDialogOfSuccess({String message}) {
    showDialog(
        context: context,
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
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1)),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(50)),
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

  showDialogOfLoadingPDF() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => dialogWrapper(
            closingCallback: () {},
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setSp(20),
                ),
              ),
              child: Selector<PdfViewerState, int>(
                  selector: (context, stateProvider) => stateProvider.progress,
                  builder: (context, progress, __) {
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Loading  $progress %',
                          ),
                          LinearProgressIndicator(
                            value: double.parse('$progress.0'),
                          )
                        ]);
                  }),
            )));
  }
}

class TargetStage extends StatelessWidget {
  final List<FocusNode> focusNodes;

  TargetStage({@required this.focusNodes});

  @override
  Widget build(BuildContext context) {
    SchoolUploadState profilePageState =
        Provider.of<SchoolUploadState>(context, listen: false);
    ScreenUtil.init(context);
    return Selector<SchoolUploadState, String>(
      selector: (context, stateProvider) => stateProvider.targetStage,
      builder: (context, schoolStage, _) => GestureDetector(
        onTap: () => focusNodes.forEach((node) => node.unfocus()),
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                    validator: (data) {
                      if (data == null)
                        return 'this field is required';
                      else
                        return null;
                    },
                    items: References.schoolStages.map((String stage) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          '$stage  ',
                          //style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: stage,
                      );
                    }).toList(),
                    onChanged: (update) {
                      print(update);
                      profilePageState.updateTargetStage(update);
                    },
                    value: profilePageState.targetStage,
                    hint: Align(
                        alignment: Alignment.center,
                        child: Text('Target stage')),
                    selectedItemBuilder: (BuildContext context) {
                      return References.schoolStages.map<Widget>((String item) {
                        return Align(
                            alignment: Alignment.center,
                            child: Text(
                              item + ' ',
                              textAlign: TextAlign.center,
                            ));
                      }).toList();
                    },
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TargetSchoolSection extends StatelessWidget {
  final List<FocusNode> focusNodes;

  TargetSchoolSection({@required this.focusNodes});

  @override
  Widget build(BuildContext context) {
    SchoolUploadState profilePageState =
        Provider.of<SchoolUploadState>(context, listen: false);
    ScreenUtil.init(context);
    return Selector<SchoolUploadState, String>(
      selector: (context, stateProvider) => stateProvider.targetSchoolSection,
      builder: (context, schoolStage, _) => GestureDetector(
        onTap: () => focusNodes.forEach((node) => node.unfocus()),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                    validator: (data) {
                      if (data == null)
                        return 'this field is required';
                      else
                        return null;
                    },
                    items: References.schoolSections.map((String section) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          section.trim(),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          //style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: section,
                      );
                    }).toList(),
                    onChanged: (update) {
                      print(update);
                      profilePageState.updateTargetSchoolSection(update);
                    },
                    value: profilePageState.targetSchoolSection,
                    hint: Align(
                        alignment: Alignment.center,
                        child: Text('Target section')),
                    // selectedItemBuilder: (BuildContext context) {
                    //   return References.schoolSections.map<Widget>((String item) {
                    //     return Align(
                    //         alignment: Alignment.center,
                    //         child: Text(
                    //           item.trim() ,
                    //           textAlign: TextAlign.right

                    //         ));
                    //   }).toList();
                    // },
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadingVideoBody extends StatefulWidget {
  @override
  _UploadingVideoBodyState createState() => _UploadingVideoBodyState();
}

class _UploadingVideoBodyState extends State<UploadingVideoBody> {
  GlobalKey<FormState> _formKey;
  String title, description, videoId;
  DialogService dialogService;

  FocusNode titleFocusNode;
  FocusNode descriptionFocusNode;
  FocusNode videoLinkFocusNode;

  @override
  void initState() {
    super.initState();
    titleFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    videoLinkFocusNode = new FocusNode();
    _formKey = new GlobalKey<FormState>();
    dialogService = locator.get<DialogService>();
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    videoLinkFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
      ),
      child: GestureDetector(
        onTap: () {
          titleFocusNode.unfocus();
          descriptionFocusNode.unfocus();
          videoLinkFocusNode.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(70)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Upload new video',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(60))),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(50)),
                  TextFormField(
                    maxLength: 40,
                    focusNode: titleFocusNode,
                    decoration: InputDecoration(labelText: 'title'),
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return 'this field is required';
                      }
                      return null;
                    },
                    onSaved: (val) => title = val,
                    onTap: () {
                      if (descriptionFocusNode.hasFocus)
                        descriptionFocusNode.unfocus();
                      if (videoLinkFocusNode.hasFocus)
                        videoLinkFocusNode.unfocus();
                    },
                  ),
                  TextFormField(
                    maxLength: 300,
                    maxLines: null,
                    focusNode: descriptionFocusNode,
                    decoration: InputDecoration(labelText: 'description'),
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return 'this field is required';
                      }
                      return null;
                    },
                    onSaved: (val) => description = val,
                    onTap: () {
                      if (titleFocusNode.hasFocus) titleFocusNode.unfocus();
                      if (videoLinkFocusNode.hasFocus)
                        videoLinkFocusNode.unfocus();
                    },
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(80),
                  ),
                  TargetStage(focusNodes: [
                    titleFocusNode,
                    descriptionFocusNode,
                    videoLinkFocusNode
                  ]),
                  TargetSchoolSection(focusNodes: [
                    titleFocusNode,
                    descriptionFocusNode,
                    videoLinkFocusNode
                  ]),
                  SizedBox(
                    height: ScreenUtil().setHeight(80),
                  ),
                  TextFormField(
                    focusNode: videoLinkFocusNode,
                    decoration:
                        InputDecoration(labelText: 'video link from youTube'),
                    keyboardType: TextInputType.text,
                    validator: (link) => References.validateYoutubeLink(link),
                    onSaved: (link) =>
                        videoId = References.getVideoIDFrom(youTubeLink: link),
                    onTap: () {
                      if (titleFocusNode.hasFocus) titleFocusNode.unfocus();
                      if (descriptionFocusNode.hasFocus)
                        descriptionFocusNode.unfocus();
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(100)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Provider.of<SchoolUploadState>(context, listen: false)
                              .setAllFieldsToNull();
                          dialogService.completeAndCloseDialog(null);
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(50)),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () async {
                          titleFocusNode.unfocus();
                          descriptionFocusNode.unfocus();
                          videoLinkFocusNode.unfocus();
                          FocusScope.of(context).unfocus();

                          if (!(_formKey.currentState.validate())) {
                            // do nothing
                            print('Enter a valid data');
                          } else {
                            print('Hello World');
                            SchoolUploadState videoState =
                                Provider.of<SchoolUploadState>(context,
                                    listen: false);
                            _formKey.currentState.save();

                            Map<String, String> videoData = {
                              'title': title,
                              'description': description,
                              'videoId': videoId,
                              'stage': videoState.targetStage,
                              'school_section': videoState.targetSchoolSection,
                            };

                            print(videoData);
                            dialogService.completeAndCloseDialog(videoData);
                          }
                        },
                        child: Text(
                          'upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UploadingLectureBody extends StatefulWidget {
  @override
  _UploadingLectureBodyState createState() => _UploadingLectureBodyState();
}

class _UploadingLectureBodyState extends State<UploadingLectureBody> {
  GlobalKey<FormState> _formKey;
  String title, description, stage, school_section;

  FocusNode titleFocusNode;
  FocusNode descriptionFocusNode;
  DialogService dialogService;

  @override
  void initState() {
    super.initState();
    titleFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    _formKey = new GlobalKey<FormState>();
    dialogService = locator.get<DialogService>();
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();

    print('the building body of uploading lecture has been disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
      ),
      child: GestureDetector(
        onTap: () {
          titleFocusNode.unfocus();
          descriptionFocusNode.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(70)),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Upload new lecture',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(60))),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(50)),
                  TextFormField(
                    focusNode: titleFocusNode,
                    maxLength: 40,
                    decoration: InputDecoration(
                      labelText: 'title',
                    ),
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return 'this field is required';
                      }
                      return null;
                    },
                    onSaved: (val) => title = val,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  TextFormField(
                    focusNode: descriptionFocusNode,
                    decoration: InputDecoration(
                      labelText: 'description',
                    ),
                    maxLines: null,
                    maxLength: 300,
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return 'this field is required';
                      }
                      return null;
                    },
                    onSaved: (val) => description = val,
                  ),
                  TargetStage(
                      focusNodes: [titleFocusNode, descriptionFocusNode]),
                  // SizedBox(
                  //   height: ScreenUtil().setHeight(30),
                  // ),
                  TargetSchoolSection(
                      focusNodes: [titleFocusNode, descriptionFocusNode]),
                  SizedBox(
                    height: ScreenUtil().setHeight(80),
                  ),
                  Consumer<SchoolUploadState>(
                    builder: (context, stateProvider, _) => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color: Colors.amber,
                          onPressed: () async {
                            // ANCHOR filePicker
                            File lecture = await FilePicker.getFile(
                                type: FileType.custom,
                                allowedExtensions: ['pdf']);
                            stateProvider.updateLectureToUpload(lecture);
                          },
                          child: Text(
                              stateProvider.lectureToUpload == null
                                  ? 'Tap here to choose File'
                                  : stateProvider.lectureToUpload.path
                                              .split('/')
                                              .last
                                              .length >
                                          40
                                      ? stateProvider.lectureToUpload.path
                                          .split('/')
                                          .last
                                          .substring(0, 40)
                                      : stateProvider.lectureToUpload.path
                                          .split('/')
                                          .last,
                              textAlign: TextAlign.center)),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(100)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Provider.of<SchoolUploadState>(context, listen: false)
                              .setAllFieldsToNull();
                          dialogService.completeAndCloseDialog(null);
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(50)),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () async {
                          SchoolUploadState lectureState =
                              Provider.of<SchoolUploadState>(context,
                                  listen: false);
                          print('we are here inside uploading');
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();

                            _formKey.currentState.save();
                            final Map<String, dynamic> lectureData = {
                              'title': title,
                              'description': description,
                              'stage': lectureState.targetStage,
                              'school_section':
                                  lectureState.targetSchoolSection,
                              'src': lectureState.lectureToUpload
                            };

                            dialogService.completeAndCloseDialog(lectureData);
                          } else {
                            print('invalid data');
                          }
                        },
                        child: Text(
                          'upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}