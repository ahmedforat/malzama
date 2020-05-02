import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../state_provider/my_materials_state_provider.dart';
import '../../../../state_provider/profile_page_state_provider.dart';

class MaterialDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState profilePageState =
        Provider.of<ProfilePageState>(context, listen: false);
    MyMaterialStateProvider myMaterialStateProvider =
        Provider.of<MyMaterialStateProvider>(context, listen: false);

    return Container(
      //color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(25),
                  vertical: ScreenUtil().setSp(15)),
              child: Text(
                References.isTeacher(profilePageState)
                    ? 'My Materials'
                    : 'My saved materials',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(80)),
              )),
          SizedBox(height: ScreenUtil().setHeight(20)),
          Selector<MyMaterialStateProvider, List<int>>(
            selector: (context, stateProvider) =>
                [stateProvider.myPDFs.length, stateProvider.myVideos.length],
            builder: (context, _, __) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil().setWidth(50),
                ),
                Text(
                  ' ${myMaterialStateProvider.myVideos == null ? 0 : myMaterialStateProvider.myVideos.length} videos',
                  style: TextStyle(fontSize: ScreenUtil().setSp(45)),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(50),
                ),
                Text(
                  '${myMaterialStateProvider.myPDFs == null ? 0 : myMaterialStateProvider.myPDFs.length} lectures',
                  style: TextStyle(fontSize: ScreenUtil().setSp(45)),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(750)),
              child: RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.of(context).pushNamed('/explore-my-material');
                },
                child: Text(
                  'Explore',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
