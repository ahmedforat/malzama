import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'quiz_player_state_provider.dart';
import 'quiz_questions_page_view.dart';

class QuizPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizPlayerStateProvider playerStateProvider = Provider.of<QuizPlayerStateProvider>(context, listen: false);

    Widget _credentialWidget({String label, String value}) => ListTile(
          title: Text(label),
          subtitle: Text(value),
        );

    return Scaffold(
      key: playerStateProvider.scaffoldKey,
      body: WillPopScope(
        onWillPop: (){
          print('on will pop form inside quiz player');
          return Future.value(false);

        },
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            controller: playerStateProvider.scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _credentialWidget(
                  label: 'title',
                  value: playerStateProvider.credentials.title,
                ),
                _credentialWidget(
                  label: 'description',
                  value: playerStateProvider.credentials.description,
                ),
                _credentialWidget(
                  label: 'topic',
                  value: playerStateProvider.credentials.topic,
                ),
                _credentialWidget(
                  label: 'stage',
                  value: playerStateProvider.credentials.stage.toString(),
                ),
                if (playerStateProvider.credentials.semester != 'unknown')
                  _credentialWidget(
                    label: 'semester',
                    value: playerStateProvider.credentials.semester.toString(),
                  ),
                Selector<QuizPlayerStateProvider,int>(
                  selector: (context,stateProvider) => stateProvider.quizCollection.questionsCount,
                  builder:(context,count,_) =>  _credentialWidget(
                    label: 'questions count',
                    value: '$count',
                  ),
                ),
                Selector<QuizPlayerStateProvider, bool>(
                  selector: (context, stateProvider) => stateProvider.hasStartedTheQuiz,
                  builder: (context, hasStarted, _) => RaisedButton(
                    onPressed: () {
                      playerStateProvider.headToQuizOffset();
                    },
                    child: Text(hasStarted ? 'Go Back To Quiz' : 'Get Started'),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(550)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<QuizPlayerStateProvider,int>(
                          selector: (context,stateProvider) => stateProvider.quizCollection.questionsCount,
                          builder: (context,count,_) => RichText(
                            text: TextSpan(
                                text: 'Total questions:',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: ' $count',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ]),
                          ),
                        ),
                        Row(
                          children: [
                            Selector<QuizPlayerStateProvider, int>(
                              selector: (context, stateProvider) => stateProvider.correctProposedAnswers,
                              builder: (context, correctAnswers, _) => RichText(
                                text: TextSpan(
                                    text: 'Correct:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' $correctAnswers',
                                        style: TextStyle(color: Colors.green),
                                      )
                                    ]),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(30),
                            ),
                            Selector<QuizPlayerStateProvider, int>(
                              selector: (context, stateProvider) => stateProvider.inCorrectProposedAnswers,
                              builder: (context, inCorrectAnswers, _) => RichText(
                                text: TextSpan(
                                    text: 'inCorrect:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' $inCorrectAnswers',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    RaisedButton(
                      onPressed: playerStateProvider.reset,
                      child: Text('Reset'),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(60),),
                QuizPlayerQuestionsPageView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
