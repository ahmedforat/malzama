import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import '../../features/home/presentation/pages/shared/comments_and_replies/state_providers/comment_state_provider.dart';

class CommentStateChangeNotifierProvider<T extends MaterialStateRepository> extends StatelessWidget {
  final Widget child;
  final int pos;

  const CommentStateChangeNotifierProvider({
    @required this.child,
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommentStateProvider<T>>(
      create: (context) => CommentStateProvider<T>(
        context: context,
        materialPos: pos,
      ),
      builder: (context, _) => child,
    );
  }
}
