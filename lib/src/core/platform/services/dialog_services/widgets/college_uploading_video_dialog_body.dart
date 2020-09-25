import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/services/material_uploading/college_uploads_state_provider.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_semester_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'package:malzama/src/features/verify_your_email/presentation/validate_your_account_msg.dart';
import 'package:provider/provider.dart';

import '../dialog_service.dart';
import '../service_locator.dart';
import 'college_uploading_choose_target_stage.dart';
import 'college_uploading_choose_topic.dart';

class UploadingVideoBodyForUniversities extends StatefulWidget {
  @override
  _UploadingVideoBodyForUniversitiesState createState() => _UploadingVideoBodyForUniversitiesState();
}

class _UploadingVideoBodyForUniversitiesState extends State<UploadingVideoBodyForUniversities> {
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String title, description, videoId;
  DialogService dialogService;

  FocusNode titleFocusNode;
  FocusNode descriptionFocusNode;
  FocusNode videoLinkFocusNode;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    CollegeUploadingState collegeUploadingState = Provider.of<CollegeUploadingState>(context, listen: false);
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setSp(60)),
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
                padding: EdgeInsets.only(left: ScreenUtil().setSp(70), right: ScreenUtil().setSp(70)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Upload new video',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(60),
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      TextFormField(
                        maxLength: 40,
                        focusNode: titleFocusNode,
                        decoration: InputDecoration(labelText: 'title'),
                        validator: (val) {
                          if (val
                              .trim()
                              .isEmpty) {
                            return 'this field is required';
                          }
                          return null;
                        },
                        onSaved: (val) => collegeUploadingState.updateTitle(val),
                        onTap: () {
                          if (descriptionFocusNode.hasFocus) {
                            descriptionFocusNode.unfocus();
                          }
                          if (videoLinkFocusNode.hasFocus) {
                            videoLinkFocusNode.unfocus();
                          }
                        },
                      ),
                      TextFormField(
                        maxLength: 300,
                        maxLines: null,
                        focusNode: descriptionFocusNode,
                        decoration: InputDecoration(labelText: 'description'),
                        validator: (val) {
                          if (val
                              .trim()
                              .isEmpty) {
                            return 'this field is required';
                          }
                          return null;
                        },
                        onSaved: (val) => collegeUploadingState.updateDescription(val),
                        onTap: () {
                          if (titleFocusNode.hasFocus) {
                            titleFocusNode.unfocus();
                          }
                          if (videoLinkFocusNode.hasFocus) {
                            videoLinkFocusNode.unfocus();
                          }
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(50),
                      ),
                      if (dialogService.profilePageState.userData.commonFields.account_type != 'unistudents') TargetCollegeStage(
                          focusNodes: [titleFocusNode, descriptionFocusNode, videoLinkFocusNode]),
                      if (isPharmacyOrMedicine(dialogService.profilePageState)) QuizSemesterWidget<CollegeUploadingState>(),
                      if (isPharmacyOrMedicine(dialogService.profilePageState) || dialogService.profilePageState.userData.commonFields.account_type != 'unistudents')
                        SizedBox(
                          height: ScreenUtil().setHeight(80),
                        ),
                      CollegeUploadingChooseTopic(),
                      SizedBox(
                        height: ScreenUtil().setHeight(80),
                      ),
                      TextFormField(
                        focusNode: videoLinkFocusNode,
                        decoration: InputDecoration(labelText: 'video link from youTube'),
                        keyboardType: TextInputType.url,
                        validator: (link) => References.validateYoutubeLink(link),
                        onSaved: (link) => collegeUploadingState.updateVideoId(References.getVideoIDFrom(youTubeLink: link)),
                        onTap: () {
                          // make sure that all fields that have focus will be unfocused
                          if (titleFocusNode.hasFocus) titleFocusNode.unfocus();
                          if (descriptionFocusNode.hasFocus) descriptionFocusNode.unfocus();
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(100)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(50)),
                          RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: () => _handleOnPressed(collegeUploadingState),
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
        ));
  }

  // get called when the user hit the upload button
  Future<void> _handleOnPressed(CollegeUploadingState collegeUploadingState) async {
    // un focus all the fields that has focus
    titleFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    videoLinkFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState.validate())) {
      /// the form fields (all or some) are not valid
      print('Enter a valid data');
    } else {
      print('the form is valid and the data will be send to the server');
      /// save the fields of the form
      _formKey.currentState.save();
      ContractResponse response = await collegeUploadingState.upload();
      if (response is Success) {
        Navigator.of(context).pop();
        locator.get<DialogService>().showDialogOfSuccess(message: 'Your video uploaded Successfully');
      }else{
        _scaffoldKey.currentState.showSnackBar(getSnackBar(response.message));
      }
    }
  }
}
