import 'package:flutter/material.dart';

import 'material_navigator_on_generate_route.dart';

class MaterialNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> materialPageKey;
  MaterialNavigator({@required this.materialPageKey});
  @override
  _MaterialNavigatorState createState() => _MaterialNavigatorState();
}

class _MaterialNavigatorState extends State<MaterialNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Navigator(
      key: widget.materialPageKey,
      onGenerateRoute: materialOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
