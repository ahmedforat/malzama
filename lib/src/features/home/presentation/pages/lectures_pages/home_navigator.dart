import 'package:flutter/material.dart';

import 'navigator_on_generate_route.dart';

class HomePageNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> homePageKey;
  HomePageNavigator({@required this.homePageKey});

  @override
  _HomePageNavigatorState createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Navigator(
      key: widget.homePageKey,
      onGenerateRoute: homeOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
