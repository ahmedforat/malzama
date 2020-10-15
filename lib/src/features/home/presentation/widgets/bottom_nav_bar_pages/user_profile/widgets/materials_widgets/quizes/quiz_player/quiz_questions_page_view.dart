import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_player/quiz_player_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_player/single_quiz_question_widget.dart';
import 'package:provider/provider.dart';

class QuizPlayerQuestionsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizPlayerStateProvider playerStateProvider = Provider.of<QuizPlayerStateProvider>(context, listen: false);
    print(playerStateProvider.quizItems.length);
    return Selector<QuizPlayerStateProvider, bool>(
      selector: (context, stateProvider) => stateProvider.isFetching,
      builder: (context, isFetching, _) => isFetching
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(

              //height: ScreenUtil().setHeight(1300),
        constraints: BoxConstraints(
          maxHeight:ScreenUtil().setHeight(1500),
          minHeight: ScreenUtil().setHeight(1200)
        ),
              child: PageView.builder(
                controller: playerStateProvider.pageController,
                itemCount: playerStateProvider.quizItems.length,
                itemBuilder: (context, pos) => SingleQuizQuestionWidget(pos: pos),
              ),
            ),
    );
  }
}
