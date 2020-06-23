import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/usecases/log_out.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../core/platform/services/file_system_services.dart';
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey;
  TabController tabController;
  PageController pageController;
  FlutterLocalNotificationsPlugin notificationsPlugin = new FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iOSSettings;
  InitializationSettings initializationSettings;

  Future <void>_onDidRecieveLocalNotification(int x,String y,String z,String zz){
    print('on did recieved lcoal notificaiton callback');
  }

  Future<void> _initilizeLocalNotification()async{
    androidInitializationSettings = new AndroidInitializationSettings('app_icon.jpg');
    iOSSettings = new IOSInitializationSettings(onDidReceiveLocalNotification: _onDidRecieveLocalNotification);
    initializationSettings = new InitializationSettings(androidInitializationSettings, iOSSettings);
   await notificationsPlugin.initialize(initializationSettings,onSelectNotification: (val)async{
      print('notification has been selected');
    });
  }

  Future<void> showNotification({int channelID,String title,String body})async{
    NotificationDetails notificationDetails ;
    AndroidNotificationDetails androidNotificationDetails = new  AndroidNotificationDetails("Channel_ID", "Channel title", "Channel body",
    priority: Priority.High,
    importance: Importance.Max,
      ticker:'test'
    );
    IOSNotificationDetails iosNotificationDetails = new IOSNotificationDetails();
    notificationDetails = new NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    await notificationsPlugin.show(channelID,title,body,notificationDetails);
  }
  Future<void> _initializeOneSignal() async {
    
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  


    OneSignal.shared.init("50c8ad6e-b20b-4f8e-a71a-219c4f4ce74e", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.sendTag('major', 'web-developer');
    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        print('=========================================');
         print('UUID');
        print(changes.to.userId);
         print('=========================================');
     });
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
          // do whatever the hell you wanna do in your life mother fucker
          print('this is the title');
          print(notification.androidNotificationId);
          print('addtional data');
          print(notification.payload.additionalData);
           print('body');
          print(notification.payload.body);

            showNotification(channelID: 0,title:notification.payload.title,body:notification.payload.body,);
           print('subtitle');
          print(notification.payload.subtitle);

           print('subtitle');
        


          
          
      print(notification.payload.title);
    });
  }

  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 4);
    scaffoldKey = new GlobalKey<ScaffoldState>();

    // Subscribe to OneSignal
    _initializeOneSignal();
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
          children: <Widget>[
            getFirstWidget(),
            getSecondWidget(),
            getThirdWidget(),
            UserProfilePage()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        controller: tabController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(await FileSystemServices.getUserData());
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
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/signup-page', (route) => false);
            } else if (response is SnackBarException) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(response.message),
              ));
            } else {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/signup-page', (route) => false);
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
