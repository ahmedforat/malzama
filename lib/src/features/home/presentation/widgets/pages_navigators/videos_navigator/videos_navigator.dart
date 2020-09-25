import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/videos_navigator/state/state_getter.dart';
import 'package:provider/provider.dart';

import 'navigator_on_generate_route.dart';

class VideosNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> videoPageKey;
  VideosNavigator({@required this.videoPageKey});

  @override
  _VideosNavigatorState createState() => _VideosNavigatorState();
}

class _VideosNavigatorState extends State<VideosNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
    final bool isAcademic = HelperFucntions.isAcademic(accountType);
    super.build(context);
    return getDisplayVideosStateProvider(
      isAcademic: isAcademic,
      child: Navigator(
        key: widget.videoPageKey,
        onGenerateRoute: videosOnGenerateRoutes,
        initialRoute: '/',
      ),
    );
  }
}
