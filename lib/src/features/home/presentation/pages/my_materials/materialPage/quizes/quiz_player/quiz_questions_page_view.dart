import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../quiz_list_displayer/quiz_list_displayer.dart';
import 'loading_single_question_widget.dart';
import 'quiz_player_state_provider.dart';
import 'single_quiz_question_widget.dart';

class QuizPlayerQuestionsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizPlayerStateProvider playerStateProvider = Provider.of<QuizPlayerStateProvider>(context, listen: false);
    print(playerStateProvider.quizItems.length);
    return Selector<QuizPlayerStateProvider, List<dynamic>>(
      selector: (context, stateProvider) => [
        stateProvider.isFetching,
        stateProvider.hasFetchedTheInitialQuestions,
        stateProvider.isFetchingMore,
        stateProvider.hasFetchedTheAdditionalQuestions,
        stateProvider.quizItems.length
      ],
      builder: (context, fetchingState, _) {
        print('building page view of quiz questions');
        print(fetchingState);
        return Container(
          //height: ScreenUtil().setHeight(1300),
          constraints: BoxConstraints(
            maxHeight: ScreenUtil().setHeight(1500),
            minHeight: ScreenUtil().setHeight(1200),
          ),
          child: fetchingState[0]
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : !fetchingState[1]
                  ? Center(
                      child: FailedToLoadWidget(
                      message: playerStateProvider.failureMessage,
                      onReload: playerStateProvider.fetchQuestions,
                    ))
                  : PageView.builder(
                      physics: BouncingScrollPhysics(),
                      onPageChanged: playerStateProvider.onPageChange,
                      controller: playerStateProvider.pageController,
                      itemCount: playerStateProvider.quizItems.length,
                      itemBuilder: (context, pos) {
                        final bool isFetchingMore = fetchingState[2];
                        final bool hasFetchedMore = fetchingState[3];
                        // previous condition
                        bool previousCondition = pos == playerStateProvider.quizItems.length - 1 && !playerStateProvider.fromLocal&& (isFetchingMore ||
                            !hasFetchedMore);
                        if (playerStateProvider.quizItems[pos].isEmpty) {
                          return LoadingSingleQuestionWidget();
                        } else {
                          return SingleQuizQuestionWidget(pos: pos);
                        }
                      }),
        );
      },
    );
  }
}
