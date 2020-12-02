import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';

class MySavedMaterialsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return ListTile(
      title: Text(
        'My Saved',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60)),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Selector<UserInfoStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.userData.savedLectures.length,
            builder: (context, count, _) => Text(
              ' $count lectures',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(50),
          ),
          Selector<UserInfoStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.userData.savedVideos.length,
            builder: (context, count, _) => Text(
              ' $count videos',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(50),
          ),
          Selector<UserInfoStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.userData.savedQuizes.length,
            builder: (context, count, _) => Text(
              '$count quizes',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
          ),
        ],
      ),
      trailing: RaisedButton(
        color: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.VIEW_MY_SAVED_MATERIALS);
        },
        child: Text(
          'Explore',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
