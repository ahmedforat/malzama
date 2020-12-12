
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

import '../state_providers/add_comment_widget_state_provider.dart';
import '../state_providers/comment_state_provider.dart';
import 'add_comment_text_field.dart';

class UpdateAlreadyExistedCommentWidget<B extends MaterialStateRepository> extends StatelessWidget {
  void onEditingAnExistingComment(
     BuildContext context,
  ) async {
    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);

    bool result = await commentStateProvider.editCommentOrReply(context: context);
    String message = result ? 'Comment Edited' : 'failed to edit comment';
    commentStateProvider.commentsScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
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
              child: AddCommentTextField<B>(),
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
