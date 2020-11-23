import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../lectures_pages/widgets/college_pdf_holding_widget.dart';
import '../../state_providers/comment_state_provider.dart';


class RepliesRelevantComment extends StatelessWidget {
  final int commentPos;

  RepliesRelevantComment({@required this.commentPos});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Selector<CommentStateProvider, String>(
              selector: (context, stateProvider) => stateProvider.comments[commentPos].author.profilePictureRef,
              builder: (context, profilePicture, _) => userAvatar(imageUrl: profilePicture),
            ),
          ),
        ],
      ),
    );
  }
}
