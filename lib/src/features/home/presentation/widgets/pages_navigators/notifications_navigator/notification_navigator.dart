
import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';

import 'navigator_on_generate_route.dart';

class NotificationsNavigator extends StatefulWidget {
  @override
  _NotificationsNavigatorState createState() => _NotificationsNavigatorState();
}

class _NotificationsNavigatorState extends State<NotificationsNavigator> with AutomaticKeepAliveClientMixin {
  
@override 
bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Navigator(
      key: NavigationService.getInstance().notificationsNavigatorKey,
      onGenerateRoute: notificationsOnGenerateRoutes,
      initialRoute: '/',
    );
  }

}