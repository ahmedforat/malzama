import 'package:flutter/material.dart';
import 'package:malzama/src/core/general_widgets/comment_state_change_notifier.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/video_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../../../models/materials/study_material.dart';
import '../../shared/comments_and_replies/commentsPage.dart';
import '../../shared/comments_and_replies/replies/widgets/display_rators_page.dart';
import '../../shared/comments_and_replies/state_providers/add_comment_widget_state_provider.dart';
import '../../shared/comments_and_replies/state_providers/comment_state_provider.dart';
import 'pages/display_videos_page.dart';

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
      builder = (context) => CommentStateChangeNotifierProvider<VideoStateProvider>(
            child: Container(
              child: Center(
                child: Text('Hello Videos'),
              ),
            ),
            args: args,
          );
      break;

    case RouteNames.DISPLAY_COMMENT_RATORS:
      builder = (context) => DisplayRatorsPage();
      break;
    // display a quiz in a single page
    // case RouteNames.VIEW_QUIZ:
    //   builder = (context) => throw UnimplementedError();
    //   break;

    case RouteNames.VIEW_COMMENTS_PAGE:
      final Map<String, dynamic> args = settings.arguments;
      builder = (context) => ChangeNotifierProvider<AddOrEditCommentWidgetStateProvider>(
            create: (context) => AddOrEditCommentWidgetStateProvider(),
            child: CommentsPage(
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
