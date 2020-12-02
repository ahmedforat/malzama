import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/details_pages/college_video_details_page.dart';

import 'pages/display_videos_page.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> videosOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) => DisplayVideosPage();
      break;

    case RouteNames.VIEW_VIDEO_DETAILS:
      final int pos = settings.arguments;
      builder = (context) => CollegeVideoDetailsPage(pos: pos);
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
