import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../add_comment_widget/add_comment_bottom_sheet_widget.dart';
import '../single_comment_widget.dart';
import '../state_providers/comment_state_provider.dart';
import 'widgets/header.dart';

class ReplyDisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);

    return Selector<CommentStateProvider, List<dynamic>>(
      selector: (context, stateProvider) => [stateProvider.repliesRelevantCommentPos, stateProvider.insideRepliesPage],
      builder: (context, dependencies, _) => !dependencies[1]
          ? Container()
          : Scaffold(
              body: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setSp(30),
                  horizontal: ScreenUtil().setSp(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RepliesDisplayPageHeader(),
                    CommentWidget(
                      commentPos: dependencies[0],
                      withinReply: true,
                      mainComment: true,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(60)),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(80)),
                        child: Selector<CommentStateProvider, int>(
                          selector: (context, stateProvider) =>
                              stateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies.length,
                          builder: (context, repliesCount, child) => ListView.builder(
                              itemCount: repliesCount,
                              itemBuilder: (context, pos) => CommentWidget(
                                    commentPos: commentStateProvider.repliesRelevantCommentPos,
                                    withinReply: true,
                                    replyPos: pos,
                                  )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              bottomSheet: BottomSheetWidget(),
            ),
    );
  }
}
