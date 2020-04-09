import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/core/debugging/form-submit.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/landing/pages/landing_page.dart';
import 'src/features/login/presentation/pages/login_page.dart';
import 'src/features/signup/presentation/pages/college_post_signup.dart';
import 'src/features/signup/presentation/pages/common_signup_page.dart';
import 'src/features/signup/presentation/pages/school_student_post_signup.dart';
import 'src/features/signup/presentation/state_provider/college_post_signup_state.dart';
import 'src/features/signup/presentation/state_provider/common_widgets_state_provider.dart';
import 'src/features/signup/presentation/state_provider/school_student_state_provider.dart';
import 'src/features/signup/usecases/signup_usecase.dart';
import 'src/features/specify_user_type/specify_user_type.dart';
import 'src/features/verify_your_email/presentation/validate_your_account_msg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // builder: (context,widget) => Navigator(onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => WrapperWidget(child:widget)),),

        initialRoute: '/landing-page',
        onGenerateRoute: _onGenerateRoute);
  }
}

// onGenerateRoutesTest(settings) {
//           if (settings.name == '/target')
//             return MaterialPageRoute(
//                 builder: (context) =>
//                     ChangeNotifierProvider<CounterState>.value(
//                         value: CounterState.instance(), child: Target()));
//           else if (settings.name == '/')
//             return MaterialPageRoute(
//                 builder: (context) => ChangeNotifierProvider<CounterState>(
//                       create: (context) => CounterState.instance(),
//                       child: InitialPage(),
//                     ));
//           else
//             return MaterialPageRoute(builder: (context) => Hello());
//         }

class UnknownRoute extends StatelessWidget {
  final String routeName;
  UnknownRoute({this.routeName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Un known route'),
      ),
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/form-test':
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (context) => FormTestState(),
                child: FormTest(),
              ));
      break;
    case '/':
      return MaterialPageRoute(builder: (context) => LandingPage());
      break;
    case '/signup-page':
      return MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider<CommonWidgetsStateProvider>(
                create: (context) => CommonWidgetsStateProvider(),
                child: CommonSignupPage()),
      );
      break;
    case '/specify-account-type':
      return MaterialPageRoute(builder: (context) => SpecifyUserTypeWidget());
      break;
    case '/school-post-signup':
      return MaterialPageRoute(
          builder: (context) => MultiProvider(providers: [
                ChangeNotifierProvider<ExecutionState>(
                    create: (context) => ExecutionState()),
                ChangeNotifierProvider<SchoolStudentPostSignUpState>(
                    create: (context) => SchoolStudentPostSignUpState())
              ], child: SchoolStudentPostSignUpWidget()));
      break;

    case '/college-post-signup':
      return MaterialPageRoute(
          builder: (context) => MultiProvider(providers: [
                ChangeNotifierProvider<ExecutionState>(
                    create: (context) => ExecutionState()),
                ChangeNotifierProvider<CollegePostSignUpState>(
                    create: (context) => CollegePostSignUpState())
              ], child: CollegeStudentPostSignUpWidget()));
      break;

    case '/validate-account-page':
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ExecutionState>(
              create: (context) => ExecutionState(), child: ValidateYourAccountMessageWidget()));
      break;

    case '/home-page':
      return MaterialPageRoute(builder: (context) => HomePage());
      break;

    case '/login-page':
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ExecutionState>(
              create: (context) => ExecutionState(), child: LoginPage()));
      break;

    default:
      return MaterialPageRoute(
          builder: (context) => UnknownRoute(
                routeName: settings.name,
              ));
  }
}

class SchoolPostSignupState {}

// MultiProvider multiProviderWrapper(Widget child) {
//   return MultiProvider(
//     providers: [
//       ChangeNotifierProvider<CommonWidgetsStateProvider>(
//         create:(context) => CommonWidgetsStateProvider(),
//       ),
//       ChangeNotifierProvider<CollegePostSignUpState>(
//           create:(context) => CollegePostSignUpState()),
//       ChangeNotifierProvider<SchoolStudentPostSignupState>(
//           create:(context) => SchoolStudentPostSignupState()),
//       ChangeNotifierProvider(create: (context) => ExecutionState())
//     ],
//     child: child,
//   );
// }

getObjectFrom(t) {
  if (t is CommonWidgetsStateProvider) {
    return new CommonWidgetsStateProvider();
  } else if (t is SchoolStudentPostSignUpState) {
    return new SchoolStudentPostSignUpState();
  } else {
    return new CollegePostSignUpState();
  }
}
