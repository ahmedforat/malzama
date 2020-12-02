import 'package:flutter/material.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/details_pages/college_pdf_details_page.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/details_pages/school_pdf_details_page.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/Navigator/routes_names.dart';
import '../shared/comments_and_replies/state_providers/comment_state_provider.dart';
import 'pages/pdfs_page.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> homeOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) =>
          DisplayHomePage() ??
          Container(
            color: Colors.white,
            child: Center(
              child: Text('Home Page'),
            ),
          );
      break;

    // case RouteNames.DISPLAY_COMMENT_RATORS:
    //   print('we are naving to rators page from within home page');
    //   print(settings.arguments);
    //   builder = (context) => DisplayRatorsPage(ratingsList: settings.arguments);
    //   break;
    // display a lecture in a single page

    // view lecture details page
    case RouteNames.VIEW_LECTURE_DETAILS:
      final bool isAcademic = locator<UserInfoStateProvider>().isAcademic;
      try {
        var args = settings.arguments as Map<String, dynamic>;
        builder = (context) => ChangeNotifierProvider<CommentStateProvider>(
              lazy: false,
              create: (context) => CommentStateProvider(
                state: args['state'],
                isVideo: args['isVideo'],
                materialPos: args['pos'],
              ),
              builder: (context, _) => isAcademic ? CollegePDFDetailsPage(
                pos: args['pos'],
              ) : SchoolPDFDetailsPage(
              ),
            );
      } catch (err) {
        throw err;
      }
      break;

    // display a quiz in a single page
    // case RouteNames.VIEW_QUIZ:
    //   builder = (context) => throw UnimplementedError();
    //   break;

//    case RouteNames.VIEW_COMMENTS_PAGE:
//      final Map<String,dynamic> args = settings.arguments as Map<String, dynamic>;
//      builder = (context) => ChangeNotifierProvider<AddOrEditCommentWidgetStateProvider>(
//        create:(context) => AddOrEditCommentWidgetStateProvider(),
//        child: CommentsPage(
//          isVideo: args['isVideo'],
//          pos: args['pos'],
//        ),
//      );
//      break;
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
  }

  return new MaterialPageRoute(builder: builder);
}
