import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_models/customDate.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/home_page_navigator/home_page_navigator/state/state_getter.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/videos_navigator/state/state_getter.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/state_providers/comment_state_provider.dart';
import 'package:provider/provider.dart';

class CommentStatusWidget extends StatelessWidget {
  final int commentPos;
  final withinReply;
  final replyPos;
  final mainComment;

  CommentStatusWidget({@required this.commentPos, bool withinReply, int replyPos, bool mainComment,})
      : this.withinReply = withinReply ?? false,
        this.replyPos = replyPos ?? null,
        this.mainComment = mainComment ?? false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);
    return Selector<CommentStateProvider, CommentStatus>(
      selector: (context, stateProvider) => withinReply && !mainComment
          ? stateProvider.comments[commentPos].replies[replyPos].commentStatus
          : stateProvider.comments[commentPos].commentStatus,
      builder: (context, status, _) {
        switch (status) {
          case CommentStatus.IN_PROGRESS:
            return Text(
              'sending ...',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
              ),
            );
            break;

          case CommentStatus.UPDATING:
            return Text(
              'updating ...',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
              ),
            );
            break;

          case CommentStatus.DELETING:
            return Text(
              'deleting ...',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
              ),
            );
            break;
          case CommentStatus.FAILED:
            return Row(
              children: <Widget>[
                Text(
                  'failed to send',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
                //SizedBox(width: ScreenUtil().setWidth(10),),
                FlatButton(
                  //color: Colors.blue,
                  child: Text(
                    'resend',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                  onPressed: () async {
                    final baseStateProvider = commentStateProvider.isVideo
                        ? getVideosPageStateProvider(context: context, listen: false)
                        : getHomePageStateProvider(context: context, listen: false);
                    print('resend btn has been pressed');

                    commentStateProvider.uplaodNewComment(
                      content: commentStateProvider.comments[commentPos].content,
                      materialInfo: baseStateProvider.materialItems[commentStateProvider.currentMaterialPos],
                      resend: true,
                      pos: commentPos,
                    );
                  },
                ),
              ],
            );
            break;
          default:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: ScreenUtil().setSp(35),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Text(
                  CustomDate().getPostedAt(
                    DateTime.parse(
                      withinReply && !mainComment
                          ? commentStateProvider.comments[commentPos].replies[replyPos].postDate
                          : commentStateProvider.comments[commentPos].postDate,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                  ),
                )
              ],
            );
        }
      },
    );
  }
}
