import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../state_provider/user_info_provider.dart';
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
    final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
    final bool isAcademic = HelperFucntions.isAcademic(accountType);
    super.build(context);
    return Navigator(
      key: widget.homePageKey,
      onGenerateRoute: homeOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
