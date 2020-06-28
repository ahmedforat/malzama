
import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';

import 'navigator_on_generate_route.dart';

class ProfileNavigator extends StatefulWidget {
  @override
  _ProfileNavigatorState createState() => _ProfileNavigatorState();
}

class _ProfileNavigatorState extends State<ProfileNavigator> with AutomaticKeepAliveClientMixin {
  
@override 
bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Navigator(
      key: NavigationService.getInstance().profilePageNavigatorKey,
      onGenerateRoute: profileOnGenerateRoutes,
      initialRoute: '/',
    );
  }

}