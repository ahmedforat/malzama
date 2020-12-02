import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

class CommentsSectionWidget<B extends MaterialStateRepo> extends StatelessWidget {
  final int pos;

  const CommentsSectionWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
