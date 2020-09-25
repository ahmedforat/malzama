import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/general_widgets/custom_change_notifier.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/platform/services/dialog_services/service_locator.dart';
import 'navigator_on_generate_route.dart';

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
    String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
    bool isAcademic = HelperFucntions.isAcademic(accountType);
    return Navigator(
      key: widget.materialPageKey,
      onGenerateRoute: materialOnGenerateRoutes,
      initialRoute: '/',
    );
  }
}
