import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/Navigator/routes_names.dart';
import '../../../../../../../../core/general_widgets/helper_utils/edit_or_delete_options_widget.dart';
import '../../../../../state_provider/user_info_provider.dart';
import 'quiz_displayer_state_provider.dart';

class QuizDisplayerSingleWidget extends StatelessWidget {
  final int pos;

  QuizDisplayerSingleWidget({@required this.pos});

  @override
  Widget build(BuildContext context) {
    QuizDisplayerStateProvider displayerStateProvider = Provider.of<QuizDisplayerStateProvider>(context, listen: false);
    UserInfoStateProvider userInfoState = Provider.of<UserInfoStateProvider>(context, listen: false);
    final bool isMyQuiz = userInfoState.userData.id == displayerStateProvider.quizCollections[pos].author.id;
    ScreenUtil.init(context);
    final mes = 'for the fifith stage in the presenceo of askjdkj safjasfj';

    Future<void> _onOptionsCLick() async {
      userInfoState.setBottomNavBarVisibilityTo(false);
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => EditOrDeleteOptionWidget(
                onEdit: () async{
                  Navigator.of(context).pop();
                  await Future.delayed(Duration(milliseconds: 230));
                  Navigator.of(context).pushNamed(RouteNames.EDIT_UPLOADED_QUIZ,arguments: displayerStateProvider.quizCollections[pos]);
                },
                onDelete: () async{
                  print('Deleting');
                  displayerStateProvider.deleteQuizCollectionAt(context,pos);
                },
              )).whenComplete(
        ()async{
          await Future.delayed(Duration(milliseconds: 200));
          userInfoState.setBottomNavBarVisibilityTo(true);
        },
      );
    }

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setSp(30),
                          left: ScreenUtil().setSp(30),
                        ),
                        child: Text(
                          displayerStateProvider.quizCollections[pos].credentials.title ,
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
                    ],
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
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                )
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMyQuiz && pos % 2 ==0)
                        FlatButton(
                          onPressed:_onOptionsCLick,
                          child: Icon(Icons.edit),
                        ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setSp(15),
                        ),
                        child: Text(displayerStateProvider.quizCollections[pos].postDate.substring(0, 10).toString()),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Stage ' + displayerStateProvider.quizCollections[pos].credentials.stage),
                      if (displayerStateProvider.quizCollections[pos].credentials.semester != 'unknown')
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
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
