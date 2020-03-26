import 'package:flutter/material.dart';
import 'package:malzama/src/features/signup/pages/school_student_post_signup.dart';
import 'package:malzama/src/features/signup/pages/temporary.dart';
import 'package:malzama/src/features/signup/state_provider/college_post_signup_state.dart';
import 'package:provider/provider.dart';
import 'src/features/signup/pages/college_post_signup.dart';
import 'src/features/signup/pages/common_signup_page.dart';
import 'src/features/signup/state_provider/common_widgets_state_provider.dart';
import 'src/features/signup/state_provider/school_student_state_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommonWidgetsStateProvider>(
            create: (context) => CommonWidgetsStateProvider()),

        ChangeNotifierProvider<SchoolStudentPostSignupState>(
            create: (context) => SchoolStudentPostSignupState()),

        ChangeNotifierProvider<CollegePostSignUpState>(
            create: (context) => CollegePostSignUpState()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CommonSignupPage(),
        routes: {
          '/temp':(context) => TemporaryPageForTesting()
        },
      ),
    );
  }
}
