import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../../../core/references/references.dart';
import '../../../../../state_provider/user_info_provider.dart';
import '../../quizes/quiz_uploader/quiz_semester_widget.dart';
import '../state_providers/college_uploads_state_provider.dart';
import 'widgets/college_uploading_choose_topic.dart';
import 'widgets/target_collge_stage_widget.dart';







class CollegeVideoUploadingFormWidget extends StatefulWidget {
  @override
  _CollegeVideoUploadingFormState createState() => _CollegeVideoUploadingFormState();
}

class _CollegeVideoUploadingFormState extends State<CollegeVideoUploadingFormWidget> {
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String title, description, videoId;


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
                          if (val.trim().isEmpty) {
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
                          if (val.trim().isEmpty) {
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
                      if (locator<UserInfoStateProvider>().userData.accountType != 'unistudents')
                        CollegeChooseStageWidget(focusNodes: [titleFocusNode, descriptionFocusNode, videoLinkFocusNode]),
                      if (HelperFucntions.isPharmacyOrMedicine()) QuizSemesterWidget<CollegeUploadingState>(),
                      if (HelperFucntions.isPharmacyOrMedicine() ||
                          locator<UserInfoStateProvider>().userData.accountType != 'unistudents')
                        SizedBox(
                          height: ScreenUtil().setHeight(80),
                        ),
                      CollegeChooseTopicWidget(),
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
      await collegeUploadingState.upload();
    }
  }
}
