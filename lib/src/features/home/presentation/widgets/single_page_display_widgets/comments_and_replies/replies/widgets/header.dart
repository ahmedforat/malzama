import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/state_providers/add_comment_widget_state_provider.dart';

import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/state_providers/comment_state_provider.dart';
import 'package:provider/provider.dart';

class RepliesDisplayPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context,listen: false);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30),horizontal: ScreenUtil().setSp(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Provider.of<AddOrEditCommentWidgetStateProvider>(context,listen: false).resetWidget();
                commentStateProvider.closeRepliesDisplayPage();
              },
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'replies to your comment on ali\'s lecture to your comment on ali\'s lecture',
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  )
                ],
              ),
            ),
            RaisedButton(
              child: Text('view lecture',style: TextStyle(color: Colors.white),),
              color: Colors.blueAccent,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
