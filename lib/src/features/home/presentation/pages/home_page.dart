import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/notifications.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import 'package:malzama/src/features/home/usecases/log_out.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/platform/services/file_system_services.dart';
import '../../../../core/platform/services/notifications_service/local_notification.dart';
import '../../../../core/platform/services/notifications_service/local_notification.dart';
import '../../../../core/platform/services/notifications_service/one_signal_notfication.dart';
import '../../../../core/platform/services/notifications_service/one_signal_notfication.dart';
import '../widgets/bottom_nav_bar_pages/user_profile/pages/user_profile.dart';
import '../widgets/bottom_nav_bar_widget.dart';

// OneSignal App ID
// 50c8ad6e-b20b-4f8e-a71a-219c4f4ce74e
// 50c8ad6e-b20b-4f8e-a71a-219c4f4ce74e

// userid
// 6e45569e-cbc6-413e-b9d0-3504194649f3
// 6e45569e-cbc6-413e-b9d0-3504194649f3
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey;
  TabController tabController;
  PageController pageController;







  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 4);
    scaffoldKey = new GlobalKey<ScaffoldState>();

    // subscribe to OneSignal and activate Notification System
    NotificationService notificationService = NotificationService.getInstance();
    notificationService.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  var state = Provider.of<CommonWidgetsStateProvider>(context,listen:false);
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   actions: <Widget>[
      //     SizedBox(
      //         width: 100,
      //         child: IconButton(
      //             icon: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: <Widget>[
      //                 Text('Sign out'),
      //                 FaIcon(FontAwesomeIcons.signOutAlt)??Text('logOut')
      //               ],
      //             ),
      //             onPressed: () async {
      //               print('inside logout');
      //               ContractResponse response = await AccessManager.signOut();
      //                 print('this is the status code inside homepate'+response.statusCode.toString());
      //               if (response is SnackBarException) {
      //                 scaffoldKey.currentState.showSnackBar(SnackBar(
      //                   content: Text(response.message),
      //                   duration: Duration(seconds: 3),
      //                 ));
      //                 if(response is AuthorizationBreaking){
      //                   print('inside authorization breaking');
      //                   Future.delayed(Duration(seconds: 3));
      //                   Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (_) => false);
      //                 }
      //               }else if(response is Success){
      //                  Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (_) => false);
      //               }else{
      //                 print(response.message);
      //                 DebugTools.showErrorMessageWidget(context: context, message: response.message);
      //               }
      //             })),
      //   ],
      // ),
      body: Container(
        child: TabBarView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: tabController,
          children: <Widget>[getFirstWidget(), getSecondWidget(), NotificationPage(), UserProfilePage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        controller: tabController,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: () async {
            var list = Provider.of<NotificationStateProvider>(context,listen: false).notificationsList;
            list.forEach((element) {print(element.asHashMap());});
            print(list[0].id == list[1].id);
//            var localNotification = LocalNotificationService.getInstance();
//            localNotification.initialize();
//            localNotification.showNotification(channelID: 0,title:'Hello World',body: 'Hello World body',payload: 'Hello World payload');

        },
      ),
    );
  }

  Widget getFirstWidget() {
    print('building first Page');
    return Container(
      color: Colors.red,
      child: Center(
        child: RaisedButton(
          child: Text('Log out'),
          onPressed: () async {
            ContractResponse response = await AccessManager.signOut();
            if (response is AuthorizationBreaking) {
              Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (route) => false);
            } else if (response is SnackBarException) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(response.message),
              ));
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (route) => false);
            }
          },
        ),
      ),
    );
  }
}

Widget getSecondWidget() {
  print('building second Page');
  return Container(
    color: Colors.green,
  );
}

Widget getThirdWidget() {
  print('building first Page');
  return Container(
    color: Colors.yellow,
  );
}
