import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

import '../state_providers/add_comment_widget_state_provider.dart';
import 'add_new_comment_widget.dart';
import 'update_already_existing_comment.dart';

class BottomSheetWidget<B extends MaterialStateRepository> extends StatelessWidget {

  const BottomSheetWidget();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Selector<AddOrEditCommentWidgetStateProvider, bool>(
      selector: (context, stateProvider) => stateProvider.isCommentUpdating,
      builder: (context, isUpdatingComment, _) {
        if (isUpdatingComment) {
          return UpdateAlreadyExistedCommentWidget<B>();
        } else {
          return AddNewCommentWidget<B>();
        }
      },
    );
  }
}
