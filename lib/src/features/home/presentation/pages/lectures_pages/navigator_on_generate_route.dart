import 'package:flutter/material.dart';

import '../../../../../core/Navigator/routes_names.dart';
import '../../../../../core/general_widgets/comment_state_change_notifier.dart';
import '../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../state_provider/user_info_provider.dart';
import '../shared/materials_details_pages/details_pages/college_pdf_details_page.dart';
import '../shared/materials_details_pages/details_pages/school_pdf_details_page.dart';
import 'pages/pdfs_page.dart';
import 'state/pdf_state_provider.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> homeOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;
  final bool isAcademic = locator<UserInfoStateProvider>().isAcademic;

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
      final int pos = settings.arguments;
      final Widget _child =
          isAcademic ? CollegePDFDetailsPage<PDFStateProvider>(pos: pos) : SchoolPDFDetailsPage<PDFStateProvider>(pos: pos);
      builder = (context) => CommentStateChangeNotifierProvider<PDFStateProvider>(
            child: _child,
            pos: pos,
          );

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
