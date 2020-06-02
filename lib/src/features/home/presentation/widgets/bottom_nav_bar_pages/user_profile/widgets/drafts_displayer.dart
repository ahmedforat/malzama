import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_drafts_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../state_provider/my_materials_state_provider.dart';
import '../../../../state_provider/profile_page_state_provider.dart';

class DraftsDisplayer extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _fetchDrafts(QuizDraftState draftState) async {
    print('waiting for drafts to be loaded');
    await draftState.loadQuizDrafts();
    print('here are the drafts results');
    print(draftState.quizDrafts);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizDraftState draftState = Provider.of<QuizDraftState>(context, listen: false);
    return FutureBuilder(
      future: _fetchDrafts(draftState),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Selector<QuizDraftState,List>(
          selector: (context,stateProvider) => [stateProvider.quizDrafts.length,stateProvider.quizDrafts.first],
          builder:(context,_,__) =>  Scaffold(
              body: draftState.quizDrafts.isEmpty
                  ? Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: <Widget>[
                          Text('Loading drafts ... '),
                          SizedBox(
                            height: ScreenUtil().setHeight(50),
                          ),
                          CircularProgressIndicator()
                        ],
                      ))
                  : Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                      child: ListView.builder(
                        itemCount: draftState.quizDrafts.length,
                        itemBuilder: (context, pos){
                          if(draftState.quizDrafts.first.containsKey('empty')){
                            return Center(child:Text('There are no saved drafts!'));
                          }
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed('/edit-quiz-draft',arguments: draftState.quizDrafts[pos]);
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                        child: Icon(Icons.delete),
                                        onPressed: ()async{
                                          print(draftState.quizDrafts[pos]['index']);
                                          print(draftState.quizDrafts[pos]['index'].runtimeType);
                                          await draftState.deleteQuizDraft(draftState.quizDrafts[pos]['index'],pos);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.all(ScreenUtil().setSp(30)),
                                      child: Text(
                                        draftState.quizDrafts[pos]['credentials']['title'],
                                        style: TextStyle(fontSize: ScreenUtil().setSp(45), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(50),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(ScreenUtil().setSp(40)),
                                      constraints: BoxConstraints(
                                        maxWidth: double.infinity,
                                        maxHeight: ScreenUtil().setHeight(250),
                                      ),
                                      child: Text(
                                        draftState.quizDrafts[pos]['credentials']['description'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(50),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            draftState.quizDrafts[pos]['quizItems'].length.toString()+' questions',
                                            style: TextStyle(color: Colors.grey[500]),
                                          ),
                                          Text(
                                            draftState.quizDrafts[pos]['credentials']['topic'],
                                            style: TextStyle(color: Colors.grey[500]),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              print((draftState.quizDrafts[0]['quizItems'] as List<QuizEntity>).map((item) => item.toJSON()).toList());
            },
          ),),
        );
      },
    );
  }
}
