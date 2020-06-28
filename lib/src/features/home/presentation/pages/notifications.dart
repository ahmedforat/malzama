import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/state_provider/notifcation_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/notification_widgets/notification_widget.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationStateProvider notificationStateProvider = Provider.of<NotificationStateProvider>(context, listen: false);
    print('notification page created');
    ScreenUtil.init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Notifications',
            style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(80)),
          ),
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(20)),
          child: notificationStateProvider.notificationsList.isEmpty? Center(child: Text('You have No Notifications Yet'))

              : Selector<NotificationStateProvider, int>(
                  selector: (context, stateProvider) => stateProvider.notificationsList.length,
                  builder: (context, notificationCount, child) => ListView.builder(
                    itemCount: notificationCount,
                    itemBuilder: (BuildContext context, int pos) => NotificationWidget(
                      pos: pos,
                    ),
                  ),
                ),
        ));
  }
}
