import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/general_widgets/custom_selector.dart';
import 'package:malzama/src/core/general_widgets/get_material_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/material_state_provider..dart';
import 'package:provider/provider.dart';
import '../../../state_provider/user_info_provider.dart';


class MyUploadedMaterials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context,listen: false);
    var materialStateProvider = getMaterialStateProvider(context, listen: false,account_type: userInfoStateProvider.account_type);
    bool isAcademic = userInfoStateProvider.account_type != 'schteachers';
    
    return ListTile(
      title: Text(
        'My Uploads',
        style: TextStyle(
          fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(60)
        ),
      ),
      subtitle: CustomSelectorWidget<List<int>>(
        isAcademic: isAcademic,
        selector: (context, stateProvider) => [stateProvider.myPDFs.length, stateProvider.myVideos.length],
        builder: (context, _, __) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Text(
              ' ${materialStateProvider.myVideos == null ? 0 : materialStateProvider.myVideos.length} videos',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(50),
            ),
            Text(
              '${materialStateProvider.myPDFs == null ? 0 : materialStateProvider.myPDFs.length} lectures',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
          ],
        ),
      ),
      trailing: RaisedButton(
        color: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.EXPLORE_MY_MATERIALS);
        },
        child: Text(
          'Explore',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


