import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../../state_provider/user_info_provider.dart';

class MyUploadedMaterials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return ListTile(
      title: Text(
        'My Uploads',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60)),
      ),
      subtitle: Selector<UserInfoStateProvider, List<int>>(
        selector: (context, stateProvider) => [
          stateProvider.uploadedPDFsCount,
          stateProvider.uploadedVideosCount,
          stateProvider.uploadedQuizsCount,
        ],
        builder: (context, uploads, _) => Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: Row(
            children: <Widget>[
              Text(
                '${uploads[1]} videos',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(30),
              ),
              Text(
                '${uploads[0]} lectures',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(30),
              ),
              Text(
                '${uploads[2]} quizes',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                ),
              ),
            ],
          ),
        ),
      ),
      trailing: RaisedButton(
        color: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.EXPLORE_MY_MATERIALS);
        },
        child: Text(
          'Explore',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
