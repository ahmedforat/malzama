import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';

import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/comments_and_replies/state_providers/comment_state_provider.dart';
import 'package:provider/provider.dart';

class CommentStateChangeNotifierProvider<T extends MaterialStateRepo> extends StatelessWidget {
  final Widget child;
  final Map<String, dynamic> args;

  const CommentStateChangeNotifierProvider({@required this.child, @required this.args});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommentStateProvider>(
      create: (context) => CommentStateProvider<T>(
        isVideo: args['isvideo'] ?? false,
        state: args['state'] as StudyMaterial,
        materialPos: args['materialPos'],
      ),
      builder: (context,_) =>  child,
    );
  }
}
