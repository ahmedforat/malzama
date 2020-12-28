import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
import 'package:provider/provider.dart';

import '../../../../models/material_author.dart';
import '../../../state_provider/user_info_provider.dart';
import '../../home_page.dart';
import '../material_holding_widgets/college/college_pdf_holding_widget.dart';
import 'comment_modal_bottom_sheet.dart';
import 'comment_related_models/comment_model.dart';
import 'comment_related_models/comment_rating_model.dart';
import 'comment_status_widget.dart';
import 'replies/widgets/display_rators_page.dart';
import 'state_providers/add_comment_widget_state_provider.dart';
import 'state_providers/comment_state_provider.dart';

class CommentWidget<B extends MaterialStateRepository> extends StatelessWidget {
  final int commentPos;
  final bool withinReply;
  final int replyPos;
  final bool mainComment;

  CommentWidget({
    @required this.commentPos,
    bool withinReply = false,
    int replyPos,
    bool mainComment,
  })  : this.replyPos = replyPos ?? null,
        this.mainComment = mainComment ?? false,
        this.withinReply = withinReply;

  /// this method is called whenever the user press the edit option in the modal sheet of the comment editing options

  /// this method called when the like or dislike button gets clicked
  _commentOnRating(
      BuildContext context, CommentStateProvider<B> commentStateProvider, UserInfoStateProvider userInfoStateProvider, bool rating) {
    MaterialAuthor materialAuthor = MaterialAuthor.fromJSON(userInfoStateProvider.userData.toJSON());
    final int commentPosition = mainComment ? commentStateProvider.repliesRelevantCommentPos : commentPos;
    Comment currentComment = commentStateProvider.comments[commentPosition];
    CommentRating myRating =
        currentComment.ratings.firstWhere((rating) => rating.author.id == userInfoStateProvider.userData.id, orElse: () => null);
    commentStateProvider.setRatingOfCommentTo(
      commentPos: commentPosition,
      myId: userInfoStateProvider.userData.id,
      rating: rating,
      comment: currentComment,
      myRating: myRating,
      materialAuthor: materialAuthor,
    );
  }

  @override
  Widget build(BuildContext context) {
    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);
    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
    final specificCommentPos = mainComment ? commentStateProvider.repliesRelevantCommentPos : commentPos;

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
            leading: _ProfilePicture<B>(
              mainComment: mainComment,
              commentPos: commentPos,
              replyPos: replyPos,
              withinReply: withinReply,
            ),
            title: _Header<B>(
              mainComment: mainComment,
              commentPos: commentPos,
              replyPos: replyPos,
              withinReply: withinReply,
            ),
            subtitle: _ContentPart<B>(
              mainComment: mainComment,
              commentPos: commentPos,
              replyPos: replyPos,
              withinReply: withinReply,
            ),
          ),
          if (!withinReply || mainComment)
            Selector<CommentStateProvider<B>, List<dynamic>>(
              selector: (context, stateProvider) {
                final specificCommentPos = mainComment ? stateProvider.repliesRelevantCommentPos : commentPos;
                return [
                  stateProvider.comments[specificCommentPos].hasReplies,
                  stateProvider.comments[specificCommentPos].hasRatings,
                  stateProvider.comments[specificCommentPos].replies.length,
                ];
              },
              builder: (context, dependencies, child) => !dependencies[0] && !dependencies[1]
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(left: mainComment ? 50 : 80),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: ScreenUtil().setWidth(50)),
                            if (dependencies[0] && !mainComment)
                              GestureDetector(
                                onTap: () {
                                  addOrEditCommentWidgetStateProvider.resetWidget();
                                  commentStateProvider.displayRepliesOfTheComment(commentPos);
                                },
                                child: Selector<CommentStateProvider<B>, int>(
                                  selector: (context, stateProvider) => stateProvider.comments[commentPos].replies.length,
                                  builder: (context, repliesCount, _) => Text(
                                    '$repliesCount Replies',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            if (dependencies[0])
                              SizedBox(
                                width: ScreenUtil().setWidth(90),
                              ),
                            if (dependencies[1])
                              InkWell(
                                child: Selector<CommentStateProvider<B>, int>(
                                  selector: (context, stateProvider) => stateProvider.comments[specificCommentPos].ratings.length,
                                  builder: (context, ratingsCount, child) => Text(
                                    '$ratingsCount ratings',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  List<CommentRating> commentRatings = commentStateProvider.comments[specificCommentPos].ratings;
                                  print(commentRatings.length);
                                  commentRatings.forEach((element) {
                                    print(element.toJSON());
                                  });
                                  userInfoStateProvider.setBottomNavBarVisibilityTo(false);
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (_) => DisplayRatorsPage(ratingsList: commentRatings),
                                  ).whenComplete(
                                    () => userInfoStateProvider.setBottomNavBarVisibilityTo(true),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          if (commentStateProvider.comments[specificCommentPos].hasRatings || commentStateProvider.comments[specificCommentPos].hasReplies)
            SizedBox(
              height: ScreenUtil().setHeight(40),
            ),
          if (!withinReply || mainComment)
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
                    Selector<CommentStateProvider<B>, List<dynamic>>(
                      selector: (context, stateProvider) => [
                        stateProvider.comments[commentPos].ratings.length,
                        stateProvider.comments[commentPos].ratings
                            .firstWhere((rating) => rating.author.id == userInfoStateProvider.userData.id, orElse: () => CommentRating())
                            .ratingType,
                      ],
                      builder: (context, dependencies, child) => GestureDetector(
                        onTap: () => _commentOnRating(context, commentStateProvider, userInfoStateProvider, true),
                        child: Icon(
                          FontAwesomeIcons.thumbsUp,
                          color: dependencies[0] > 0 && dependencies[1] != null && dependencies[1] ? Colors.blueAccent : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(15),
                    ),
                    Selector<CommentStateProvider<B>, int>(
                      selector: (context, stateProvider) =>
                          stateProvider.comments[commentPos].ratings.where((rating) => rating.ratingType).toList().length,
                      builder: (context, likesCount, _) => Text('$likesCount'),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(15),
                    ),
                    Selector<CommentStateProvider<B>, List<dynamic>>(
                      selector: (context, stateProvider) => [
                        stateProvider.comments[commentPos].ratings.length,
                        stateProvider.comments[commentPos].ratings
                            .firstWhere((rating) => rating.author.id == userInfoStateProvider.userData.id, orElse: () => CommentRating())
                            .ratingType,
                      ],
                      builder: (context, dependencies, child) => GestureDetector(
                        onTap: () => _commentOnRating(context, commentStateProvider, userInfoStateProvider, false),
                        child: Icon(
                          FontAwesomeIcons.thumbsDown,
                          color: dependencies[0] > 0 && dependencies[1] != null && !dependencies[1] ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(15),
                    ),
                    Selector<CommentStateProvider<B>, int>(
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
                      addOrEditCommentWidgetStateProvider.resetWidget();
                      commentStateProvider.displayRepliesOfTheComment(commentPos);
                    },
                  ),
              ],
            )
        ],
      ),
    );
  }
}

class _Header<B extends MaterialStateRepository> extends StatelessWidget {
  final bool mainComment;
  final bool withinReply;
  final int commentPos;
  final int replyPos;

  const _Header({
    @required this.mainComment,
    this.commentPos,
    this.replyPos,
    this.withinReply,
  });

  _commentOnEdit(BuildContext context) async {
    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);
    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    if (commentStateProvider.insideRepliesPage && !mainComment) {
      final int currentCommentPos = commentStateProvider.repliesRelevantCommentPos;
      print('we editing a reply');
      addOrEditCommentWidgetStateProvider.textController.text = commentStateProvider.comments[currentCommentPos].replies[replyPos].content;
      await Future.delayed(Duration(milliseconds: 150));
      addOrEditCommentWidgetStateProvider.setIsCommentUpdatingTo(true);
      commentStateProvider.replyIdToBeUpdated = commentStateProvider.comments[currentCommentPos].replies[replyPos].id;
      commentStateProvider.commentIdToBeUpdated = commentStateProvider.comments[currentCommentPos].id;
    } else {
      print('we editing a comment');
      addOrEditCommentWidgetStateProvider.textController.text = commentStateProvider.comments[commentPos].content;
      await Future.delayed(Duration(milliseconds: 150));
      addOrEditCommentWidgetStateProvider.setIsCommentUpdatingTo(true);
      commentStateProvider.commentIdToBeUpdated = commentStateProvider.comments[commentPos].id;
      commentStateProvider.replyIdToBeUpdated = null;
    }
    await Future.delayed(Duration(milliseconds: 400));
    addOrEditCommentWidgetStateProvider.focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);
    UserInfoStateProvider userInfoStateProvider = locator<UserInfoStateProvider>();
    final String commentAuthorID = withinReply && !mainComment
        ? commentStateProvider.comments[commentPos].replies[replyPos].author.id
        : commentStateProvider.comments[commentPos].author.id;
    final bool isMyComment = commentAuthorID == userInfoStateProvider.userData.id;
    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.23),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil().setSp(20)),
            topRight: Radius.circular(ScreenUtil().setSp(20)),
          )),
      child: Selector<CommentStateProvider<B>, List<String>>(
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
                  userNames.first + ' ' + userNames.last,
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
                      addOrEditCommentWidgetStateProvider.resetWidget();

                      final UserInfoStateProvider userInfoProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
                      userInfoProvider.setBottomNavBarVisibilityTo(false);
                      await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: globalScaffoldKey.currentContext,
                        builder: (_) => CommentOptionsBottomSheet(
                          isComment: mainComment || !commentStateProvider.insideRepliesPage,
                          onEdit: () {
                            print('Editing');
                            Navigator.of(context, rootNavigator: true).pop();
                            _commentOnEdit(context);
                          },
                          onDelete: () async {
                            commentStateProvider.commentOnDelete(commentPos, replyPos, mainComment);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      );

                      if (!userInfoProvider.isBottomNavBarVisible) {
                        userInfoProvider.setBottomNavBarVisibilityTo(true);
                      }
                    },
                  ),
              ],
            ),
            CommentStatusWidget<B>(
              commentPos: commentPos,
              withinReply: withinReply,
              replyPos: replyPos,
              mainComment: mainComment,
            )
          ],
        ),
      ),
    );
  }
}

class _ProfilePicture<B extends MaterialStateRepository> extends StatelessWidget {
  final bool mainComment;
  final bool withinReply;
  final int commentPos;
  final int replyPos;

  const _ProfilePicture({
    @required this.mainComment,
    this.commentPos,
    this.replyPos,
    this.withinReply,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Selector<CommentStateProvider<B>, String>(
      selector: (context, stateProvider) => withinReply && !mainComment
          ? stateProvider.comments[commentPos].replies[replyPos].author.profilePictureRef
          : stateProvider.comments[commentPos].author.profilePictureRef,
      builder: (context, profilePicture, _) => userAvatar(imageUrl: profilePicture),
    );
  }
}

class _ContentPart<B extends MaterialStateRepository> extends StatelessWidget {
  final bool mainComment;
  final bool withinReply;
  final int commentPos;
  final int replyPos;

  const _ContentPart({
    @required this.mainComment,
    this.commentPos,
    this.replyPos,
    this.withinReply,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);
    return Selector<CommentStateProvider<B>, bool>(
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
        child: Selector<CommentStateProvider<B>, List<dynamic>>(
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
    );
  }
}
