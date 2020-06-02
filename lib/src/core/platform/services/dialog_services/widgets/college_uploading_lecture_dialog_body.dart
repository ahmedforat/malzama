import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/college_uploading_choose_target_stage.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/college_uploading_choose_topic.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_semester_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'package:provider/provider.dart';

import '../dialog_service.dart';
import '../service_locator.dart';
import '../dialog_state_providers/college_uploads_state_provider.dart';



class UploadingLectureBodyForUniversities extends StatefulWidget {
  @override
  _UploadingLectureBodyForUniversitiesState createState() => _UploadingLectureBodyForUniversitiesState();
}

class _UploadingLectureBodyForUniversitiesState extends State<UploadingLectureBodyForUniversities> {
  GlobalKey<FormState> _formKey;
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
                    child: Text('Upload new lecture', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60))),
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
                  if (dialogService.profilePageState.userData.commonFields.account_type == 'uniteachers') TargetCollegeStage(focusNodes: [titleFocusNode, descriptionFocusNode]),
                  if (dialogService.profilePageState.userData.commonFields.account_type == 'uniteachers')
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                  if (isPharmacyOrMedicine(dialogService.profilePageState)) QuizSemesterWidget<CollegeUploadingState>(),
                  if (isPharmacyOrMedicine(dialogService.profilePageState))
                    SizedBox(
                      height: ScreenUtil().setHeight(80),
                    ),
                  CollegeUploadingChooseTopic(),
                  SizedBox(
                    height: ScreenUtil().setHeight(80),
                  ),
                  Consumer<CollegeUploadingState>(
                    builder: (context, stateProvider, _) => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color: Colors.amber,
                          onPressed: () async {
                            // ANCHOR filePicker
                            File lecture = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['pdf']);
                            stateProvider.updateLectureToUpload(lecture);
                          },
                          child: Text(
                              stateProvider.lectureToUpload == null
                                  ? 'Tap here to choose File'
                                  : stateProvider.lectureToUpload.path.split('/').last.length > 40
                                  ? stateProvider.lectureToUpload.path.split('/').last.substring(0, 40)
                                  : stateProvider.lectureToUpload.path.split('/').last,
                              textAlign: TextAlign.center)),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(100)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Provider.of<CollegeUploadingState>(context, listen: false).setAllFieldsToNull();
                          dialogService.completeAndCloseDialog(null);
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(50)),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () async {
                          CollegeUploadingState collegeUploadingState = Provider.of<CollegeUploadingState>(context, listen: false);
                          print('we are here inside uploading');
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();

                            _formKey.currentState.save();
                            final Map<String, dynamic> lectureData = {
                              'title': title,
                              'description': description,
                              'stage': References.stagesMapper.entries.firstWhere((item) => item.value == collegeUploadingState.stage).value,
                              'section': dialogService.profilePageState.userData.college,
                              'src': collegeUploadingState.lectureToUpload
                            };

                            if (collegeUploadingState.semester != null) {
                              lectureData['semester'] = collegeUploadingState.semester;
                            }

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
