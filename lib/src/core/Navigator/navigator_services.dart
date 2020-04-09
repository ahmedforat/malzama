import 'package:flutter/material.dart';
import 'package:malzama/src/features/landing/pages/landing_page.dart';
import 'package:malzama/src/features/signup/presentation/pages/college_post_signup.dart';
import 'package:malzama/src/features/signup/presentation/pages/common_signup_page.dart';
import 'package:malzama/src/features/signup/presentation/pages/school_student_post_signup.dart';
import 'package:malzama/src/features/specify_user_type/specify_user_type.dart';
import 'package:malzama/src/features/verify_your_email/presentation/validate_your_account_msg.dart';

class NavigatorServices{
  static final Map<String,WidgetBuilder> navigatorRoutes = {
    '/validate-account-page': (_) => ValidateYourAccountMessageWidget(),
    '/signup-page' :(_) => CommonSignupPage() ,
    '/specify-account-type':(_) => SpecifyUserTypeWidget(),
    '/college-student-post-signup':(_) => CollegeStudentPostSignUpWidget(),
    '/school-student-post-signup':(_) => SchoolStudentPostSignUpWidget()
  } ;


}