import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_drafts_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_draft_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../state_provider/profile_page_state_provider.dart';

class DraftsDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('================================ building DraftsDisplayer');
    ScreenUtil.init(context);
    QuizDraftState draftState = Provider.of<QuizDraftState>(context, listen: false);
    return Selector<QuizDraftState, bool>(
      selector: (context, stateProvider) => stateProvider.isFetchingDrafts,
      builder: (context, isFetching, child) => isFetching
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Text('click me'),
                    onPressed: () {
                      print(draftState.quizDrafts.first.quizItems.length);
                    },
                  ),
                ],
              ),
              body: Selector<QuizDraftState, int>(
                selector: (context, stateProvider) => stateProvider.quizDrafts.length,
                builder: (context, quizDraftsCount, _) => Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                  child: quizDraftsCount == 0
                      ? Center(
                          child: Text('No Drafts'),
                        )
                      : ListView.builder(
                          itemCount: draftState.quizDrafts.length,
                          itemBuilder: (context, pos) {
                            return InkWell(
                              onTap: () {
                                QuizDraftEntity args = draftState.quizDrafts[pos].clone;
                                Navigator.of(context)
                                    .pushNamed(RouteNames.EDIT_QUIZ_DRAFT, arguments: args)
                                    .then((value) => draftState.refresh());
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
                                          onPressed: () async {
                                            await draftState.deleteQuizDraft(draftState.quizDrafts[pos].storeIndex, pos);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
                                        child: Text(
                                          draftState.quizDrafts[pos].credentials.title,
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
                                          draftState.quizDrafts[pos].credentials.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(50),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Selector<QuizDraftState, int>(
                                              selector: (context, stateProvider) => stateProvider.quizDrafts[pos].quizItems.length,
                                              builder: (context, darftsCount, _) => Text(
                                                darftsCount.toString() + ' questions',
                                                style: TextStyle(color: Colors.grey[500]),
                                              ),
                                            ),
                                            Text(
                                              draftState.quizDrafts[pos].credentials.topic,
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
              ),
              // floatingActionButton: Selector<QuizDraftState,int>(
              //   selector: (context,stateProvider) => stateProvider.quizDrafts[0].quizItems.length,
              //   builder:(context,count,_){
              //     print('============== changing occured');
              //     print('==============$count');
              //     return FloatingActionButton(
              //       onPressed: () {
              //         print((draftState.quizDrafts[0].quizItems).map((item) => item.toJSON()).toList());
              //       },
              //     );
              //   },
              // ),
            ),
    );
  }
}
