import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/api/contract_response.dart';
import '../../../../core/debugging/debugging_widgets.dart';
import '../../../../core/references/references.dart';
import '../../usecases/signup_usecase.dart';
import '../state_provider/college_post_signup_state.dart';
import '../state_provider/common_widgets_state_provider.dart';
import '../widgets/college_teacher_and_student_widgets/college_lecturer_speciality.dart';
import '../widgets/college_teacher_and_student_widgets/select_college_widget.dart';
import '../widgets/college_teacher_and_student_widgets/select_section_widget.dart';
import '../widgets/college_teacher_and_student_widgets/select_stage_widget.dart';
import '../widgets/college_teacher_and_student_widgets/select_university_widget.dart';

class CollegeStudentPostSignUpWidget extends StatefulWidget {
  @override
  _CollegeStudentPostSignUpWidgetState createState() =>
      _CollegeStudentPostSignUpWidgetState();
}

class _CollegeStudentPostSignUpWidgetState
    extends State<CollegeStudentPostSignUpWidget> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CommonWidgetsStateProvider commonState =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    CollegePostSignUpState collegeState =
        Provider.of<CollegePostSignUpState>(context, listen: false);

    print('rebuilding final page');
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xff696b9e),
          title: Text('Complete Signup'),
        ),
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(150)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(170)),
              SelectUniversityWidget(),
              SelectCollegeWidget(),
              SelectSectionWidget(),
              if (commonState.accountType == AccountType.COLLEGE_STUDENT)
                SelectStageWidget(),
              if (commonState.accountType == AccountType.COLLEGE_LECTURER)
                Form(key: formKey, child: CollegeLecturerSpecialityWidget()),
              SizedBox(
                height: ScreenUtil().setHeight(100),
              ),
              Consumer<ExecutionState>(
                builder: (context, executionState, __) => RaisedButton(
                    color: Color(0xff696b9e),
                    onPressed: executionState.isLoading
                        ? null
                        : () {
                            if (commonState.accountType ==
                                AccountType.COLLEGE_LECTURER) {
                              _handleCollegeLecturerDoneButton(scaffoldKey,
                                  collegeState, commonState, context);
                            } else {
                              _handleCollegeStudentDoneButton(scaffoldKey,
                                  collegeState, commonState, context);
                            }
                          },
                    child: executionState.isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleCollegeLecturerDoneButton(
      GlobalKey<ScaffoldState> key,
      CollegePostSignUpState collegeState,
      CommonWidgetsStateProvider commonState,
      BuildContext context) async {
    if (collegeState.university == null) {
      key.currentState
          .showSnackBar(getSnackBar('please university is required'));
    } else if (collegeState.college == null) {
      key.currentState.showSnackBar(getSnackBar('please college is required'));
    } else {
      if (formKey.currentState.validate()) {
        print(collegeState.fetchLecturerData(commonState));
        ExecutionState executionState =
            Provider.of<ExecutionState>(context, listen: false);
        executionState.setLoadingStateTo(true);
        ContractResponse response = await SignUpNewUser(
                user: collegeState.fetchLecturerData(commonState))
            .execute();
        executionState.setLoadingStateTo(false);
        if (response is SnackBarException) {
          key.currentState.showSnackBar(getSnackBar(response.message));
        } else if (response is NewBugException) {
          DebugTools.showErrorMessageWidget(
              context: context, message: response.message);
        } else {
          DebugTools.showSuccessMessageWidget(context: context);
        }
      }
    }
  }

  void _handleCollegeStudentDoneButton(
      GlobalKey<ScaffoldState> key,
      CollegePostSignUpState collegeState,
      CommonWidgetsStateProvider commonState,
      BuildContext context) async {
    if (collegeState.university == null) {
      key.currentState
          .showSnackBar(getSnackBar('please university is required'));
    } else if (collegeState.college == null) {
      key.currentState.showSnackBar(getSnackBar('please college is required'));
    } else if (collegeState.section == null) {
      key.currentState.showSnackBar(getSnackBar('please section is required'));
    } else if (collegeState.stage == null) {
      key.currentState.showSnackBar(getSnackBar('please stage is required'));
    } else {
      print(collegeState.fetchStudentData(commonState));
      ExecutionState executionState =
          Provider.of<ExecutionState>(context, listen: false);
      executionState.setLoadingStateTo(true);
      ContractResponse response =
          await SignUpNewUser(user: collegeState.fetchStudentData(commonState))
              .execute();
      executionState.setLoadingStateTo(false);
      if (response is SnackBarException) {
        key.currentState.showSnackBar(getSnackBar(response.message));
      } else if (response is NewBugException) {
        DebugTools.showErrorMessageWidget(
            context: context, message: response.message);
      } else {
        DebugTools.showSuccessMessageWidget(context: context);
      }
    }
  }

  Widget getSnackBar(String text) {
    return SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
    );
  }
}

// for debugging purposes
