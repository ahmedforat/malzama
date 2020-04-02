import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/references/references.dart';
import '../signup/presentation/pages/college_post_signup.dart';
import '../signup/presentation/pages/school_student_post_signup.dart';
import '../signup/presentation/state_provider/college_post_signup_state.dart';
import '../signup/presentation/state_provider/common_widgets_state_provider.dart';
import '../signup/presentation/state_provider/school_student_state_provider.dart';



class SpecifyUserTypeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SchoolStudentPostSignupState schoolsState =
        Provider.of<SchoolStudentPostSignupState>(context, listen: false);
    CollegePostSignUpState collegeState =
        Provider.of<CollegePostSignUpState>(context, listen: false);

    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff696b9e),
        title: Text('choose account type'),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(180)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('استاذ جامعي'),
              onTap: () async {
                await _navigateToCollegePostSignupPage(
                    context, AccountType.COLLEGE_LECTURER);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('طالب جامعي'),
              onTap: () async {
                _navigateToCollegePostSignupPage(
                    context, AccountType.COLLEGE_STUDENT);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('استاذ اعدادية'),
              onTap: () async {
                await _navigateToSchoolPostSignUpPage(
                    context, AccountType.SCHOOL_TEACHER);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('طالب اعدادي'),
              onTap: () async {
                await _navigateToSchoolPostSignUpPage(
                    context, AccountType.SCHOOL_STUDENT);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// navigate to college post signup page with proper user type
Future<void> _navigateToCollegePostSignupPage(
    BuildContext context, AccountType accountType) async {
  CommonWidgetsStateProvider commonState =
      Provider.of<CommonWidgetsStateProvider>(context, listen: false);
  CollegePostSignUpState collegeState =
      Provider.of<CollegePostSignUpState>(context, listen: false);
      await collegeState.loadAllUniversitiesAndColleges();
      collegeState.reset();
      commonState.setAccountTypeTo(accountType);
  
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CollegeStudentPostSignUpWidget()));
}

//  navigate to school post signup page with proper user type
Future<void> _navigateToSchoolPostSignUpPage(
    BuildContext context, AccountType accountType) async {
  CommonWidgetsStateProvider commonState =
      Provider.of<CommonWidgetsStateProvider>(context, listen: false);
  SchoolStudentPostSignupState schoolState =
      Provider.of<SchoolStudentPostSignupState>(context, listen: false);
  commonState.setAccountTypeTo(accountType);
  schoolState.reset();
  await schoolState.prepareAllSchools();
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SchoolStudentPostSignUpWidget()));
}
