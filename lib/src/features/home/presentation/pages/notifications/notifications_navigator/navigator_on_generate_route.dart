import 'package:flutter/material.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../notifications.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> notificationsOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) => NotificationPage();
      break;
    // display a lecture in a single page
    case RouteNames.VIEW_LECTURE:
    
      Map<String,dynamic> args = settings.arguments;
      builder = (context) => Container(

        child: Text(args['title'].toString())
      );
      break;

    // case RouteNames.DISPLAY_COMMENT_RATORS:
    //   builder = (context) => DisplayRatorsPage();
    //   break;
    // display a video in a single page
    case RouteNames.VIEW_VIDEO:
      builder = (context) => throw UnimplementedError();
      break;

    // display a quiz in a single page
    // case RouteNames.VIEW_QUIZ:
    //   builder = (context) => throw UnimplementedError();
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
  }

  return new MaterialPageRoute(builder: builder);
}
