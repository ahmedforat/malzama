import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_state_providers/college_uploads_state_provider.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_semester_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
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
                    child: Text(
                      'Upload new video',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(60),
                      ),
                    ),
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
                      if (descriptionFocusNode.hasFocus) descriptionFocusNode.unfocus();
                      if (videoLinkFocusNode.hasFocus) videoLinkFocusNode.unfocus();
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
                      if (videoLinkFocusNode.hasFocus) videoLinkFocusNode.unfocus();
                    },
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(80),
                  ),
                  if (dialogService.profilePageState.userData.commonFields.account_type != 'unistudents') TargetCollegeStage(focusNodes: [titleFocusNode, descriptionFocusNode, videoLinkFocusNode]),
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
                    onSaved: (link) => videoId = References.getVideoIDFrom(youTubeLink: link),
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
                        onPressed: () {
                          print('canceling the video uploading dialog and reseting all the fields to null');

                          // set all fields of the college uploading state to null
                          Provider.of<CollegeUploadingState>(context, listen: false).setAllFieldsToNull();

                          // close the dialog and complete the future with null
                          dialogService.completeAndCloseDialog(null);
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(50)),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () async {
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
                            CollegeUploadingState videoState = Provider.of<CollegeUploadingState>(context, listen: false);

                            /// save the fields of the form
                            _formKey.currentState.save();

                            // video data the will be send to the server
                            Map<String, String> videoData = {
                              'title': title,
                              'description': description,
                              'videoId': videoId,
                              'stage': videoState.stage.toString(),
                              'topic': videoState.topic,
                            };

                            print(videoData);

                            /// close the dialog and complete the future with [videoData]
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
