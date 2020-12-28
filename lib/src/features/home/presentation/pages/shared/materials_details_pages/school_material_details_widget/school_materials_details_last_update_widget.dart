

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class SchoolMaterialDetailsLastUpdateWidget<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const SchoolMaterialDetailsLastUpdateWidget({@required this.pos});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
        child: Text(
          'اخر تحديث: 22/08/2050',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        )??Selector<B, String>(
          selector: (context, stateProvider) => stateProvider.materials[pos].lastUpdate,
          builder: (context, lastUpdate, _) => Text(
            lastUpdate ?? 'اخر تحديث : 22/08/2050',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
