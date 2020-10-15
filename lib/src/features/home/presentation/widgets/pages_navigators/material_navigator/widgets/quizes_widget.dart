import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_player/quiz_player_state_provider.dart';
import 'package:provider/provider.dart';


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
