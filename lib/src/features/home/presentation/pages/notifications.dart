
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../state_provider/notifcation_state_provider.dart';
import 'notifications/notification_widgets/notification_widget.dart';

Map<String, dynamic> data = {
  'name': 'Karrar Mohammed',
  'age': 27,
  'career': 'software engineer',
  'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
  'birthDate': '17/05/1993',
  'co-worker': 'Ahmed Furat',
  'co-worker-age': 27,
  'co-worker-career': 'software engineer',
  'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
  'co-worker-birthDate': '11/07/1993',
  'sub-data': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  },
  'sub-sub-data': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  },
  'sub-sub': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  },
  'payload': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  }
};

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    print('notification page created');
    ScreenUtil.init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Notifications',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(80)),
          ),
          elevation: 0.0,
          actions: [
            IconButton(
              icon: Icon(Icons.dashboard, color: Colors.amber,),
              onPressed: () async {
               //  print('cachedFiles = ${locator<UserInfoStateProvider>().cachedFiles}');
               // Directory d = await getApplicationDocumentsDirectory();
               // final String dirPath = '${d.path}/cached_files';
               //  Directory(dirPath).createSync();
               // print(Directory(dirPath).existsSync());
               // var dd = Directory(dirPath).listSync();
               // print(dd);
               //  print('quizes deleted');


              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(20)),
          child: Selector<NotificationStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.notificationsList.length,
            builder: (context, notificationCount, child) =>
            notificationCount == 0
                ? Center(child: Text('You have No Notifications Yet'))
                : ListView.builder(
              itemCount: notificationCount,
              itemBuilder: (BuildContext context, int pos) =>
                  NotificationWidget(
                    pos: pos,
                  ),
            ),
          ),
        ));
  }
}
