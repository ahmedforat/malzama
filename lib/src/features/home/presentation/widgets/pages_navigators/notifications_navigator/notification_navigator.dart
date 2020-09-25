import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import '../../../../../../core/platform/services/dialog_services/service_locator.dart';
import 'navigator_on_generate_route.dart';

class NotificationsNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> notificationPageKey;
  NotificationsNavigator({@required this.notificationPageKey});

  @override
  _NotificationsNavigatorState createState() => _NotificationsNavigatorState();
}

class _NotificationsNavigatorState extends State<NotificationsNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Navigator(
      key: widget.notificationPageKey,
      onGenerateRoute: notificationsOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
