import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/add_comment_widget/add_comment_bottom_sheet_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/replies/widgets/header.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/single_comment_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/state_providers/comment_state_provider.dart';
import 'package:provider/provider.dart';

class ReplyDisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context,listen: false);
    return Selector<CommentStateProvider, int>(
      selector: (context, stateProvider) => stateProvider.repliesRelevantCommentPos,
      builder: (context, pos, _) => Scaffold(
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
              CommentWidget(commentPos: pos, withinReply: true,mainComment: true,),
              SizedBox(height: ScreenUtil().setHeight(60)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setSp(80)),
                  child: Selector<CommentStateProvider,int>(
                    selector: (context,stateProvider) => stateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies.length,
                    builder:(context,repliesCount,child) => ListView.builder(
                      itemCount: repliesCount,
                      itemBuilder: (context, pos) => CommentWidget(
                        commentPos: commentStateProvider.repliesRelevantCommentPos,
                        withinReply: true,
                        replyPos: pos,
                      )
                    ),
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
