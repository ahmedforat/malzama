import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../../state_provider/user_info_provider.dart';


class Quizes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ListTile(
      title: Text(
        'Quizes',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(60)
        ),
      ),
      subtitle: Selector<UserInfoStateProvider, int>(
        selector: (context, stateProvider) => stateProvider.quizCollectionsCount,
        builder: (context, count, _) {
          final String text = count == 0 ? 'No quizes yet' : '$count quizes';
          return Text(text);
        },
      ),
      trailing: RaisedButton(
        color: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.VIEW_QUIZ_DISPLAYER);
        },
        child: Text(
          'Explore',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );;
  }
}
