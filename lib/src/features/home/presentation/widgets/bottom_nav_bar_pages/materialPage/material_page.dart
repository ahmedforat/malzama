import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';

import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/material_state_provider..dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/my_saved_materials.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/upper_uploading_banner.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/drafts_icon_widget.dart';
import 'package:provider/provider.dart';
import 'my_uploaded_material.dart';
import '../../../state_provider/user_info_provider.dart';

class MyMaterialPage extends StatelessWidget {
  final List<Widget> _contentCreators = [
    UpperUplaodingBanner(),
    SizedBox(height: ScreenUtil().setHeight(80)),
    MyUploadedMaterials(),
    SizedBox(height: ScreenUtil().setHeight(50)),
    DraftIconWidget(),
    SizedBox(height: ScreenUtil().setHeight(50)),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Selector<UserInfoStateProvider, String>(
      selector: (context, stateProvider) => stateProvider.account_type,
      builder: (context, account_type, child) => Scaffold(
        body: account_type == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setSp(50),
                  left: ScreenUtil().setSp(30),
                  right: ScreenUtil().setSp(30),
                ),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[if (account_type != 'schstudents') ..._contentCreators, MySavedMaterials()],
                  ),
                ),
              ),
      ),
    );
  }
}
