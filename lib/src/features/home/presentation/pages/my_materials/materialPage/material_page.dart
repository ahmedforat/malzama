import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:provider/provider.dart';

import '../../../../models/users/user.dart';
import '../../../state_provider/user_info_provider.dart';
import '../materials_page_widgets/drafts_icon_widget.dart';
import '../materials_page_widgets/my_saved_materials_icon_widget.dart';
import '../materials_page_widgets/my_uploaded_material_icon_widget.dart';
import '../materials_page_widgets/quizes_icon_widget.dart';
import 'upper_uploading_banner/upper_uploading_banner.dart';

class MyMaterialPage extends StatelessWidget {
  final List<Widget> _contentCreators = [
    UpperUplaodingBanner(),
    SizedBox(height: ScreenUtil().setHeight(80)),
    MyUploadedMaterials(),
    SizedBox(height: ScreenUtil().setHeight(50)),
    DraftIconWidget(),
    SizedBox(height: ScreenUtil().setHeight(50)),
    Quizes(),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Selector<UserInfoStateProvider, User>(
      selector: (context, stateProvider) => stateProvider.userData,
      builder: (context, data, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print(locator<UserInfoStateProvider>().userData.savedVideos);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollegePDFDetailsPage(pos: pos,)));
          },
        ),
        body: data == null
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
                    children: <Widget>[
                      if (data.accountType != 'schstudents') ..._contentCreators,
                      MySavedMaterialsIcon(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
