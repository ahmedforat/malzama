import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/details_pages/college_pdf_details_page.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';
import '../materials_widgets/my_saved_materials.dart';
import '../quizes_widget.dart';
import 'drafts/drafts_icon_widget.dart';
import 'my_uploads/my_uploaded_material_widget.dart';
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
    return Selector<UserInfoStateProvider, String>(
      selector: (context, stateProvider) => stateProvider.userData.accountType,
      builder: (context, account_type, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollegePDFDetailsPage()));
          },
        ),
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
                    children: <Widget>[
                      if (account_type != 'schstudents') ..._contentCreators,
                      MySavedMaterials(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
