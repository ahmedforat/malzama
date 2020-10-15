import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_page_view/quiz_input_page.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_page_view/quiz_review_page.dart';
import 'package:provider/provider.dart';



class QuizQuestionsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizUploadingState uploadingState = Provider.of<QuizUploadingState>(context,listen: false);
    return Container(
      color: Colors.grey,
      height: ScreenUtil().setHeight(1600),
      child: SizedBox.expand(
        child: PageView.builder(
            physics: BouncingScrollPhysics(),
            controller: uploadingState.pageController,
            //scrollDirection: Axis.horizontal,
            itemCount: uploadingState.quizList.length,
            onPageChanged: (pos) {
              uploadingState.updateCurrentPageIndex(pos);
            },
            itemBuilder: (context, pos) {
              return Selector<QuizUploadingState, bool>(
                selector: (context, stateProvider) => stateProvider.quizList[pos].inReviewMode,
                builder: (context, inReviewMode, __) => AnimatedSwitcher(
                  child: inReviewMode
                      ? animatedQuizReviewBuilder(pos, uploadingState)
                      : animatedQuizEditBuilder(pos, uploadingState),
                  duration: Duration(milliseconds: 350),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.bounceInOut,
                ),
              );
            }),
      ),
    );
  }

  animatedQuizEditBuilder(int pos, QuizUploadingState uploadingState) {
    return Center(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(25)),
          color: Colors.grey[200],
        ),
        duration: Duration(milliseconds: 500),
        child: QuizEditBuilder(
          pos: pos,
        ),
        width: ScreenUtil().setWidth(
          pos == uploadingState.currentPageIndex ? 1200 : 400,
        ),
        height: ScreenUtil().setHeight(
          pos == uploadingState.currentPageIndex ? 1500 : 400,
        ),
      ),
    );
  }

  animatedQuizReviewBuilder(int pos, QuizUploadingState uploadingState) {
    return Center(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(25)),
        ),
        duration: Duration(milliseconds: 500),
        child: QuizReviewBuilder(pos: pos),
        width: ScreenUtil().setWidth(
          pos == uploadingState.currentPageIndex ? 1200 : 400,
        ),
        height: ScreenUtil().setHeight(
          pos == uploadingState.currentPageIndex ? 1500 : 400,
        ),

        //color: pos % 2 == 0 ? Colors.blueAccent : Colors.redAccent,
      ),
    );
  }

}
