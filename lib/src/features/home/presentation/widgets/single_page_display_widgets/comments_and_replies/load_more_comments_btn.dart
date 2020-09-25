import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'state_providers/comment_state_provider.dart';

class LoadMoreCommentsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        commentStateProvider.setIsFetchingMoreTo(true);
        //await Future.delayed(Duration(seconds: 1));
        await commentStateProvider.fetchComments();
        commentStateProvider.setIsFetchingMoreTo(false);
      },
      child: Selector<CommentStateProvider, List<bool>>(
        selector: (context, stateProvider) => [stateProvider.isFetchingMore, stateProvider.anyMoreComment],
        builder: (context, states, _) {
          if (states[0]) {
            return SizedBox(height: ScreenUtil().setHeight(80), child: CircularProgressIndicator());
          }
          if (states[1]) {
            return SizedBox(
                height: ScreenUtil().setHeight(80),
                child: Text(
                  'Load More Comments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ));
          }
          return Container();
        },
      ),
    );
  }
}
