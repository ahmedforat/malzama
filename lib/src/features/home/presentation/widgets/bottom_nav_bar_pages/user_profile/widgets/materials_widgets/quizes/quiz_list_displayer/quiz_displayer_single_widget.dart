import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_list_displayer/quiz_displayer_state_provider.dart';
import 'package:provider/provider.dart';

class QuizDisplayerSingleWidget extends StatelessWidget {
  final int pos;

  QuizDisplayerSingleWidget({@required this.pos});

  @override
  Widget build(BuildContext context) {
    QuizDisplayerStateProvider displayerStateProvider = Provider.of<QuizDisplayerStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    final mes = 'for the fifith stage in the presenceo of askjdkj safjasfj';
    return Card(
      margin: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
        height: ScreenUtil().setHeight(700),
        width: ScreenUtil().setWidth(500),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setSp(30),
                        left: ScreenUtil().setSp(30),
                      ),
                      child: Text(
                        'Kadim Al Saher ... Ana Wa Leila - Video Clip | كاظم الساهر ... انا وليلى - فيديو كليب'??displayerStateProvider.quizCollections[pos].credentials.title +'$mes $mes $mes',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setSp(10),
                        left: ScreenUtil().setSp(30),
                      ),
                      child: Text(
                        '(' + displayerStateProvider.quizCollections[pos].questionsCount.toString() + ' questions)',
                        style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setSp(40),
                        left: ScreenUtil().setSp(30),
                      ),
                      child: Text(
                        displayerStateProvider.quizCollections[pos].credentials.description + '$mes $mes',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setSp(60),
                        left: ScreenUtil().setSp(30),
                      ),
                      child: Text(
                        displayerStateProvider.quizCollections[pos].author.firstName +
                            ' ' +
                            displayerStateProvider.quizCollections[pos].author.lastName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setSp(5),
                        left: ScreenUtil().setSp(30),
                      ),
                      child: Text(
                        displayerStateProvider.quizCollections[pos].credentials.college +
                            ' ' +
                            displayerStateProvider.quizCollections[pos].credentials.university,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(ScreenUtil().setSp(20)),
              //color: Colors.blueAccent,
              width: ScreenUtil().setWidth(250),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setSp(15),
                    ),
                    child: Text(displayerStateProvider.quizCollections[pos].postDate.substring(0, 10).toString()),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Stage ' + displayerStateProvider.quizCollections[pos].credentials.stage),
                      if (displayerStateProvider.quizCollections[pos].credentials.semester != 'unknown')
                        SizedBox(height: ScreenUtil().setHeight(20),),
                      if (displayerStateProvider.quizCollections[pos].credentials.semester != 'unknown')
                        Text('Semester ' + displayerStateProvider.quizCollections[pos].credentials.semester)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
