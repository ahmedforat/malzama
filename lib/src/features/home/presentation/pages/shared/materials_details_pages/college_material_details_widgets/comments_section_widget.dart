import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/comments_and_replies/commentsPage.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/comments_and_replies/state_providers/add_comment_widget_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class CommentsSectionWidget<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const CommentsSectionWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(B);
        Scaffold.of(context).showBottomSheet((context) => ChangeNotifierProvider<AddOrEditCommentWidgetStateProvider>(
              create: (context) => AddOrEditCommentWidgetStateProvider(),
              builder: (context, _) => CommentsPage<B>(pos: pos),
            ));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Tap To View Comments'),
            Selector<B, int>(
              selector: (context, stateProvider) => stateProvider.materials[pos].comments.length,
              builder: (context, count, _) => Text('$count comments'),
            ),
          ],
        ),
      ),
    );
  }
}
