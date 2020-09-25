import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/single_comment_widget.dart';

class RepliesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context,pos){
          return CommentWidget(
            withinReply: true,
          );
        },
      ),
    );
  }
}
