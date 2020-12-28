import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/general_models/customDate.dart';
import 'state_providers/comment_state_provider.dart';

class CommentStatusWidget<B extends MaterialStateRepository> extends StatelessWidget {
  final int commentPos;
  final withinReply;
  final replyPos;
  final mainComment;

  CommentStatusWidget({
    @required this.commentPos,
    bool withinReply,
    int replyPos,
    bool mainComment,
  })  : this.withinReply = withinReply ?? false,
        this.replyPos = replyPos ?? null,
        this.mainComment = mainComment ?? false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);
    return Selector<CommentStateProvider<B>, CommentStatus>(
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
                    print('resend btn has been pressed');

                    commentStateProvider.uplaodNewComment(
                      content: commentStateProvider.comments[commentPos].content,
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
