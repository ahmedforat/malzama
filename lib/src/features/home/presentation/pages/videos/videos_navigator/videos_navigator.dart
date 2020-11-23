import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';
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
    final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).userData.accountType;
    super.build(context);
    return Navigator(
      key: widget.videoPageKey,
      onGenerateRoute: videosOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
