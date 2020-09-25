import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../state_providers/add_comment_widget_state_provider.dart';
import 'add_new_comment_widget.dart';
import 'update_already_existing_comment.dart';

class BottomSheetWidget extends StatelessWidget {
  final bool isForReply;

  BottomSheetWidget({bool isForReply}) : this.isForReply = isForReply ?? false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    AddOrEditCommentWidgetStateProvider commentStateProvider = Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    return Selector<AddOrEditCommentWidgetStateProvider, bool>(
      selector: (context, stateProvider) => stateProvider.isCommentUpdating,
      builder: (context, isUpdatingComment, _) {
        if (isUpdatingComment) {
          return UpdateAlreadyExistedCommentWidget();
        } else {
          return AddNewCommentWidget();
        }
      },
    );
  }
}
