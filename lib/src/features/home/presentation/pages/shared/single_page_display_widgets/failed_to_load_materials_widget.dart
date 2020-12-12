import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';

class FailedToLoadMaterialsWidget extends StatelessWidget {
  final VoidCallback onReload;
  final String message;
  final bool onReloadOnly;

  FailedToLoadMaterialsWidget({
    @required this.onReload,
    @required this.message,
    bool onReloadOnly
  }) : this.onReloadOnly = onReloadOnly ?? false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.sentiment_dissatisfied,
              size: ScreenUtil().setSp(180),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Text(
              message ?? 'Failed to load',
              style: TextStyle(fontSize: ScreenUtil().setSp(50)),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(40)),
              child: Text(
                'It might be the server is not responding '
                'or  the your internet connection is not established\n'
                'make sure you are connected to the internet and try again',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ScreenUtil().setSp(40)),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            RaisedButton(
              child: Text(
                'Reload',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
              onPressed: () async {
                if(!onReloadOnly){
                  Provider.of<UserInfoStateProvider>(context, listen: false).fetchQuizesCount();
                }
                onReload();
              },
            )
          ],
        ),
      ),
    );
  }
}
