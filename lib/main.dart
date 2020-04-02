import 'package:flutter/material.dart';
import 'package:malzama/src/features/signup/usecases/signup_usecase.dart';
import 'package:provider/provider.dart';

import 'src/features/signup/presentation/pages/common_signup_page.dart';
import 'src/features/signup/presentation/pages/temporary.dart';
import 'src/features/signup/presentation/state_provider/college_post_signup_state.dart';
import 'src/features/signup/presentation/state_provider/common_widgets_state_provider.dart';
import 'src/features/signup/presentation/state_provider/school_student_state_provider.dart';


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
            create: (context) => CommonWidgetsStateProvider(),
          ),
          ChangeNotifierProvider<CollegePostSignUpState>(
              create: (context) => CollegePostSignUpState()),
          ChangeNotifierProvider<SchoolStudentPostSignupState>(
            create: (context) => SchoolStudentPostSignupState()),
            ChangeNotifierProvider(create: (context) => ExecutionState())
        ],

          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        
        home:CommonSignupPage(),
        routes: {'/temp': (context) => TemporaryPageForTesting()},
      ),
    );
  }
}


