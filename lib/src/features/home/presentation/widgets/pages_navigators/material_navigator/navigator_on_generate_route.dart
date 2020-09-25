import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/college_uploading_video_dialog_body.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/school_uploading_lecture_dialog_body.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/school_uploading_video_dialog_body.dart';
import 'package:malzama/src/core/platform/services/material_uploading/college_uploads_state_provider.dart';
import 'package:malzama/src/core/platform/services/dialog_services/widgets/college_uploading_lecture_dialog_body.dart';
import 'package:malzama/src/core/platform/services/material_uploading/school_uploads_state_provider.dart';

import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/material_page.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/pages/explore_material.dart';
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
      return new MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<CollegeUploadingState>(
          create: (context) => CollegeUploadingState(),
          builder: (context, _) => materialType == 'lecture' ? UploadingLectureBodyForUniversities() : UploadingVideoBodyForUniversities(),
        ),
      );

    case RouteNames.UPLOAD_NEW_MATERIAL_SCHOOL:
      String materialType = settings.arguments;
      return new MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<SchoolUploadState>(
            create: (context) => SchoolUploadState(),
            builder: (context, _) => materialType == 'lecture' ? UploadingLectureBodyForSchools() : UploadingVideoBodyForSchools()),
      );

    // display a video in a single page
    case RouteNames.VIEW_VIDEO:
      builder = (context) => throw UnimplementedError();
      break;

    // display a quiz in a single page
    case RouteNames.VIEW_QUIZ:
      builder = (context) => throw UnimplementedError();
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
