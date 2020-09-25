import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/general_models/customDate.dart';
import '../../state_provider/notifcation_state_provider.dart';

class NotificationWidget extends StatelessWidget {
  final int pos;

  const NotificationWidget({Key key, this.pos}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    NotificationStateProvider notificationStateProvider = Provider.of<NotificationStateProvider>(context,listen:false);
    int notificationsCount = notificationStateProvider.notificationsList.length;
    var notification = notificationStateProvider.notificationsList[notificationsCount - (pos + 1)];
    ScreenUtil.init(context);
    return Selector<NotificationStateProvider,bool>(
      selector: (context,stateProvider) => stateProvider.notificationsList[notificationsCount - (pos + 1)].isOpened,
      builder:(context,isOpened,_) => Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(20)),
        color: isOpened? Colors.white:Colors.deepPurple.withOpacity(0.1),
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(notification.title,),
          subtitle: Text(
            notification.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(CustomDate().getPostedAt(notification.sentAt)),
        ),
      ),
    );
  }
}
