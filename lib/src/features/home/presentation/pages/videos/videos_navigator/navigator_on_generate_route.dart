import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/comments_and_replies/state_providers/comment_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../../../../../core/general_widgets/comment_state_change_notifier.dart';
import '../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../state_provider/user_info_provider.dart';
import '../../shared/materials_details_pages/details_pages/college_video_details_page.dart';
import '../../shared/materials_details_pages/details_pages/school_video_details_page.dart';
import 'pages/display_videos_page.dart';
import 'state/video_state_provider.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> videosOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;
  final bool isAcademic = locator<UserInfoStateProvider>().isAcademic;
  switch (settings.name) {
    case '/':
      builder = (context) => DisplayVideosPage();
      break;

    case RouteNames.VIEW_VIDEO_DETAILS:
      final int pos = settings.arguments;
      final Widget _child =
          isAcademic ? CollegeVideoDetailsPage<VideoStateProvider>(pos: pos) : SchoolVideoDetailsPage<VideoStateProvider>(pos: pos);
      builder = (context) => ChangeNotifierProvider<CommentStateProvider<VideoStateProvider>>(
        lazy: false,
        create: (context) => CommentStateProvider<VideoStateProvider>(
          context: context,
          materialPos: pos,
        ),
        builder: (context, _) => _child,
      );
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
