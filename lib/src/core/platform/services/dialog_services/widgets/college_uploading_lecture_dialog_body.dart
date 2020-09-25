import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/features/verify_your_email/presentation/validate_your_account_msg.dart';
import 'package:provider/provider.dart';

import '../../../../../features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_semester_widget.dart';
import '../../../../../features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import '../../material_uploading/college_uploads_state_provider.dart';
import '../dialog_service.dart';
import '../service_locator.dart';
import 'college_uploading_choose_target_stage.dart';
import 'college_uploading_choose_topic.dart';

class UploadingLectureBodyForUniversities extends StatefulWidget {
  @override
  _UploadingLectureBodyForUniversitiesState createState() => _UploadingLectureBodyForUniversitiesState();
}

class _UploadingLectureBodyForUniversitiesState extends State<UploadingLectureBodyForUniversities> {
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String title, description;

  FocusNode titleFocusNode;
  FocusNode descriptionFocusNode;
  DialogService dialogService;

  @override
  void initState() {
    super.initState();
    titleFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    _formKey = new GlobalKey<FormState>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    CollegeUploadingState stateProvider = Provider.of<CollegeUploadingState>(context, listen: false);
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setSp(65)),
          child: GestureDetector(
            onTap: () {
              titleFocusNode.unfocus();
              descriptionFocusNode.unfocus();
              FocusScope.of(context).unfocus();
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: ScreenUtil().setSp(70), right: ScreenUtil().setSp(70)),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Upload new lecture',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(60),
                          ),
                        ),
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
                        onSaved: (val) => stateProvider.updateTitle(val),
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
                        onSaved: (val) => stateProvider.updateDescription(val),
                      ),
                      if (dialogService.profilePageState.userData.commonFields.account_type == 'uniteachers')
                        TargetCollegeStage(
                          focusNodes: [titleFocusNode, descriptionFocusNode],
                        ),
                      if (dialogService.profilePageState.userData.commonFields.account_type == 'uniteachers')
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                      if (isPharmacyOrMedicine(dialogService.profilePageState)) QuizSemesterWidget<CollegeUploadingState>(),
                      if (isPharmacyOrMedicine(dialogService.profilePageState))
                        SizedBox(
                          height: ScreenUtil().setHeight(50),
                        ),
                      CollegeUploadingChooseTopic(),
                      SizedBox(
                        height: ScreenUtil().setHeight(80),
                      ),
                      RaisedButton(
                          color: Colors.amber,
                          onPressed: () async {
                            String message = await stateProvider.pickLectureToUpload();
                            if (message.isNotEmpty) {
                              _scaffoldKey.currentState.showSnackBar(
                                getSnackBar(message),
                              );
                            }
                          },
                          child: Selector<CollegeUploadingState, String>(
                            selector: (context, stateObject) => stateObject.uploadButtonText,
                            builder: (context, buttonText, child) => Text(
                              buttonText,
                              textAlign: TextAlign.center,
                            ),
                          )),
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(50),
                          ),
                          RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: () => _handleOnPressed(stateProvider),
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
  Future<void> _handleOnPressed(CollegeUploadingState stateProvider) async {
    print('we are here inside uploading');
    if (_formKey.currentState.validate()) {
      titleFocusNode.unfocus();
      descriptionFocusNode.unfocus();
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();

      ContractResponse response = await stateProvider.upload();
      if (response is Success) {
        Navigator.of(context).pop();
        locator.get<DialogService>().showDialogOfSuccess(message: 'Your Lecture Uploaded Successfully');
      } else {
        _scaffoldKey.currentState.showSnackBar(getSnackBar(response.message));
      }
    } else {
      print('invalid data');
    }
  }
}
