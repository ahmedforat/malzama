import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/local_caches/cached_user_info.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/Signup/presentation/pages/common_signup_page.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/common_widgets_state_provider.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/execution_state.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/temp_provider.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/state_provider/verify_new_email_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/widgets/verify_email_by_auth_code.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/materials_details_pages/players/pdf_player/pdf_player_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/materials_details_pages/players/pdf_player/pdf_player_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/materials_details_pages/players/video_player/video_player_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/video_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import './src/features/home/presentation/state_provider/user_info_provider.dart';
import 'src/core/debugging/form-submit.dart';
import 'src/core/platform/services/dialog_services/dialog_manger.dart';
import 'src/core/platform/services/dialog_services/service_locator.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/home/presentation/pages/profile_picture_viewer.dart';
import 'src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'src/features/landing/pages/landing_page.dart';
import 'src/features/login/presentation/pages/login_page.dart';
import 'src/features/signup/presentation/pages/college_post_signup.dart';
import 'src/features/signup/presentation/pages/school_student_post_signup.dart';
import 'src/features/signup/presentation/state_provider/college_post_signup_state.dart';
import 'src/features/signup/presentation/state_provider/school_student_state_provider.dart';
import 'src/features/specify_user_type/specify_user_type.dart';
import 'src/features/verify_your_email/presentation/validate_your_account_msg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  bool isAcademic = HelperFucntions.isAcademic(await UserCachedInfo().getRecord('account_type'));
  User data = await FileSystemServices.getUserData();
  setup(data);

  runApp(MyApp(isAcademic, data));
}

class MyApp extends StatelessWidget {
  final bool isAcademic;
  final User data;

  MyApp(this.isAcademic, this.data);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfoStateProvider>(
          create: (context) => locator<UserInfoStateProvider>(),
          lazy: false,
        ),
        ChangeNotifierProvider<PDFStateProvider>(
          create: (context) => locator<PDFStateProvider>(),
          lazy: true,
        ),
        ChangeNotifierProvider<VideoStateProvider>(
          create: (context) => locator<VideoStateProvider>(),
          lazy: true,
        ),
        ChangeNotifierProvider<VideoPlayerStateProvider>(
          create: (context) => locator<VideoPlayerStateProvider>(),
        ),
        ChangeNotifierProvider<ProfilePageState>(
          create: (context) => ProfilePageState(),
          lazy: true,
        ),
        ChangeNotifierProvider<ExecutionState>(
          create: (context) => ExecutionState(),
          lazy: true,
        ),
        ChangeNotifierProvider<NotificationStateProvider>(
          create: (context) => locator.get<NotificationStateProvider>(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // builder: (context,widget) => Navigator(onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => WrapperWidget(child:widget)),),
        //home: IOStateProviderDemo() //ChangeNotifierProvider(
        //  create: (context) => QuizUploadingState(),
        //   child: QuizUploaderWidget())
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}

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
      return MaterialPageRoute(
        builder: (context) => LandingPage(),
      );
      break;
    case '/signup-page':
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<CommonWidgetsStateProvider>(
                create: (context) => new CommonWidgetsStateProvider(),
                builder: (context, _) => CommonSignupPage(),
              ));
      break;
    case '/specify-account-type':
      return MaterialPageRoute(
        builder: (context) => SpecifyUserTypeWidget(),
      );
      break;
    case '/school-post-signup':
      return MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<ExecutionState>(
              create: (context) => ExecutionState(),
            ),
            ChangeNotifierProvider<SchoolStudentPostSignUpState>(
              create: (context) => SchoolStudentPostSignUpState(),
            )
          ],
          child: SchoolStudentPostSignUpWidget(),
        ),
      );
      break;

    case '/college-post-signup':
      return MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<ExecutionState>(
              create: (context) => ExecutionState(),
            ),
            ChangeNotifierProvider<CollegePostSignUpState>(
              create: (context) => CollegePostSignUpState(),
            ),
          ],
          child: CollegeStudentPostSignUpWidget(),
        ),
      );
      break;

    case '/validate-account-page':
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<ExecutionState>(
          create: (context) => ExecutionState(),
          child: ValidateYourAccountMessageWidget(),
        ),
      );
      break;

    case '/home-page':
      return MaterialPageRoute(
        builder: (context) => DialogManager(
          child: HomePage(),
        ),
      );
      break;

    case '/':
      return MaterialPageRoute(
        builder: (context) => LandingPage(),
      );
      break;

    case '/login-page':
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<ExecutionState>(
          create: (context) => ExecutionState(),
          child: LoginPage(),
        ),
      );
      break;

    // case '/explore-my-material':
    //   return MaterialPageRoute(
    //     builder: (context) => ExploreMaterialPage(),
    //   );
    //   break;

    case '/display-profile-picture':
      return MaterialPageRoute(
        builder: (context) => ProfilePictureViewer(),
      );
      break;
    case '/view-picture':
      File image = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => PhotoView(
          imageProvider: FileImage(image),
        ),
      );

      break;

    case RouteNames.OPEN_LECTURE_FILE:
      final int pos = settings.arguments;
      print('Hello Native Navigator');
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<PDFPlayerStateProvider>(
          create: (context) => new PDFPlayerStateProvider(context, pos),
          builder: (context, _) => PDFPlayerWidget(),
        ),
      );
      break;

    case RouteNames.VERIFY_NEW_EMAIL:
      final Map<String, dynamic> data = settings.arguments;
      return new MaterialPageRoute<Map<String, dynamic>>(
        builder: (context) => ChangeNotifierProvider<VerifyNewStateProvider>(
          create: (context) => VerifyNewStateProvider(data),
          builder: (context, _) => VerifyEmailByAuthCodePage(),
        ),
      );
      break;

    default:
      return MaterialPageRoute(
        builder: (context) => UnknownRoute(
          routeName: settings.name,
        ),
      );
  }
}

class HelloWorld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TempProvider tempProvider = Provider.of<TempProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: tempProvider.decrement,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('${tempProvider.count}'), RaisedButton(onPressed: tempProvider.increment)],
          ),
        ),
      ),
    );
  }
}
