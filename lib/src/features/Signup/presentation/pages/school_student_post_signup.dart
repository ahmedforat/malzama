import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/api/api_client/clients/registration_client.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/execution_state.dart';
import 'package:provider/provider.dart';

import '../../../../core/api/contract_response.dart';
import '../../../../core/debugging/debugging_widgets.dart';
import '../../../../core/platform/services/caching_services.dart';
import '../../../../core/platform/services/file_system_services.dart';
import '../../../../core/references/references.dart';
import '../../usecases/signup_usecase.dart';
import '../state_provider/school_student_state_provider.dart';
import '../widgets/school_student_and_teacher_widgets.dart/select_baghdad_sub_region.dart';
import '../widgets/school_student_and_teacher_widgets.dart/select_school_section_widget..dart';
import '../widgets/school_student_and_teacher_widgets.dart/select_school_widgets.dart';
import '../widgets/school_student_and_teacher_widgets.dart/specify_class_speciality.dart';

class SchoolStudentPostSignUpWidget extends StatelessWidget {
  
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String accountType;
  Map<String,dynamic> commonState;
  SchoolStudentPostSignUpState schoolState;
  Future<bool> _loadData()async{
    if(accountType != null && commonState != null && schoolState.isCompleted){
      return true;
    }else{
      
      if(accountType == null){
        accountType = await CachingServices.getField(key: 'accountType');
        
      }
      if(commonState == null){
        String fetchedData = await CachingServices.getField(key: 'commonState');
        commonState = json.decode(fetchedData);
      }
      if(!schoolState.isCompleted){
        await schoolState.initialize();
      }
      return true;
    }

  }

  @override
  Widget build(BuildContext context) {
     schoolState =
        Provider.of<SchoolStudentPostSignUpState>(context, listen: false);
    ScreenUtil.init(context);
    return FutureBuilder(
      future: _loadData(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(!snapshot.hasData){
           return Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator(),));
        }else if(snapshot.hasError){
          return Center(child: Text('an error has occured'),);
        }else{
          print('this is the account type $accountType');
          return _buildSchoolPostSignUpPage(context,commonState);
        }
      },
    );
  }

  Widget _buildSchoolPostSignUpPage(BuildContext context,Map commonState)
  => Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff696b9e),
        title: Text(
            ' ${References.accountTypeDictionary[accountType]}'),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(130)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(170)),
            if (commonState['province'] == 'baghdad') SelectBaghdadSubRegion(),
            SelectSchoolSectionWidget(commonState: commonState,),
            SelectSchoolWidget(),
            if (accountType == AccountType.schteachers.toString())
              SelectClassSpeciality(),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            Consumer<ExecutionState>(
              builder: (context, executionState, _) => RaisedButton(
                  color: Color(0xff696b9e),
                  onPressed: executionState.isLoading
                      ? null
                      : () async {
                          _handleOnDone(scaffoldKey, context, commonState,accountType);
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
    );
}

void _handleOnDone(GlobalKey<ScaffoldState> key, BuildContext context,
    Map commonState,String accountType) async {
  SchoolStudentPostSignUpState schoolState =
      Provider.of<SchoolStudentPostSignUpState>(context, listen: false);
  if (commonState['province'] == 'baghdad' &&
      schoolState.baghdadSubRegion == null) {
    key.currentState.showSnackBar(_getSnackBar('please subRegion is required'));
  } else if (schoolState.schoolSection == null) {
    key.currentState
        .showSnackBar(_getSnackBar('please your study section is required'));
  } else if (schoolState.school == null) {
    key.currentState.showSnackBar(_getSnackBar('please school is required'));
  } else if (accountType == AccountType.schteachers.toString() &&
      schoolState.speciality == null) {
    key.currentState
        .showSnackBar(_getSnackBar('please speciality is required'));
  } else {
    Map<String,dynamic> user =
        accountType == AccountType.unistudents.toString()
            ? schoolState.fetchStudentData(commonState)
            : schoolState.fetchTechertData(commonState);
    user['account_type'] = accountType.toString();
    print(user);

    ExecutionState executionState =
        Provider.of<ExecutionState>(context, listen: false);

    executionState.setLoadingStateTo(true);

    ContractResponse response = await RegistrationClient().registerNewUser(user: user);

    executionState.setLoadingStateTo(false);

    if (response is SnackBarException) {
      key.currentState.showSnackBar(_getSnackBar(response.message));
    } else if (response is NewBugException) {
        DebugTools.showErrorMessageWidget(context: context, message: response.message);
    } else {
       // success
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/validate-account-page', (Route route) => false);
    }
  }
}

Widget _getSnackBar(String text) {
  return SnackBar(content: Text(text), duration: Duration(seconds: 3));
}

class ViewData extends StatelessWidget {
  final Map<String, dynamic> entry;

  ViewData({this.entry});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            '${entry['account_type']}',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                for (var i in entry.entries)
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: EdgeInsets.only(bottom: 20, right: 40),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            i.key.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          color: Colors.blueAccent,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            i.value.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          )),
    );
  }
}
