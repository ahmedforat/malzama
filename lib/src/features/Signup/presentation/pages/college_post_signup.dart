import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/execution_state.dart';
import 'package:provider/provider.dart';

import '../../../../core/api/contract_response.dart';
import '../../../../core/debugging/debugging_widgets.dart';
import '../../../../core/platform/services/caching_services.dart';
import '../../../../core/platform/services/file_system_services.dart';
import '../../usecases/signup_usecase.dart';
import '../state_provider/college_post_signup_state.dart';
import '../widgets/college_teacher_and_student_widgets/college_lecturer_speciality.dart';
import '../widgets/college_teacher_and_student_widgets/select_college_widget.dart';
import '../widgets/college_teacher_and_student_widgets/select_section_widget.dart';
import '../widgets/college_teacher_and_student_widgets/select_stage_widget.dart';
import '../widgets/college_teacher_and_student_widgets/select_university_widget.dart';

class CollegeStudentPostSignUpWidget extends StatelessWidget {
  String accountType;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  CollegePostSignUpState collegeState;

  Future<bool> _futureEvent() async {
    if (accountType != null && collegeState.isCompleted) {
      await Future.delayed(Duration(milliseconds: 1));
      return true;
    } else {
      if (accountType == null) {
        accountType = await CachingServices.getField(key: 'accountType');
      }
      if (!collegeState.isCompleted) {
        await collegeState.initialize();
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('this is the account type  ' + '$accountType');
    collegeState = Provider.of<CollegePostSignUpState>(context, listen: false);

    print('rebuilding final page');
    ScreenUtil.init(context);
    return FutureBuilder(
      future: _futureEvent(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          print('waiting');
          return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('an Error Occured !!'),
          );
        } else {
          print('this is the account type $accountType');
          return _buildPostSignupPage(context, collegeState);
        }
      },
    );
  }

  Widget _buildPostSignupPage(BuildContext context, CollegePostSignUpState collegeState) => GestureDetector(
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
                if (accountType == AccountType.unistudents) SelectStageWidget(),
                if (accountType == AccountType.uniteachers) Form(key: formKey, child: CollegeLecturerSpecialityWidget()),
                SizedBox(
                  height: ScreenUtil().setHeight(100),
                ),
                Consumer<ExecutionState>(
                  builder: (context, executionState, __) => RaisedButton(
                      color: Color(0xff696b9e),
                      onPressed: executionState.isLoading
                          ? null
                          : () {
                              if (accountType == AccountType.uniteachers.toString()) {
                                _handleCollegeLecturerDoneButton(scaffoldKey, collegeState, context);
                              } else {
                                _handleCollegeStudentDoneButton(scaffoldKey, collegeState, context);
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

  void _handleCollegeLecturerDoneButton(GlobalKey<ScaffoldState> key, CollegePostSignUpState collegeState, BuildContext context) async {
    if (collegeState.university == null) {
      key.currentState.showSnackBar(getSnackBar('please university is required'));
    } else if (collegeState.college == null) {
      key.currentState.showSnackBar(getSnackBar('please college is required'));
    } else {
      if (formKey.currentState.validate()) {
        //print(collegeState.fetchLecturerData(commonState));
        ExecutionState executionState = Provider.of<ExecutionState>(context, listen: false);
        executionState.setLoadingStateTo(true);
        String cachedData = await CachingServices.getField(key: 'commonState');
        var _user = collegeState.fetchLecturerData(json.decode(cachedData));
        _user['account_type'] = accountType.toString();
        print(collegeState.fetchLecturerData(json.decode(cachedData)));
        ContractResponse response = await SignUpNewUser(user: _user).execute();
        executionState.setLoadingStateTo(false);
        if (response is SnackBarException) {
          key.currentState.showSnackBar(getSnackBar(response.message));
        } else if (response is NewBugException) {
          DebugTools.showErrorMessageWidget(context: context, message: response.message);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/validate-account-page', ModalRoute.withName(null));
        }
      }
    }
  }

  void _handleCollegeStudentDoneButton(GlobalKey<ScaffoldState> key, CollegePostSignUpState collegeState, BuildContext context) async {
    if (collegeState.university == null) {
      key.currentState.showSnackBar(getSnackBar('please university is required'));
    } else if (collegeState.college == null) {
      key.currentState.showSnackBar(getSnackBar('please college is required'));
    } else if (collegeState.section == null) {
      key.currentState.showSnackBar(getSnackBar('please section is required'));
    } else if (collegeState.stage == null) {
      key.currentState.showSnackBar(getSnackBar('please stage is required'));
    } else {
      ExecutionState executionState = Provider.of<ExecutionState>(context, listen: false);
      executionState.setLoadingStateTo(true);
      String cachedData = await CachingServices.getField(key: 'commonState');
      print(collegeState.fetchStudentData(json.decode(cachedData)));
      var _user = collegeState.fetchStudentData(json.decode(cachedData));
      _user['account_type'] = accountType.toString();
      ContractResponse response = await SignUpNewUser(user: _user).execute();
      executionState.setLoadingStateTo(false);
      if (response is SnackBarException) {
        key.currentState.showSnackBar(getSnackBar(response.message));
      } else if (response is NewBugException) {
        DebugTools.showErrorMessageWidget(context: context, message: response.message);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/validate-account-page', (Route route) => false);
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
