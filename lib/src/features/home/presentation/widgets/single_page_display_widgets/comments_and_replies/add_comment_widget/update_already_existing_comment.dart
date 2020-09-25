import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/comment_related_models/comment_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/functions/replies_functions.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/api/contract_response.dart';
import '../../../../../../../core/platform/local_database/models/base_model.dart';
import '../../../pages_navigators/home_page_navigator/home_page_navigator/state/state_getter.dart';
import '../../../pages_navigators/videos_navigator/state/state_getter.dart';
import '../functions/comments_functions.dart';
import '../state_providers/add_comment_widget_state_provider.dart';
import '../state_providers/comment_state_provider.dart';
import 'add_comment_text_field.dart';

class UpdateAlreadyExistedCommentWidget extends StatelessWidget {
  void onEditingAnExistingComment(
    @required BuildContext context,
  ) async {
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);

    final BaseStateProvider baseStateProvider = commentStateProvider.isVideo
        ? getVideosPageStateProvider(context: context, listen: false)
        : getHomePageStateProvider(context: context, listen: false);

    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);

    if (commentStateProvider.insideRepliesPage && commentStateProvider.replyIdToBeUpdated != null) {
      commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies
          .firstWhere((reply) => reply.id == commentStateProvider.replyIdToBeUpdated)
          .commentStatus = CommentStatus.UPDATING;
    } else {
      commentStateProvider.comments.firstWhere((comment) => comment.id == commentStateProvider.commentIdToBeUpdated).commentStatus =
          CommentStatus.UPDATING;
    }

    commentStateProvider.setState();
    final String content = addOrEditCommentWidgetStateProvider.textController.text;

    ContractResponse response;
    if (commentStateProvider.replyIdToBeUpdated != null) {
      response = await RepliesFunctions.editReply(
        material: baseStateProvider.materialItems[commentStateProvider.currentMaterialPos],
        commentId: commentStateProvider.commentIdToBeUpdated,
        content: content,
        replyId: commentStateProvider.replyIdToBeUpdated,
      );
    } else {
      response = await CommentFunctions.editComment(
        commentId: commentStateProvider.commentIdToBeUpdated,
        commentContent: content,
        materialInfo: baseStateProvider.materialItems[commentStateProvider.currentMaterialPos],
      );
    }

    if (response is Success) {
      addOrEditCommentWidgetStateProvider.resetWidget();

      final Map<String, dynamic> data = json.decode(response.message);

      if(commentStateProvider.replyIdToBeUpdated != null){
        commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies.firstWhere((reply) => reply.id ==
            commentStateProvider.replyIdToBeUpdated)..commentStatus =CommentStatus.SENT
        ..content = content;
        commentStateProvider.setState();
      }else{
        commentStateProvider.editComment(data['updatedComment']['content']);
      }

    }
    String message = response is Success ? 'Comment Edited' : 'failed to edit comment';
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Container(
              height: ScreenUtil().setHeight(350),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(35),
                vertical: ScreenUtil().setSp(10),
              ),
              child: AddCommentTextField(),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(130),
            padding: EdgeInsets.only(right: ScreenUtil().setSp(40)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(25),
                      ),
                    ),
                    child: Text(
                      'cancel',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    addOrEditCommentWidgetStateProvider.resetWidget();
                  },
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(50),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(25)),
                    ),
                    child: Text(
                      'update',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    onEditingAnExistingComment(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
