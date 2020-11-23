import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import '../state_provider/notifcation_state_provider.dart';
import 'notifications/notification_widgets/notification_widget.dart';

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
                await QuizAccessObject().deleteUploadedMaterial(MyUploaded.QUIZES);
                print('quizes deleted');
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
