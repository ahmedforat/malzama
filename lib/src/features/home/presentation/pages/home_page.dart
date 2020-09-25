import 'package:flutter/material.dart';
import 'package:malzama/demos/google_map.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import '../state_provider/user_info_provider.dart';

import '../widgets/pages_navigators/home_page_navigator/home_page_navigator/home_navigator.dart';
import '../widgets/pages_navigators/material_navigator/material_navigator.dart';
import '../widgets/pages_navigators/videos_navigator/videos_navigator.dart';
import 'package:provider/provider.dart';

import '../../../../core/Navigator/navigation_service.dart';
import '../../../../core/platform/services/notifications_service/one_signal_notfication.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import '../widgets/pages_navigators/notifications_navigator/notification_navigator.dart';
import '../widgets/pages_navigators/profile_page_navigator/profile_navigator.dart';

// OneSignal App ID
// 50c8ad6e-b20b-4f8e-a71a-219c4f4ce74e
// 50c8ad6e-b20b-4f8e-a71a-219c4f4ce74e

// userid
// 6e45569e-cbc6-413e-b9d0-3504194649f3
// 6e45569e-cbc6-413e-b9d0-3504194649f3

GlobalKey<ScaffoldState> globalScaffoldKey;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isStudent;
  TabController tabController;
  List<GlobalKey<NavigatorState>> _pagesNavigators;
  List<String> _playersIds;

  void _onTabChangeListener() {
    print('tabBar has been changeed ${tabController.index}');
    NavigationService.getInstance().currentIndex = tabController.index;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _playersIds = List<String>.generate(1000, (i) => 'bcce43f2-3072-46f0-b2c6-ba7832fcd410');
    _pagesNavigators = NavigationService.navigationKeys;
    tabController = new TabController(vsync: this, length: 5, initialIndex: 0);
    tabController.addListener(_onTabChangeListener);
    NavigationService.getInstance().controller = tabController;
    NavigationService.getInstance().currentIndex = tabController.index;
    globalScaffoldKey = new GlobalKey<ScaffoldState>();

    // subscribe to OneSignal and activate Notification System
    NotificationService notificationService = NotificationService.getInstance();
    notificationService.initialize();

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //context.dependOnInheritedWidgetOfExactType();
    print('*****************************************');
    print('*****************************************');
    print(state);
    print('*****************************************');
    print('*****************************************');

    if (state == AppLifecycleState.detached) {
      print('*****************************************');
      print('the app is closed');
      print('*****************************************');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    //  var state = Provider.of<CommonWidgetsStateProvider>(context,listen:false);
    return tabController == null
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : WillPopScope(
            onWillPop: () {
              print('on will pop');
              print(tabController.index);

              final UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context,listen: false);

              if(!userInfoStateProvider.isBottomNavBarVisible){
                userInfoStateProvider.bottomSheetController.close();
              }
              if (_pagesNavigators[tabController.index].currentState.canPop()) {
                _pagesNavigators[tabController.index].currentState.pop();
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(

                key: globalScaffoldKey,
                body: Container(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: <Widget>[
                      HomePageNavigator(
                        homePageKey: _pagesNavigators[0],
                      ),
                      MaterialNavigator(
                        materialPageKey: _pagesNavigators[1],
                      ),
                      GoogleMapDemo(),
                      // VideosNavigator(
                      //   videoPageKey: _pagesNavigators[2],
                      // ),
                      NotificationsNavigator(
                        notificationPageKey: _pagesNavigators[3],
                      ),
                      ProfileNavigator(
                        profilePageKey: _pagesNavigators[4],
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Selector<UserInfoStateProvider, bool>(
                  selector: (context, stateProvider) => stateProvider.isBottomNavBarVisible,
                  builder: (context, isVisibile, _) {
                    return isVisibile
                        ? BottomNavigationBarWidget(
                            controller: tabController,
                            isStudent: isStudent,
                          )
                        : SizedBox();
                  },
                )
//              floatingActionButton: FloatingActionButton(
//                child: Icon(Icons.notifications),
//                onPressed: () async {
//                  print(Provider.of<NotificationStateProvider>(context,listen:false).notificationsList.length);
////                  var data = await FileSystemServices.getUserData();
////                  print(data['account_type']);
//                  for(int i = 0; i < 1000; i++){
//                    await OneSignal.shared.postNotification(OSCreateNotification(heading: 'Hellow',subtitle: 'Hello',
//                        content: 'Hello user number ${i+1} , this is your code ${i+1 * 2}',
//                        additionalData: {'name': '$i', 'age': '${i+10}', 'career': 'software ${i+10}engineer', 'action': 'www.google.com'},
//                        playerIds: [_playersIds[0]],
//                        buttons: [OSActionButton(id: '102', text: 'Ok', icon: 'check')]));
//                    print('req number $i has been sent');
//                  }
//                  // var list =
//                  //     Provider.of<NotificationStateProvider>(context, listen: false)
//                  //         .notificationsList;
//                  // list.forEach((element) {
//                  //   print(element.asHashMap());
//                  // });
//                  // print(list[0].id == list[1].id);
////            var localNotification = LocalNotificationService.getInstance();
////            localNotification.initialize();
////            localNotification.showNotification(channelID: 0,title:'Hello World',body: 'Hello World body',payload: 'Hello World payload');
//                },
//              ),
                ),
          );
  }


  @override
  void dispose() {
    print('we are disposing the home page');
    tabController.removeListener(_onTabChangeListener);
    tabController.dispose();
    super.dispose();
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
