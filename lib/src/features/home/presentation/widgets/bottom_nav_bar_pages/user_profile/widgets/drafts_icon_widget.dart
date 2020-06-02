import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../state_provider/my_materials_state_provider.dart';
import '../../../../state_provider/profile_page_state_provider.dart';

class DraftIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context,listen: false);

    return Selector<ProfilePageState,int>(
      selector: (context,stateProvider) => stateProvider.quizDraftsCount,
      builder:(context,quizCollectionsCount,__) =>  Container(
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
                  'My Drafts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(80)),
                )),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Padding(
              padding:  EdgeInsets.only(left:ScreenUtil().setSp(30)),
              child: Text('${quizCollectionsCount} quiz collections'),
            ),
            Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(750)),
                child: RaisedButton(
                  color: Colors.blueAccent,
                  onPressed: () {

                    Navigator.of(context).pushNamed('/explore-my-drafts');
                  },
                  child: Text(
                    'Explore',
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
