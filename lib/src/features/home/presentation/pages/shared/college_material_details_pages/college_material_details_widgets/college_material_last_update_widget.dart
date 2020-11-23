import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

class CollgeMaterialLastUpdateWidget<B extends MaterialStateRepo> extends StatelessWidget {
  final int pos;

  const CollgeMaterialLastUpdateWidget({@required this.pos});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
      child: Text(
         'last update: 22/08/2050',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(35),
          fontWeight: FontWeight.bold,
        ),
      )??Selector<B, String>(
        selector: (context, stateProvider) => stateProvider.materials[pos].lastUpdate,
        builder: (context, lastUpdate, _) => Text(
          lastUpdate ?? 'last update: 22/08/2050',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
