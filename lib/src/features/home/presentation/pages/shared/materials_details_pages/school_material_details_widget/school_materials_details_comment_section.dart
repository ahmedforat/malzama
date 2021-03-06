import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class SchoolCommentsSectionWidget<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const SchoolCommentsSectionWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
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
            Text('اضغط لمشاهدة التعليقات'),
            Text('52 تعليق') ??
                Selector<B, int>(
                  selector: (context, stateProvider) => stateProvider.materials[pos].comments.length,
                  builder: (context, count, _) => Text('$count  تعليق '),
                ),
          ],
        ),
      ),
    );
  }
}
