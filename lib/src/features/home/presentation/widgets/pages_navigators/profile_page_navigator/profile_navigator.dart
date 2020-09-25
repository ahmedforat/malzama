import 'package:flutter/material.dart';

import '../../../../../../core/Navigator/navigation_service.dart';
import 'navigator_on_generate_route.dart';

class ProfileNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> profilePageKey;
  ProfileNavigator({@required this.profilePageKey});

  @override
  _ProfileNavigatorState createState() => _ProfileNavigatorState();
}

class _ProfileNavigatorState extends State<ProfileNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Navigator(
      key: widget.profilePageKey,
      onGenerateRoute: profileOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
