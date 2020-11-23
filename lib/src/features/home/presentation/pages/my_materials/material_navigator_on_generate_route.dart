import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/Navigator/routes_names.dart';
import '../../state_provider/quiz_drafts_state_provider.dart';
import '../../state_provider/quiz_uploading_state_provider.dart';
import 'materialPage/drafts/drafts_displayer.dart';
import 'materialPage/material_page.dart';
import 'materialPage/my_uploads/explore_material_page.dart';
import 'materialPage/quizes/quiz_collection_model.dart';
import 'materialPage/quizes/quiz_list_displayer/quiz_displayer_state_provider.dart';
import 'materialPage/quizes/quiz_list_displayer/quiz_list_displayer.dart';
import 'materialPage/quizes/quiz_player/quiz_player_page.dart';
import 'materialPage/quizes/quiz_player/quiz_player_state_provider.dart';
import 'materialPage/quizes/quiz_uploader_widget.dart';

import 'materialPage/upper_uploading_banner/college_uploading_pages/college_lecture_uploading_form.dart';
import 'materialPage/upper_uploading_banner/college_uploading_pages/collge_video_uploading_form.dart';
import 'materialPage/upper_uploading_banner/school_uploading_widgets/school_lecture_uploading_form.dart';
import 'materialPage/upper_uploading_banner/school_uploading_widgets/school_video_uploading_form.dart';
import 'materialPage/upper_uploading_banner/state_providers/college_uploads_state_provider.dart';
import 'materialPage/upper_uploading_banner/state_providers/school_uploads_state_provider.dart';

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
      print(materialType);
      print('Naving to UPLOAD_NEW_MATERIAL_COLLEGE');
      print('inside the on generate routes navigator');
      builder = (context) => ChangeNotifierProvider<CollegeUploadingState>(
            create: (context) => CollegeUploadingState(),
            builder: (context, _) => materialType == 'lecture' ? CollegeLectureUploadingFormWidget(): CollegeVideoUploadingFormWidget(),
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
      print(settings.arguments);
      Map<String, dynamic> args = settings.arguments;
      print(args);
      print('قبل لتخرب بثواني');
      QuizCollection payload = args['data'];
      final bool fromLocal = args['fromLocal'];
      print('before navigating *************************');
      print(payload.toJSON());
      print('before navigating *************************');

      builder = (context) => ChangeNotifierProvider<QuizPlayerStateProvider>(
            create: (context) => QuizPlayerStateProvider(payload, fromLocal: fromLocal),
            builder: (context, _) => QuizPlayer(),
          );
      break;

    case RouteNames.UPLOAD_NEW_MATERIAL_SCHOOL:
      String materialType = settings.arguments;
      builder = (context) => ChangeNotifierProvider<SchoolUploadState>(
            create: (context) => SchoolUploadState(),
            builder: (context, _) => materialType == 'lecture' ? SchoolLectureUploadingFormWidget() : SchoolVideoUploadingFormWidget(),
          );
      break;

    case RouteNames.UPLOAD_NEW_QUIZ:
      builder = (context) => ChangeNotifierProvider<QuizUploadingState>(
            create: (context) => QuizUploadingState(),
            lazy: false,
            builder: (context, _) => QuizUploaderWidget(),
          );
      break;

    case RouteNames.EDIT_QUIZ_DRAFT:
      builder = (context) => ChangeNotifierProvider<QuizUploadingState>(
            create: (context) => QuizUploadingState(fromDrafts: true),
            lazy: false,
            builder: (context, _) => QuizUploaderWidget(
              payload: settings.arguments,
              fromDrafts: true,
            ),
          );
      break;

    case RouteNames.EDIT_UPLOADED_QUIZ:
      builder = (context) => ChangeNotifierProvider<QuizUploadingState>(
            create: (context) => QuizUploadingState(fromUploads: true),
            lazy: false,
            builder: (context, _) => QuizUploaderWidget(
              payload: settings.arguments,
              toBeEdit: true,
            ),
          );
      break;

    // display a video in a single page
    case RouteNames.VIEW_VIDEO:
      builder = (context) => throw UnimplementedError();
      break;

    // display a quiz in a single page
    // case RouteNames.VIEW_QUIZ:
    //   builder = (context) => QuizUploaderWidget(false);
    //   break;

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
