import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../state_provider/abroad_college_state.dart';
import '../state_provider/common_widgets_state_provider.dart';
import '../widgets/abroad/abroad_college_post_signup/select_university.dart';
import '../widgets/abroad/abroad_college_post_signup/specify_college.dart';
import '../widgets/abroad/abroad_college_post_signup/specify_section.dart';
import '../widgets/abroad/abroad_college_post_signup/specify_specialit.dart';
import '../widgets/abroad/abroad_college_post_signup/specify_stage.dart';
import '../widgets/abroad/select_country.dart';

class AbroadCollegePostSignup extends StatelessWidget {
  final Map<AccountType, String> accountTypeDictionary = {
    AccountType.COLLEGE_LECTURER: 'College Doctor',
    AccountType.COLLEGE_STUDENT: 'College Student',
    AccountType.SCHOOL_STUDENT: 'School Student',
    AccountType.SCHOOL_TEACHER: 'School Teacher'
  };

  @override
  Widget build(BuildContext context) {
    CommonWidgetsStateProvider commonState =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);

    ScreenUtil.init(context);
    var children2 = <Widget>[
      SizedBox(
        height: ScreenUtil().setHeight(100),
      ),
      Container(
        padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
        child: Row(
          children: <Widget>[
            Text('Account Type : '),
            Text('${accountTypeDictionary[commonState.accountType]}'),
          ],
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(30),
      ),
      Selector<AbroadCollegeState, String>(
        selector: (context, stateObject) => stateObject.currentCountry,
        builder: (context, currentCountry, _) => Container(
          padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
          child: Row(
            children: <Widget>[
              Text('Current country : '),
              Text('${currentCountry ?? "not specified yet"}'),
            ],
          ),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(150),
      ),

      Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil().setSp(150), right: ScreenUtil().setSp(150)),
          child: SelectCountryWidget()),
      SizedBox(
        height: ScreenUtil().setHeight(75),
      ),
      SpecifyAbroadUniversityWidget(),

      // ****************************************************************************************** college field
      SizedBox(
        height: ScreenUtil().setHeight(75),
      ),
      SpecifyAbroadCollegeWidget(),
      // ******************************************************************************************* speciality field
      if (commonState.accountType == AccountType.COLLEGE_LECTURER)
        SizedBox(
          height: ScreenUtil().setHeight(75),
        ),
      if (commonState.accountType == AccountType.COLLEGE_LECTURER)
        SpecifyAbroadSpecialityWidget(),
      if (commonState.accountType == AccountType.COLLEGE_STUDENT)
        SizedBox(
          height: ScreenUtil().setHeight(75),
        ),
      if (commonState.accountType == AccountType.COLLEGE_STUDENT)
        SpecifyAbroadSectionWidget(),
      if (commonState.accountType == AccountType.COLLEGE_STUDENT)
        SizedBox(
          height: ScreenUtil().setHeight(75),
        ),
      if (commonState.accountType == AccountType.COLLEGE_STUDENT)
        SpecifyAbroadStageWidget(),

      SizedBox(
        height: ScreenUtil().setHeight(100),
      ),
      RaisedButton(
        child: Text('Done'),
        onPressed: () {
          AbroadCollegeState abroadState =
              Provider.of<AbroadCollegeState>(context);
          if (commonState.accountType == AccountType.COLLEGE_LECTURER) {
            if (_checkLecturerDataValidation(abroadState)) {
              print(abroadState.fetchLecturerData(commonState));
            }else{
              abroadState.updateUniversityErrorMessage(update:)
            }
          } else {
            if (_checkStudentDataValidation(abroadState)) {
              print(abroadState.fetchStudentData(commonState));
            }
          }
        },
      )
    ];
    return ChangeNotifierProvider<AbroadCollegeState>(
      create: (context) => AbroadCollegeState(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Complete Sign up'),
        ),
        body: Container(
          // padding: EdgeInsets.all(ScreenUtil().setSp(200)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children2,
          ),
        ),
      ),
    );
  }
}

bool _checkLecturerDataValidation(AbroadCollegeState abroadState) {
  return abroadState.currentCountry != null &&
      abroadState.university != null &&
      abroadState.college != null &&
      abroadState.speciality != null;
}

bool _checkStudentDataValidation(AbroadCollegeState abroadState) {
  return abroadState.currentCountry != null &&
      abroadState.university != null &&
      abroadState.college != null &&
      abroadState.section != null &&
      abroadState.stage != null;
}
