import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/main.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/comment_status_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/functions/replies_functions.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/replies/reply_display_page.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/general_models/customDate.dart';
import '../../../../../../core/platform/local_database/models/base_model.dart';
import '../../../pages/home_page.dart';
import '../../../state_provider/user_info_provider.dart';
import '../../pages_navigators/home_page_navigator/home_page_navigator/state/state_getter.dart';
import '../../pages_navigators/videos_navigator/state/state_getter.dart';
import '../college_material_holding_widget.dart';
import 'comment_modal_bottom_sheet.dart';
import 'state_providers/add_comment_widget_state_provider.dart';
import 'state_providers/comment_state_provider.dart';

class CommentWidget extends StatelessWidget {
  final int commentPos;
  bool withinReply;
  final int replyPos;
  final bool mainComment;

  CommentWidget({@required this.commentPos, this.withinReply = false, int replyPos, bool mainComment})
      : this.replyPos = replyPos ?? null,
        this.mainComment = mainComment ?? false;

  /// this method is called whenever the user press the delete option in the modal sheet of the comment editing options
  _commentOnDelete(BuildContext context, Map<String, String> res, BaseStateProvider baseStateProvider) async {
    print('deleting ......................');

    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    await Future.delayed(Duration(milliseconds: 300));
    addOrEditCommentWidgetStateProvider.removeFocus();
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);
    if (res['value'] != null) {
      if (commentStateProvider.replyIdToBeDeleted != null) {
        commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies
            .removeWhere((reply) => reply.id == commentStateProvider.replyIdToBeDeleted);
        commentStateProvider.setState();
      } else {
        final String currentCommentID = commentStateProvider.comments[commentPos].id;
        baseStateProvider.materialItems[commentStateProvider.currentMaterialPos].comments
          ..removeWhere((comment) => comment == currentCommentID);

        // close the replies display page
        if (mainComment) {
          commentStateProvider.closeRepliesDisplayPage();
        }

        // refresh the page
        baseStateProvider.setState();
        commentStateProvider.removeCommentAt(commentPos);
      }
    }

    final String message =
        res['value'] == null ? 'failed to delete ${commentStateProvider.replyIdToBeUpdated != null ? 'reply' : 'comment'}' : res['value'];
    print(message);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  /// this method is called whenever the user press the edit option in the modal sheet of the comment editing options
  _commentOnEdit(BuildContext context) async {
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);
    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    if (commentStateProvider.insideRepliesPage && !mainComment) {
      addOrEditCommentWidgetStateProvider.textController.text =
          commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies[replyPos].content;
      await Future.delayed(Duration(milliseconds: 150));
      addOrEditCommentWidgetStateProvider.setIsCommentUpdatingTo(true);
      commentStateProvider.replyIdToBeUpdated =
          commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies[replyPos].id;
      commentStateProvider.commentIdToBeUpdated = commentStateProvider.comments[commentStateProvider.repliesRelevantCommentPos].id;
    }else {
      addOrEditCommentWidgetStateProvider.textController.text = commentStateProvider.comments[commentPos].content;
      await Future.delayed(Duration(milliseconds: 150));
      addOrEditCommentWidgetStateProvider.setIsCommentUpdatingTo(true);
      commentStateProvider.commentIdToBeUpdated = commentStateProvider.comments[commentPos].id;
      commentStateProvider.replyIdToBeUpdated = null;
    }
    await Future.delayed(Duration(milliseconds: 150));
    addOrEditCommentWidgetStateProvider.focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);
    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
    final String commentAuthorID = withinReply && !mainComment
        ? commentStateProvider.comments[commentPos].replies[replyPos].author.id
        : commentStateProvider.comments[commentPos].author.id;
    final bool isMyComment = commentAuthorID == userInfoStateProvider.userData['_id'];
    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    return Container(
      //margin: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Selector<CommentStateProvider, String>(
              selector: (context, stateProvider) => withinReply && !mainComment
                  ? stateProvider.comments[commentPos].replies[replyPos].author.profilePictureRef
                  : stateProvider.comments[commentPos].author.profilePictureRef,
              builder: (context, profilePicture, _) => userAvatar(imageUrl: profilePicture),
            ),
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.23),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setSp(20)),
                    topRight: Radius.circular(ScreenUtil().setSp(20)),
                  )),
              child: Selector<CommentStateProvider, List<String>>(
                selector: (context, stateProvider) => withinReply && !mainComment
                    ? [
                        stateProvider.comments[commentPos].replies[replyPos].author.firstName,
                        stateProvider.comments[commentPos].replies[replyPos].author.lastName,
                      ]
                    : [
                        stateProvider.comments[commentPos].author.firstName,
                        stateProvider.comments[commentPos].author.lastName,
                      ],
                builder: (_, userNames, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: isMyComment ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userNames[0] + ' ' + userNames[1],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isMyComment)
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: ScreenUtil().setSp(50),
                            ),
                            onPressed: () async {
                              final BaseStateProvider baseStateProvider = commentStateProvider.isVideo
                                  ? getVideosPageStateProvider(context: context, listen: false)
                                  : getHomePageStateProvider(context: context, listen: false);

                              final UserInfoStateProvider userInfoProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
                              userInfoProvider.setBottomNavBarVisibilityTo(false);
                              final Map<String, String> res = await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: globalScaffoldKey.currentContext,
                                builder: (_) => CommentOptionsBottomSheet(
                                  onEdit: () {
                                    print('Editing');
                                    Navigator.of(context, rootNavigator: true).pop({'from': 'onEdit', 'value': null});
                                  },
                                  onDelete: () async {
                                    final String commentId = commentStateProvider.comments[commentPos].id;

                                    final BaseUploadingModel materialInfo =
                                        baseStateProvider.materialItems[commentStateProvider.currentMaterialPos];

                                    String res;

                                    /// deleting a reply
                                    if (commentStateProvider.insideRepliesPage && !mainComment) {
                                      commentStateProvider.replyIdToBeDeleted = commentStateProvider
                                          .comments[commentStateProvider.repliesRelevantCommentPos].replies[replyPos].id;
                                      res = await commentStateProvider.deleteReply(
                                        baseUploadingModel: materialInfo,
                                        commentID: commentId,
                                        replyID: commentStateProvider
                                            .comments[commentStateProvider.repliesRelevantCommentPos].replies[replyPos].id,
                                      );
                                    } else {
                                      /// deleting a entire comment
                                      commentStateProvider.replyIdToBeDeleted = null;
                                      res = await commentStateProvider.deleteComment(comment_id: commentId, materialInfo: materialInfo);
                                    }
                                    Navigator.of(context, rootNavigator: true).pop({'from': 'onDelete', 'value': res});
                                  },
                                ),
                              );

                              if (!userInfoProvider.isBottomNavBarVisible) {
                                userInfoProvider.setBottomNavBarVisibilityTo(true);
                              }
                              if (res != null && res['from'] == 'onDelete') {
                                _commentOnDelete(context, res, baseStateProvider);
                              } else if (res != null && res['from'] == 'onEdit') {
                                _commentOnEdit(context);
                              } else {
                                if (addOrEditCommentWidgetStateProvider.focusNode.hasFocus) {
                                  addOrEditCommentWidgetStateProvider.focusNode.unfocus();
                                }
                              }
                            },
                          ),
                      ],
                    ),
                    CommentStatusWidget(
                      commentPos: commentPos,
                      withinReply: withinReply,
                      replyPos: replyPos,
                      mainComment: mainComment,
                    )
                  ],
                ),
              ),
            ),
            subtitle: Selector<CommentStateProvider, bool>(
              selector: (context, stateProvider) => withinReply && !mainComment
                  ? stateProvider.comments[commentPos].replies[replyPos].breaked
                  : stateProvider.comments[commentPos].breaked,
              builder: (context, isBreaked, _) => Container(
                constraints: isBreaked ? BoxConstraints(maxHeight: ScreenUtil().setHeight(300)) : BoxConstraints(),
                padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(50),
                  right: ScreenUtil().setSp(50),
                  bottom: ScreenUtil().setSp(10),
                  top: ScreenUtil().setSp(20),
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.23),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(ScreenUtil().setSp(20)),
                      bottomRight: Radius.circular(ScreenUtil().setSp(20)),
                    )),
                child: Selector<CommentStateProvider, List<dynamic>>(
                  selector: (context, stateProvider) => withinReply && !mainComment
                      ? [
                          stateProvider.comments[commentPos].replies[replyPos].content,
                          stateProvider.comments[commentPos].replies[replyPos].breaked,
                          stateProvider.comments[commentPos].replies[replyPos].breakable,
                        ]
                      : [
                          stateProvider.comments[commentPos].content,
                          stateProvider.comments[commentPos].breaked,
                          stateProvider.comments[commentPos].breakable,
                        ],
                  builder: (context, states, _) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            if (withinReply && !mainComment) {
                              commentStateProvider.breakReply(commentPos, replyPos);
                            } else {
                              commentStateProvider.breakComment(commentPos);
                            }
                          },
                          child: Text(
                            states[0],
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      !states[2]
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (withinReply && !mainComment) {
                                  commentStateProvider.breakReply(commentPos, replyPos);
                                } else {
                                  commentStateProvider.breakComment(commentPos);
                                }
                              },
                              child: Text(states[1] ? 'show more' : 'show less'),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (commentStateProvider.comments[commentPos].replies != null &&
              !withinReply &&
              commentStateProvider.comments[commentPos].replies.length != 0)
            GestureDetector(
              onTap: () {
                commentStateProvider.displayRepliesOfTheComment(commentPos);
              },
              child: Selector<CommentStateProvider, int>(
                selector: (context, stateProvider) => stateProvider.comments[commentPos].replies.length,
                builder: (context, repliesCount, _) => Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setSp(220)),
                  child: Text(
                    '$repliesCount Replies',
                    style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          if (commentStateProvider.comments[commentPos].replies != null &&
              !withinReply &&
              commentStateProvider.comments[commentPos].replies.length != 0)
            SizedBox(
              height: ScreenUtil().setHeight(40),
            ),
          Row(
            mainAxisAlignment: !withinReply ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: ScreenUtil().setWidth(withinReply ? 200 : 35),
                  ),
                  Icon(
                    Icons.thumb_up,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  Selector<CommentStateProvider, int>(
                    selector: (context, stateProvider) =>
                        stateProvider.comments[commentPos].ratings.where((rating) => rating.ratingType).toList().length,
                    builder: (context, likesCount, _) => Text('$likesCount'),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  Icon(
                    Icons.thumb_down,
                    color: Colors.redAccent,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  Selector<CommentStateProvider, int>(
                    selector: (context, stateProvider) =>
                        stateProvider.comments[commentPos].ratings.where((rating) => !rating.ratingType).toList().length,
                    builder: (context, dislikesCount, _) => Text('$dislikesCount'),
                  ),
                ],
              ),
              if (!withinReply)
                InkWell(
                  child: Text('Reply'),
                  onTap: () {
                    print('we must open the replies');
                    commentStateProvider.displayRepliesOfTheComment(commentPos);
                  },
                )
            ],
          )
        ],
      ),
    );
  }
}
