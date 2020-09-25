import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/videos_navigator/pages/display_videos_page.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/commentsPage.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/state_providers/add_comment_widget_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/view_college_material.dart';
import 'package:provider/provider.dart';
import '../../single_page_display_widgets/comments_and_replies/state_providers/comment_state_provider.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> videosOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) =>
          DisplayVideosPage() ??
          Container(
            color: Colors.white,
            child: Center(
              child: Text('Home Page'),
            ),
          );
      break;

    // display a video in a single page
    case RouteNames.VIEW_VIDEO:
      var args = settings.arguments as Map<String, dynamic>;
      builder = (context) => ChangeNotifierProvider<CommentStateProvider>(
        create: (context) => CommentStateProvider(state: args['state'] as List<String>),
        child: CollegeMaterialViewPage(
          pos: args['pos'],
          isVideo: args['isVideo'],
          addComment: args['addComment'],
        ),
      );
      break;

    // display a quiz in a single page
    case RouteNames.VIEW_QUIZ:
      builder = (context) => throw UnimplementedError();
      break;

    case RouteNames.VIEW_COMMENTS_PAGE:
      final Map<String,dynamic> args = settings.arguments;
      builder = (context) => ChangeNotifierProvider<AddOrEditCommentWidgetStateProvider>(
        create:(context) => AddOrEditCommentWidgetStateProvider(),
        child: CommentsPage(
          isVideo: args['isVideo'],
          pos: args['pos'],
        ),
      );
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
  }

  return new MaterialPageRoute(builder: builder);
}
