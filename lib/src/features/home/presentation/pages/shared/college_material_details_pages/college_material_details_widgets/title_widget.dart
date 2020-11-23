import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

class CollegeMaterialTitleWidget<B extends MaterialStateRepo> extends StatelessWidget {
  final int pos;

  CollegeMaterialTitleWidget({@required this.pos});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MaterialStateRepo materialStateRepo = Provider.of<B>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      child: Text(
        'Clinical Pharmacy And Therapeutics And Therapeutics  And Therapeutics',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(50),
          fontWeight: FontWeight.bold,
        ),
      )??Selector<B, String>(
        selector: (context, stateProvider) => stateProvider.materials[pos]?.topic,
        builder:(context,title,_) =>  Text(
          title??'Clinical Pharmacy And Therapeutics And Therapeutics  And Therapeutics',
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
