import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
import 'package:provider/provider.dart';

import '../add_comment_widget/add_comment_bottom_sheet_widget.dart';
import '../single_comment_widget.dart';
import '../state_providers/comment_state_provider.dart';
import 'widgets/header.dart';

class ReplyDisplayPage<B extends MaterialStateRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);

    return Selector<CommentStateProvider<B>, List<dynamic>>(
      selector: (context, stateProvider) => [
        stateProvider.repliesRelevantCommentPos,
        stateProvider.insideRepliesPage,
      ],
      builder: (context, dependencies, _) => !dependencies[1]
          ? Container()
          : Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setSp(30),
                //horizontal: ScreenUtil().setSp(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RepliesDisplayPageHeader<B>(),
                  SizedBox(height: ScreenUtil().setHeight(60)),
                  Expanded(
                    child: Selector<CommentStateProvider<B>, int>(
                      selector: (context, stateProvider) =>
                          stateProvider.comments[commentStateProvider.repliesRelevantCommentPos].replies.length + 1,
                      builder: (context, repliesCount, child) => ListView.builder(
                        itemCount: repliesCount,
                        itemBuilder: (context, pos) {
                          if (pos == 0) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
                              child: CommentWidget<B>(
                                commentPos: dependencies[0],
                                withinReply: true,
                                mainComment: true,
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().setSp(80)),

                            child: CommentWidget<B>(
                              commentPos: commentStateProvider.repliesRelevantCommentPos,
                              withinReply: true,
                              replyPos: pos - 1,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            bottomSheet: BottomSheetWidget<B>(),
          ),
    );
  }
}
