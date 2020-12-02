import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/upper_uploading_banner/college_uploading_pages/widgets/keep_the_same_uploaded_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../state_provider/user_info_provider.dart';
import '../../quizes/quiz_uploader/quiz_semester_widget.dart';
import '../state_providers/college_uploads_state_provider.dart';
import 'widgets/college_uploading_choose_topic.dart';
import 'widgets/target_collge_stage_widget.dart';

class CollegeLectureUploadingFormWidget extends StatefulWidget {
  @override
  _CollegeLectureUploadingFormState createState() => _CollegeLectureUploadingFormState();
}

class _CollegeLectureUploadingFormState extends State<CollegeLectureUploadingFormWidget> {
  GlobalKey<FormState> _formKey;
  String title, description;

  FocusNode titleFocusNode;
  FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();

    titleFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    _formKey = new GlobalKey<FormState>();

    print('init state of college lecture uploading');
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
    CollegeUploadingState collegeUploadingState = Provider.of<CollegeUploadingState>(context, listen: false);
    print(collegeUploadingState);
    print('building uploading page of collge lectures');
    return Scaffold(
        key:collegeUploadingState.scaffoldKey,
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
                        onSaved: (val) => collegeUploadingState.updateTitle(val),
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
                        onSaved: (val) => collegeUploadingState.updateDescription(val),
                      ),
                      if (locator<UserInfoStateProvider>().userData.accountType == 'uniteachers')
                        CollegeChooseStageWidget(
                          focusNodes: [titleFocusNode, descriptionFocusNode],
                        ),
                      if (locator<UserInfoStateProvider>().userData.accountType == 'uniteachers')
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                      if (HelperFucntions.isPharmacyOrMedicine()) QuizSemesterWidget<CollegeUploadingState>(),
                      if (HelperFucntions.isPharmacyOrMedicine())
                        SizedBox(
                          height: ScreenUtil().setHeight(50),
                        ),
                      CollegeChooseTopicWidget(),
                      SizedBox(
                        height: ScreenUtil().setHeight(80),
                      ),
                      if (collegeUploadingState.forEdit) KeepTheSameUploadedPdfFileWidget(),
                      Selector<CollegeUploadingState, List<bool>>(
                        selector: (context, state) => [
                          state.forEdit,
                          state.keepTheSameUploadedLecture,
                        ],
                        builder: (context, data, _) => RaisedButton(
                          color: Colors.amber,
                          onPressed: data[0] && data[1]
                              ? null
                              : () async {
                                  String message = await collegeUploadingState.pickLectureFile(context);
                                  if (message != null && message.isNotEmpty) {
                                    collegeUploadingState.showSnackBar(message);
                                  }
                                },
                          child: Selector<CollegeUploadingState, String>(
                            selector: (context, stateObject) => stateObject.uploadButtonText,
                            builder: (context, buttonText, child) => Text(
                              buttonText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
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
  Future<void> _handleOnPressed(CollegeUploadingState stateProvider) async {
    print('we are here inside uploading');
    if (_formKey.currentState.validate()) {
      titleFocusNode.unfocus();
      descriptionFocusNode.unfocus();
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();

      if (stateProvider.lectureToUpload == null) {
        stateProvider.showSnackBar('You must provide the lecture file');
      } else {
        await stateProvider.upload();
      }
    } else {
      print('invalid data');
    }
  }
}
