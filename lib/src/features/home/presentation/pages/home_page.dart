import 'package:flutter/material.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';

import '../../../../core/platform/services/file_system_services.dart';
import '../widgets/bottom_nav_bar_pages/user_profile/pages/user_profile.dart';
import '../widgets/bottom_nav_bar_widget.dart';

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
    tabController = new TabController(vsync: this,length: 4);
    scaffoldKey = new GlobalKey<ScaffoldState>();
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
        bottomNavigationBar: BottomNavigationBarWidget(controller: tabController,),
        floatingActionButton: FloatingActionButton(
    onPressed: () async {
      print(await FileSystemServices.getUserData());
    },
        ),
      );
  }
}


Widget getFirstWidget(){
  print('building first Page');
  return Container(color: Colors.red,);
}
Widget getSecondWidget(){
  print('building second Page');
  return  Container(color: Colors.green,);
}
Widget getThirdWidget(){
  print('building first Page');
  return Container(color: Colors.yellow,);
}