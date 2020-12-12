import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

import 'state_providers/comment_state_provider.dart';

class LoadMoreCommentsButton<B extends MaterialStateRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CommentStateProvider<B> commentStateProvider = Provider.of<CommentStateProvider<B>>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        commentStateProvider.setIsFetchingMoreTo(true);
        //await Future.delayed(Duration(seconds: 1));
        await commentStateProvider.fetchComments();
        commentStateProvider.setIsFetchingMoreTo(false);
      },
      child: Selector<CommentStateProvider<B>, List<bool>>(
        selector: (context, stateProvider) => [
          stateProvider.isFetchingMore,
          stateProvider.anyMoreComment,
        ],
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
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
