import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../state_provider/quiz_uploading_state_provider.dart';
import '../../quiz_entity.dart';


class QuizReviewBuilder extends StatelessWidget {
  final int pos;

  QuizReviewBuilder({@required this.pos});

  @override
  Widget build(BuildContext context) {
    QuizUploadingState uploadingState = Provider.of<QuizUploadingState>(context, listen: false);

    ScreenUtil.init(context);
    return Selector<QuizUploadingState, QuizEntity>(
      selector: (context, stateProvider) => stateProvider.quizList[pos],
      builder: (context, _, __) => Container(
        
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(30))
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: FlatButton(
                      child: Text('Edit'),
                      onPressed: () {
                        uploadingState.updateQuizViewMode(pos);
                      },
                    ),
                  ),
                  Text(
                    '${pos + 1}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(55)),
                  ),
                  Flexible(
                    child: FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: () {
                        print('deleting quiz item');
                        uploadingState.removeQuizItemAt(pos);
                      },

                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                        child: Container(
                          constraints: BoxConstraints(),
                          child: ListTile(
                            title: Text(
                              uploadingState.quizList[pos].question,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
                      ),
                      Selector<QuizUploadingState, int>(
                        selector: (context, stateProvider) => stateProvider.quizList[pos].answers.length,
                        builder: (context, _, __) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                          child: Container(
                            constraints: BoxConstraints(),
                            child: ListTile(
                              leading: Checkbox(
                                  value: uploadingState.quizList[pos].answers.contains(0),
                                  onChanged: (val) {
                                    if (val) {
                                      uploadingState.quizList[pos].answers.add(0);
                                    } else {
                                      uploadingState.quizList[pos].answers.remove(0);
                                    }
                                    uploadingState.setState();
                                  }),
                              title: Text(
                                uploadingState.quizList[pos].options[0],
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Selector<QuizUploadingState, int>(
                        selector: (context, stateProvider) => stateProvider.quizList[pos].answers.length,
                        builder: (context, _, __) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                          child: Container(
                            constraints: BoxConstraints(),
                            child: ListTile(
                              leading: Checkbox(
                                  value: uploadingState.quizList[pos].answers.contains(1),
                                  onChanged: (val) {
                                    if (val) {
                                      uploadingState.quizList[pos].answers.add(1);
                                    } else {
                                      uploadingState.quizList[pos].answers.remove(1);
                                    }
                                    uploadingState.setState();
                                  }),
                              title: Text(
                                uploadingState.quizList[pos].options[1],
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Selector<QuizUploadingState, int>(
                        selector: (context, stateProvider) => stateProvider.quizList[pos].answers.length,
                        builder: (context, _, __) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                          child: Container(
                            constraints: BoxConstraints(),
                            child: ListTile(
                              leading: Checkbox(
                                  value: uploadingState.quizList[pos].answers.contains(2),
                                  onChanged: (val) {
                                    if (val) {
                                      uploadingState.quizList[pos].answers.add(2);
                                    } else {
                                      uploadingState.quizList[pos].answers.remove(2);
                                    }
                                    uploadingState.setState();
                                  }),
                              title: Text(
                                uploadingState.quizList[pos].options[2],
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Selector<QuizUploadingState, int>(
                        selector: (context, stateProvider) => stateProvider.quizList[pos].answers.length,
                        builder: (context, _, __) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                          child: Container(
                            constraints: BoxConstraints(),
                            child: ListTile(
                              leading: Checkbox(
                                  value: uploadingState.quizList[pos].answers.contains(3),
                                  onChanged: (val) {
                                    if (val) {
                                      uploadingState.quizList[pos].answers.add(3);
                                    } else {
                                      uploadingState.quizList[pos].answers.remove(3);
                                    }
                                    uploadingState.setState();
                                  }),
                              title: Text(
                                uploadingState.quizList[pos].options[3],
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(70),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(20)),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(250)),
                          child: TextFormField(
                            initialValue: uploadingState.quizList[pos].explain,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Explanation (optional)',
                              border: OutlineInputBorder( borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                uploadingState.quizList[pos].explain = val;
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
