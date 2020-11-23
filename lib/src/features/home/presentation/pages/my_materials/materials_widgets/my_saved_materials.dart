import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';

class MySavedMaterials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);


    return ListTile(
      title: Text(
        'My Saved',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60)),
      ),
      subtitle: Selector<UserInfoStateProvider, List<int>>(
        selector: (context, stateProvider) => [
          stateProvider.userData.savedLectures.length,
          stateProvider.userData.savedVideos.length,
          stateProvider.userData.savedQuizes.length,
        ],
        builder: (context, data, __) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              ' ${data[1]}videos',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(50),
            ),
            Text(
              '${data[0]} lectures',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(50),
            ),
            Text(
              '${data[2]} quizes',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),

          ],
        ),
      ),
      trailing: RaisedButton(
        color: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed('/explore-my-material');
        },
        child: Text(
          'Explore',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
