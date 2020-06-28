import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../state_provider/notifcation_state_provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final TabController _controller;

  BottomNavigationBarWidget({TabController controller}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    NotificationStateProvider notificationStateProvider = Provider.of<NotificationStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    return TabBar(
      onTap: (index) {
        if(index == 2){
          notificationStateProvider.setNotificationCountToZero();
        }
      },
      controller: _controller,
      tabs: <Widget>[
        Tab(
          icon: Icon(
            Icons.home,
            color: Colors.black,
            size: ScreenUtil().setSp(80),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.home,
            color: Colors.black,
            size: ScreenUtil().setSp(80),
          ),
        ),
        Selector<NotificationStateProvider, int>(
          selector: (context, stateProvider) => stateProvider.notOpenedNotificationsCount,
          builder: (context, count, _) => Container(
            height: ScreenUtil().setHeight(140),

            //color: Colors.blueAccent,
            //alignment: Alignment.center,
            child: SizedBox.expand(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: ScreenUtil().setSp(80),
                    ),
                  ),
                  if(count > 0)
                  Positioned(
                    left: ScreenUtil().setSp(95),
                    bottom: ScreenUtil().setSp(80),
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        minHeight: ScreenUtil().setHeight(60),
                        maxHeight: ScreenUtil().setHeight(60),
                        minWidth: ScreenUtil().setHeight(50),

                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.red),
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.account_circle,
            color: Colors.black,
            size: ScreenUtil().setSp(80),
          ),
        ),
      ],
    );
  }
}
