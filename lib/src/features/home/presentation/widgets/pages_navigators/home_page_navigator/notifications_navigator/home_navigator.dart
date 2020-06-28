import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';

import 'navigator_on_generate_route.dart';

class HomePageNavigator extends StatefulWidget {
  @override
  _HomePageNavigatorState createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return  new Navigator(
      key: locator.get<NavigationService>().homePageNavigatorKey,
      onGenerateRoute: homeOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
