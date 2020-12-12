import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/general_widgets/comment_state_change_notifier.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/materials_details_pages/details_pages/college_pdf_details_page.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/materials_details_pages/details_pages/college_video_details_page.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/materials_details_pages/details_pages/school_pdf_details_page.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/materials_details_pages/details_pages/school_video_details_page.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploader_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/Navigator/routes_names.dart';
import '../../state_provider/quiz_drafts_state_provider.dart';
import 'materialPage/drafts/drafts_displayer.dart';
import 'materialPage/material_page.dart';
import 'materialPage/my_saved_material/pages/my_saved_page.dart';
import 'materialPage/my_saved_material/state_provider/my_saved_common_state_provider.dart';
import 'materialPage/my_saved_material/state_provider/saved_pdf_state_provider.dart';
import 'materialPage/my_saved_material/state_provider/saved_quizes_state_provider.dart';
import 'materialPage/my_saved_material/state_provider/saved_videos_state_provider.dart';
import 'materialPage/quizes/quiz_collection_model.dart';
import 'materialPage/quizes/quiz_draft_model.dart';
import 'materialPage/quizes/quiz_list_displayer/quiz_list_displayer.dart';
import 'materialPage/quizes/quiz_list_displayer/quiz_state_provider.dart';
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
  final bool isAcademic = locator<UserInfoStateProvider>().isAcademic;
  switch (settings.name) {
    case '/':
      builder = (context) => MyMaterialPage();
      break;
    // display a lecture in a single page

    case RouteNames.UPLOAD_NEW_MATERIAL_COLLEGE:
      String materialType = settings.arguments;
      print(materialType);
      print('Naving to UPLOAD_NEW_MATERIAL_COLLEGE');
      print('inside the on generate routes navigator');
      builder = (context) => ChangeNotifierProvider<CollegeUploadingState>(
            create: (context) => CollegeUploadingState(),
            builder: (context, _) => materialType == 'lecture' ? CollegeLectureUploadingFormWidget() : CollegeVideoUploadingFormWidget(),
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
      builder = (context) => ChangeNotifierProvider<QuizStateProvider>(
            create: (context) => new QuizStateProvider(),
            builder: (context, _) => QuizListDisplayer(),
          );
      break;

    case RouteNames.TAKE_QUIZ_EXAM:
      print(settings.arguments);
      Map<String, dynamic> args = settings.arguments;
      print(args);

      QuizCollection payload = args['data'];
      final bool fromLocal = args['fromLocal'];

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
      builder = (context) => ChangeNotifierProvider<QuizUploaderState>(
            create: (context) => QuizUploaderState(),
            builder: (context, _) => QuizUploaderWidget(),
          );
      break;

    case RouteNames.EDIT_QUIZ_DRAFT:
      QuizDraftEntity quizDraft = settings.arguments as QuizDraftEntity;
      builder = (context) => ChangeNotifierProvider<QuizUploaderState>(
            create: (context) => QuizUploaderState(fromDrafts: true, payload: quizDraft),
            lazy: false,
            builder: (context, _) => QuizUploaderWidget(),
          );
      break;

    case RouteNames.VIEW_MY_SAVED_MATERIALS:
      builder = (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<SavedCommonState>(
                create: (context) => SavedCommonState(),
              ),
              ChangeNotifierProvider<MySavedQuizStateProvider>(
                create: (context) => MySavedQuizStateProvider(),
              ),
              ChangeNotifierProvider<MySavedVideoStateProvider>(
                create: (context) => MySavedVideoStateProvider(),
              ),
              ChangeNotifierProvider<MySavedPDFStateProvider>(
                create: (context) => MySavedPDFStateProvider(),
              ),
            ],
            builder: (context, child) => Navigator(
              key: NavigationService.mySavedMaterialNavigatorKey,

              initialRoute: '/',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder _builder;
                switch (settings.name) {
                  case '/':
                    _builder = (_) => MySavedMaterialPage();
                    break;

                  case RouteNames.VIEW_VIDEO_DETAILS:
                    final int pos = settings.arguments;

                    final Widget child = isAcademic
                        ? CollegeVideoDetailsPage<MySavedVideoStateProvider>(pos: pos)
                        : SchoolVideoDetailsPage<MySavedVideoStateProvider>(pos: pos);

                    _builder = (context) => CommentStateChangeNotifierProvider<MySavedVideoStateProvider>(child: child, pos: pos);
                    break;

                  case RouteNames.VIEW_LECTURE_DETAILS:
                    final int pos = settings.arguments;

                    final Widget child = isAcademic
                        ? CollegePDFDetailsPage<MySavedPDFStateProvider>(pos: pos)
                        : SchoolPDFDetailsPage<MySavedPDFStateProvider>(pos: pos);

                    _builder = (context) => CommentStateChangeNotifierProvider<MySavedPDFStateProvider>(child: child, pos: pos);
                    break;

                  case RouteNames.EDIT_UPLOADED_QUIZ:
                    final QuizCollection quizCollection = settings.arguments as QuizCollection;

                    _builder = (context) => ChangeNotifierProvider<QuizUploaderState>(
                          create: (context) => QuizUploaderState(fromUploads: true, payload: quizCollection),
                          lazy: false,
                          builder: (context, _) => QuizUploaderWidget(),
                        );
                    break;
                }
                return new MaterialPageRoute(builder: _builder);
              },
            ),
          );
      break;

    default:
      builder = (context) => Container(
            child: Center(
              child: Text('${settings.name} is not Implemented Yet'),
            ),
          );
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
