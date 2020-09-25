import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../state_provider/profile_page_state_provider.dart';

class DraftIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Selector<ProfilePageState, int>(
      selector: (context, stateProvider) => stateProvider.quizDraftsCount,
      builder: (context, quizCollectionsCount, __) => Container(
        //color: Colors.red,
        child: ListTile(
          title: Text(
            'My Drafts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60)),
          ),
          subtitle: Text(
            '$quizCollectionsCount quizes',
            style: TextStyle( fontSize: ScreenUtil().setSp(40)),
          ),
          trailing: RaisedButton(
            child: Text('Explore'),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
