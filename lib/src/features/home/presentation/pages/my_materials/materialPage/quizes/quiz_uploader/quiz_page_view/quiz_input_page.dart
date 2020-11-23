import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../state_provider/quiz_uploading_state_provider.dart';
import '../../quiz_entity.dart';


class QuizEditBuilder extends StatefulWidget {
  final int pos;

  QuizEditBuilder({@required this.pos});

  @override
  _QuizEditBuilderState createState() => _QuizEditBuilderState();
}

class _QuizEditBuilderState extends State<QuizEditBuilder> {
  QuizEntity quizEntity;

  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = new GlobalKey<FormState>();
    quizEntity = new QuizEntity();
  }

  @override
  Widget build(BuildContext context) {
    QuizUploadingState uploadingState = Provider.of<QuizUploadingState>(context, listen: false);

    ScreenUtil.init(context);
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(30))
        ),
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: FlatButton(
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          uploadingState.saveCurrentQuizEntity(widget.pos, quizEntity);
                          uploadingState.updateQuizViewMode(widget.pos);
                        }
                      },
                    ),
                  ),
                  Text(
                    '${widget.pos + 1}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(55)),
                  ),
                  Flexible(
                    child: FlatButton(
                      child: Icon(Icons.cancel),
                      onPressed: () {
                        uploadingState.removeQuizItemAt(widget.pos);
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
                          constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(350)),
                          child: TextFormField(
                            initialValue: uploadingState.quizList[widget.pos].question,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Question text',
                              border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              quizEntity.question = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(20)),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(250)),
                          child: TextFormField(
                            initialValue:
                                uploadingState.quizList[widget.pos].options.isEmpty ? null : uploadingState.quizList[widget.pos].options[0],
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Option A',
                              border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              quizEntity.options[0] = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(20)),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(250)),
                          child: TextFormField(
                            initialValue:
                                uploadingState.quizList[widget.pos].options.isEmpty ? '' : uploadingState.quizList[widget.pos].options[1],
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Option B',
                              border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              quizEntity.options[1] = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(20)),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(250)),
                          child: TextFormField(
                            initialValue:
                                uploadingState.quizList[widget.pos].options.isEmpty ? '' : uploadingState.quizList[widget.pos].options[2],
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Option C',
                              border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              quizEntity.options[2] = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(20)),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(250)),
                          child: TextFormField(
                            initialValue:
                                uploadingState.quizList[widget.pos].options.isEmpty ? '' : uploadingState.quizList[widget.pos].options[3],
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Option D',
                              border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              quizEntity.options[3] = val;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
