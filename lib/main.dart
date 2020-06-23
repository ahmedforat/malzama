import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_state_providers/school_uploads_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_drafts_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/drafts_displayer.dart';
import 'package:provider/provider.dart';

import 'src/core/debugging/form-submit.dart';
import 'src/core/platform/services/dialog_services/dialog_manger.dart';
import 'src/core/platform/services/dialog_services/dialog_state_providers/dialog_state_provider.dart';
import 'src/core/platform/services/dialog_services/service_locator.dart';
import 'src/features/home/presentation/pages/cover_picture_viewer.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/home/presentation/pages/pdf_viewer.dart';
import 'src/features/home/presentation/pages/profile_picture_viewer.dart';
import 'src/features/home/presentation/state_provider/my_materials_state_provider.dart';
import 'src/features/home/presentation/state_provider/pdf_viewer_state_provider.dart';
import 'src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/pages/explore_material.dart';
import 'src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/youtube_video_displayer.dart';
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
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfilePageState>(
          create: (context) => ProfilePageState(),
          lazy: true,
        ),
        ChangeNotifierProvider<ExecutionState>(
          create: (context) => ExecutionState(),
          lazy: true,
        ),
        ChangeNotifierProvider<SchoolUploadState>(
          create: (context) => SchoolUploadState(),
          lazy: true,
        ),
        ChangeNotifierProvider<MyMaterialStateProvider>(
          create: (context) => locator.get<MyMaterialStateProvider>(),
          lazy: true,
        ),
        ChangeNotifierProvider<NotificationStateProvider>(
          create: (context) => locator.get<NotificationStateProvider>(),
          lazy: true,
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // builder: (context,widget) => Navigator(onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => WrapperWidget(child:widget)),),
          //home: ChangeNotifierProvider(
          //    create: (context) => QuizUploadingState(),
          //    child: QuizUploaderWidget())
          initialRoute: '/landing-page',
          onGenerateRoute: _onGenerateRoute,
          ),
    );
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
              create: (context) => ExecutionState(),
              child: ValidateYourAccountMessageWidget()));
      break;

    case '/home-page':
      return MaterialPageRoute(
        builder: (context) => DialogManager(child: HomePage()),
      );
      break;

    case '/landing-page':
      return MaterialPageRoute(builder: (context) => LandingPage());
      break;

    case '/login-page':
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ExecutionState>(
              create: (context) => ExecutionState(), child: LoginPage()));
      break;

    case '/explore-my-material':
      return MaterialPageRoute(builder: (context) => ExploreMaterialPage());
      break;

    case '/display-profile-picture':
      return MaterialPageRoute(builder: (context) => ProfilePictureViewer());
      break;
    case '/view-cover-picture':
      try {
        return MaterialPageRoute(builder: (context) => CoverPictureViewer());
      } catch (err) {
        throw err;
      }
      break;

    case '/video-display-widget':
      final String _videoId = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => VideoDisplay(videoId: _videoId));
      break;

    case '/quiz-uploader':
      return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
              create: (context) => QuizUploadingState(),
              child: QuizUploaderWidget(false)));
      break;
    // case '/quiz':
    //   return MaterialPageRoute(builder: (context) => QuizWidget());
    //   break;

    case "/pdf-viewer-widget":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<PdfViewerState>(
                create: (context) => PdfViewerState(),
                child: PDFViewerWidget(),
              ));
      break;

    case '/explore-my-drafts':
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<QuizDraftState>(
            create: (context) => QuizDraftState(),
            child: DraftsDisplayer())
    );   ///edit-quiz-draft


    case '/edit-quiz-draft':
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<QuizUploadingState>(
              create: (context) => QuizUploadingState(),
              child: QuizUploaderWidget(true,payload: settings.arguments,))
      );
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

class HelloWorld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: Text('Hello World')),
    );
  }
}
