import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class CollegeMaterialTitleWidget<B extends MaterialStateRepository>
    extends StatelessWidget {
  final int pos;

  CollegeMaterialTitleWidget({@required this.pos});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MaterialStateRepository materialStateRepo =
        Provider.of<B>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: Text(
            materialStateRepo.materials[pos].title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(50),
              fontWeight: FontWeight.bold,
            ),
          ) ??
          Selector<B, String>(
            selector: (context, stateProvider) =>
                stateProvider.materials[pos]?.topic,
            builder: (context, title, _) => Text(
              title ??
                  'Clinical Pharmacy And Therapeutics And Therapeutics  And Therapeutics',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
    );
  }
}
