import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_providers/add_comment_widget_state_provider.dart';
import '../state_providers/comment_state_provider.dart';

class AddCommentTextField extends StatelessWidget {
  final String initialText;

  AddCommentTextField({
    String text,
  }) : this.initialText = text ?? '';

  @override
  Widget build(BuildContext context) {
    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider = Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context,listen: false);
    final _hintText = commentStateProvider.insideRepliesPage ? 'Type a reply':'Type a comment';
    return TextFormField(
      onChanged: (text) {
        addOrEditCommentWidgetStateProvider.setIsSendButtonVisibilityTo(text.isNotEmpty);
      },

      controller: addOrEditCommentWidgetStateProvider.textController,
      focusNode: addOrEditCommentWidgetStateProvider.focusNode,
      scrollPhysics: BouncingScrollPhysics(),
      maxLines: null,
      decoration: InputDecoration(
        //prefix: userAvatar(),
        border: InputBorder.none,
        hintText: _hintText,
      ),
    );
  }
}
