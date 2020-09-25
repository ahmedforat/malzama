import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/get_material_state_provider.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/presentation/state_provider/pdf_viewer_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/material_state_provider..dart';
import 'package:provider/provider.dart';

import '../../../../../state_provider/profile_page_state_provider.dart';

class CollegeMaterialWidget extends StatelessWidget {
  final bool isVideo;
  final int pos;

  CollegeMaterialWidget({
    @required this.isVideo,
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    final String account_type = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
    var materialStateProvider = getMaterialStateProvider(context, account_type: account_type);

    ScreenUtil.init(context);
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isVideo
                          ? 'Author: ' + materialStateProvider.myVideos[pos].author.firstName + ' ' + materialStateProvider.myVideos[pos].author.lastName
                          : 'Author: ' + materialStateProvider.myPDFs[pos].author.firstName + ' ' + materialStateProvider.myPDFs[pos].author.lastName,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(25),
                      ),
                    ),
                    Text(
                      isVideo
                          ? '${materialStateProvider.myVideos[pos].university}/${materialStateProvider.myVideos[pos].college}'
                          : '${materialStateProvider.myPDFs[pos].university}/${materialStateProvider.myPDFs[pos].college}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(25),
                      ),
                    ),
                    Text(
                      isVideo
                          ? 'Audience: ${materialStateProvider.myVideos[pos].university}/${materialStateProvider.myVideos[pos].stage}'
                          : 'Audience: ${materialStateProvider.myPDFs[pos].university}/${materialStateProvider.myPDFs[pos].stage}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ],
                ),
                Icon(
                  isVideo ? Icons.ondemand_video : Icons.picture_as_pdf,
                  size: ScreenUtil().setSp(140),
                  color: Colors.red,
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Text(
              isVideo
                  ? '${materialStateProvider.myVideos[pos].university}/${materialStateProvider.myVideos[pos].title}'
                  : '${materialStateProvider.myPDFs[pos].university}/${materialStateProvider.myPDFs[pos].title}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(5),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: Text(
              isVideo
                  ? 'Date: ${materialStateProvider.myVideos[pos].university}/${materialStateProvider.myVideos[pos].post_date}'
                  : 'Date: ${materialStateProvider.myPDFs[pos].university}/${materialStateProvider.myPDFs[pos].post_date}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(40),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
            ),
            child: Text(
              isVideo
                  ? '${materialStateProvider.myVideos[pos].university}/${materialStateProvider.myVideos[pos].description}'
                  : '${materialStateProvider.myPDFs[pos].university}/${materialStateProvider.myPDFs[pos].description}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SchoolMaterialWidget extends StatelessWidget {
  final int pos;
  final bool isVideo;

  SchoolMaterialWidget({@required this.pos, @required this.isVideo});

  @override
  Widget build(BuildContext context) {
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);
    final String account_type = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
    var materialStateProvider = getMaterialStateProvider(context, account_type: account_type);

    return GestureDetector(
      onTap: () {
        DialogService serviceLocator = locator.get<DialogService>();
        if (isVideo) {
          Navigator.of(context).pushNamed('/video-display-widget', arguments: materialStateProvider.myVideos[pos].videoId);
        } else {
          serviceLocator.pdfSize = materialStateProvider.myPDFs[pos].size;
          serviceLocator.pdfUrl = materialStateProvider.myPDFs[pos].path;
          serviceLocator.pdfSource = PDFSource.URL;
          print('before crash');
          Navigator.of(context).pushNamed('/pdf-viewer-widget');
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
        padding: EdgeInsets.all(
          ScreenUtil().setSp(30),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ScreenUtil().setSp(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'اعداد المدرس: ${profilePageState.userData.commonFields.firstName} ${profilePageState.userData.commonFields.lastName}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(25),
                          ),
                        ),
                        Text(
                          '${profilePageState.userData.school}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(25),
                          ),
                        ),
                        Text(
                          isVideo
                              ? '${References.stages[materialStateProvider.myVideos[pos].stage]} / ${materialStateProvider.myVideos[pos].school_section}'
                              : '${References.stages[materialStateProvider.myPDFs[pos].stage]} / ${materialStateProvider.myPDFs[pos].school_section}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      isVideo ? Icons.ondemand_video : Icons.picture_as_pdf,
                      size: ScreenUtil().setSp(140),
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              child: Text(
                isVideo ? materialStateProvider.myVideos[pos].title : materialStateProvider.myPDFs[pos].title,
                style: TextStyle(fontSize: ScreenUtil().setSp(50), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Text(
                isVideo ? materialStateProvider.myVideos[pos].post_date.substring(0, 10) : materialStateProvider.myPDFs[pos].post_date.substring(0, 10),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(40),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              child: Text(
                isVideo ? materialStateProvider.myVideos[pos].description : materialStateProvider.myPDFs[pos].description,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
