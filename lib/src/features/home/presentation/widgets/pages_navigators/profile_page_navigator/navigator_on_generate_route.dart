import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../../state_provider/quiz_drafts_state_provider.dart';
import '../../bottom_nav_bar_pages/user_profile/pages/explore_material.dart';
import '../../bottom_nav_bar_pages/user_profile/pages/user_profile.dart';
import '../../bottom_nav_bar_pages/user_profile/widgets/drafts_displayer.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> profileOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) => UserProfilePage();
      break;
    // display a lecture in a single page
    case RouteNames.VIEW_LECTURE:
      var args = settings.arguments as Map<String,dynamic>;
      builder = (context) => Container(
        child: Center(
          child: Text(args['title'].toString()),
        ),
      );
      break;

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

    case RouteNames.EXPLORE_MY_MATERIALS:
      builder = (context) => ExploreMaterialPage();
      break;

    case RouteNames.EXPLORE_MY_DRAFTS:
      builder = (context) => ChangeNotifierProvider<QuizDraftState>(
            create: (context) => QuizDraftState(),
            child: DraftsDisplayer(),
          );
      break;

    // display any other user profile page
    case RouteNames.VIEW_USER_PROFILE_PAGE:
      builder = (context) => throw UnimplementedError();
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
