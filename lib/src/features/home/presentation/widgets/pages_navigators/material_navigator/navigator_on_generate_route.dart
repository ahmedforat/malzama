import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/college_uploading_video_dialog_body.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/school_uploading_lecture_dialog_body.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/school_uploading_video_dialog_body.dart';
import 'package:malzama/src/core/platform/services/material_uploading/college_uploads_state_provider.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/college_uploading_lecture_dialog_body.dart';
import 'package:malzama/src/core/platform/services/material_uploading/school_uploads_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_drafts_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';

import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/material_page.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/pages/explore_material.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/drafts_displayer.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_collection_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_draft_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_list_displayer/quiz_displayer_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_list_displayer/quiz_list_displayer.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_player/quiz_player_page.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_player/quiz_player_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'package:provider/provider.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> materialOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) => MyMaterialPage();
      break;
    // display a lecture in a single page
    case RouteNames.VIEW_LECTURE:
      Map<String, dynamic> args = settings.arguments;
      builder = (context) => Container(child: Text(args['title'].toString()));
      break;

    case RouteNames.UPLOAD_NEW_MATERIAL_COLLEGE:
      String materialType = settings.arguments;

      builder = (context) => ChangeNotifierProvider<CollegeUploadingState>(
            create: (context) => CollegeUploadingState(),
            builder: (context, _) =>
                materialType == 'lecture' ? UploadingLectureBodyForUniversities() : UploadingVideoBodyForUniversities(),
          );
      break;

    // case RouteNames.DISPLAY_COMMENT_RATORS:
    //   builder = (context) => DisplayRatorsPage();
    //   break;

    case RouteNames.VIEW_QUIZ_DRAFTS:
      builder = (context) => ChangeNotifierProvider<QuizDraftState>(
            create: (context) => QuizDraftState(),
            builder: (context, _) => DraftsDisplayer(),
          );
      break;

    case RouteNames.VIEW_QUIZ_DISPLAYER:
      builder = (context) => ChangeNotifierProvider<QuizDisplayerStateProvider>(
            create: (context) => new QuizDisplayerStateProvider(),
            builder: (context, _) => QuizListDisplayer(),
          );
      break;

    case RouteNames.TAKE_QUIZ_EXAM:
      QuizCollection payload = settings.arguments;
      print('before navigating *************************');
      print(payload.toJSON());
      print('before navigating *************************');

      builder = (context) => ChangeNotifierProvider<QuizPlayerStateProvider>(
        create: (context) =>  QuizPlayerStateProvider(payload),
        builder: (context, _) => QuizPlayer(),
      );
      break;

    case RouteNames.UPLOAD_NEW_MATERIAL_SCHOOL:
      String materialType = settings.arguments;
      builder = (context) => ChangeNotifierProvider<SchoolUploadState>(
            create: (context) => SchoolUploadState(),
            builder: (context, _) => materialType == 'lecture' ? UploadingLectureBodyForSchools() : UploadingVideoBodyForSchools(),
          );
      break;

    case RouteNames.UPLOAD_NEW_QUIZ:
      builder = (context) => ChangeNotifierProvider<QuizUploadingState>(
            create: (context) => QuizUploadingState(false),
            lazy: false,
            builder: (context, _) => QuizUploaderWidget(false),
          );
      break;

    case RouteNames.EDIT_QUIZ_DRAFT:
      builder = (context) => ChangeNotifierProvider<QuizUploadingState>(
            create: (context) => QuizUploadingState(true),
            lazy: false,
            builder: (context, _) => QuizUploaderWidget(
              true,
              payload: settings.arguments as QuizDraftEntity,
            ),
          );
      break;

    // display a video in a single page
    case RouteNames.VIEW_VIDEO:
      builder = (context) => throw UnimplementedError();
      break;

    // display a quiz in a single page
    case RouteNames.VIEW_QUIZ:
      builder = (context) => QuizUploaderWidget(false);
      break;

    // display a lecture with someone comment in a single page
    case RouteNames.VIEW_COMMENT_ON_LECTURE:
      builder = (context) => throw UnimplementedError();
      break;
    // display a vieo with someone comment in a single page
    case RouteNames.VIEW_COMMENT_ON_VIDEO:
      builder = (context) => throw UnimplementedError();
      break;

    // display user own profile page
    case RouteNames.VIEW_MY_PROFILE_PAGE:
      builder = (context) => throw UnimplementedError();
      break;

    // display any other user profile page
    case RouteNames.VIEW_USER_PROFILE_PAGE:
      builder = (context) => throw UnimplementedError();
      break;

    case RouteNames.EXPLORE_MY_MATERIALS:
      builder = (context) => ExploreMaterialPage();
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
