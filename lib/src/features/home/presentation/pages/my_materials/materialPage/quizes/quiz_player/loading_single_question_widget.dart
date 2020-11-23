import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../quiz_list_displayer/quiz_list_displayer.dart';
import 'quiz_player_state_provider.dart';

class LoadingSingleQuestionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizPlayerStateProvider playerStateProvider = Provider.of<QuizPlayerStateProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(100),
              //color: Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(100),
                      ),
                      Text(
                        'question ${playerStateProvider.quizItems.length}',
                        style: TextStyle(fontSize: ScreenUtil().setSp(50), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(50),
                  ),
                  MaterialButton(
                    elevation: 2.0,
                    color: Colors.green,
                    onPressed: null,
                    child: Text('Check Your Answer(s)'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(250),
            ),
            Selector<QuizPlayerStateProvider,bool>(
              selector: (context,stateProvider) => stateProvider.isFetchingMore,
              builder: (context,isFetchingMore,_){
                if(isFetchingMore){
                  return _LoadingWidgets();
                }
                return Center(
                  child: FailedToLoadWidget(
                    onReload: playerStateProvider.fetchQuestions,
                    message: playerStateProvider.failureMessage??'',
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _LoadingWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Loading more questions'),
        SizedBox(
          height: ScreenUtil().setHeight(250),
        ),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
