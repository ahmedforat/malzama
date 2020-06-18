import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_state_providers/school_uploads_state_provider.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:provider/provider.dart';

import '../dialog_service.dart';
import '../service_locator.dart';
import 'school_uploading_choose_school_section.dart';
import 'school_uploading_choose_school_stage.dart';



class UploadingVideoBodyForSchools extends StatefulWidget {
  @override
  _UploadingVideoBodyForSchoolsState createState() => _UploadingVideoBodyForSchoolsState();
}

class _UploadingVideoBodyForSchoolsState extends State<UploadingVideoBodyForSchools> {
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
                  TargetSchoolStage(focusNodes: [titleFocusNode, descriptionFocusNode, videoLinkFocusNode]),
                  TargetSchoolSection(focusNodes: [titleFocusNode, descriptionFocusNode, videoLinkFocusNode]),
                  SizedBox(
                    height: ScreenUtil().setHeight(80),
                  ),
                  TextFormField(
                    focusNode: videoLinkFocusNode,
                    decoration: InputDecoration(labelText: 'video link from youTube'),
                    keyboardType: TextInputType.text,
                    validator: (link) => References.validateYoutubeLink(link),
                    onSaved: (link) => videoId = References.getVideoIDFrom(youTubeLink: link),
                    onTap: () {
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
                          Provider.of<SchoolUploadState>(context, listen: false).setAllFieldsToNull();
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
                            SchoolUploadState videoState = Provider.of<SchoolUploadState>(context, listen: false);
                            _formKey.currentState.save();

                            Map<String, String> videoData = {
                              'title': title,
                              'description': description,
                              'videoId': videoId,
                              'stage': (6 - References.schoolStages.indexOf(videoState.targetStage)).toString(),
                              'school_section': videoState.targetSchoolSection,
                              'topic':dialogService.profilePageState.userData.speciality
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


