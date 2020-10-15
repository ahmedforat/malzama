import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/models/material_author.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/comment_related_models/comment_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/comment_related_models/comment_reply_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/functions/comments_functions.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/functions/replies_functions.dart';
import 'package:provider/provider.dart';

import '../../../pages_navigators/home_page_navigator/home_page_navigator/state/state_getter.dart';
import '../../../pages_navigators/videos_navigator/state/state_getter.dart';
import '../state_providers/add_comment_widget_state_provider.dart';
import '../state_providers/comment_state_provider.dart';
import 'add_comment_text_field.dart';

class AddNewCommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      constraints: BoxConstraints(
        minHeight: ScreenUtil().setHeight(10),
        maxHeight: ScreenUtil().setHeight(350),
      ),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(
          ScreenUtil().setSp(50),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Container(
              //color: Colors.redAccent,
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(35),
                vertical: ScreenUtil().setSp(10),
              ),
              child: AddCommentTextField(),
            ),
          ),
          Selector<AddOrEditCommentWidgetStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.isSendButtonVisible,
            builder: (context, isSendButtonVisible, _) =>
            isSendButtonVisible
                ? IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _onPressed(context),
            )
                : Container(
              height: 0,
              width: 0,
            ),
          )
        ],
      ),
    );
    ;
  }
}

void _onPressed(BuildContext context) {
  CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);

  if (commentStateProvider.insideRepliesPage) {
    onUploadingNewReply(context);
  } else {
    onUploadingNewComment(context);
  }
}

void onUploadingNewReply(BuildContext context) async {
  AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
  Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);

  CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);

  final replyText = addOrEditCommentWidgetStateProvider.textController.text;
  final materialState = commentStateProvider.isVideo
      ? getVideosPageStateProvider(context: context, listen: false).materialItems[commentStateProvider.currentMaterialPos]
      : getHomePageStateProvider(context: context, listen: false).materialItems[commentStateProvider.currentMaterialPos];

  MaterialAuthor commentAuthor = commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].author;
  final String commentId = commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].id;
  addOrEditCommentWidgetStateProvider.resetWidget();

  CommentReply newReply = new CommentReply(author: MaterialAuthor.fromJSON(await HelperFucntions.getAuthorPopulatedData()), content:
  replyText, postDate:
  '', id:
  '',)..commentStatus = CommentStatus.IN_PROGRESS
  ..breakable = shouldBeBreaked(replyText)
  ..breaked = shouldBeBreaked(replyText);

  commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies.add(newReply);
  commentStateProvider.setState();

  ContractResponse contractResponse =
  await RepliesFunctions.uploadNewReply(content: replyText, author: commentAuthor, commentId: commentId, material: materialState);

  if (contractResponse is Success) {
    var responseBody = json.decode(contractResponse.message);
    print('====================================');
    print(responseBody);
    print('====================================');
    commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].hasReplies = true;
    commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies.firstWhere((reply) => reply.content == replyText)
    ..postDate = DateTime.fromMillisecondsSinceEpoch(responseBody['newReply']['post_date']).toIso8601String()
    ..id = responseBody['newReply']['_id']
    ..commentStatus = CommentStatus.SENT;
    commentStateProvider.setState();
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(content:Text(contractResponse.message)));
  }
}

void onUploadingNewComment(BuildContext context) async {
  AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
  Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
  CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);

  final materialState = commentStateProvider.isVideo
      ? getVideosPageStateProvider(context: context, listen: false).materialItems[commentStateProvider.currentMaterialPos]
      : getHomePageStateProvider(context: context, listen: false).materialItems[commentStateProvider.currentMaterialPos];
  //_bottomSheetController.close();

//  final String commnetText = controller.text;
//  controller.clear();

  // upload new comment

  final String content = addOrEditCommentWidgetStateProvider.textController.text;

  addOrEditCommentWidgetStateProvider.resetWidget();

  String newCommentID = await commentStateProvider.uplaodNewComment(
    materialInfo: materialState,
    content: content,
  );

  if (newCommentID != null) {
    var currentMaterialState = commentStateProvider.isVideo
        ? getVideosPageStateProvider(context: context, listen: false)
        : getHomePageStateProvider(context: context, listen: false);

    // save the _id of the new comment to the specific material state provider
    currentMaterialState.materialItems[commentStateProvider.currentMaterialPos].comments.add(newCommentID);
    currentMaterialState.setState();
  }

  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(newCommentID == null ? 'failed to add a comment' : 'new Comment added'),
    ),
  );
}
