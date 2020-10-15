import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/material_uploading/college_uploads_state_provider.dart';
import 'package:malzama/src/core/platform/services/material_uploading/school_uploads_state_provider.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/upper_uploading_banner_item.dart';
import 'package:provider/provider.dart';

class UpperUplaodingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      constraints: BoxConstraints(),
      color: Color.fromRGBO(244, 243, 243, 1),
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: UpperUploadingBannerItem(
              icon: FlutterIcons.file1_ant,
              icon2: true,
              text: 'Upload Lecture',
              onPressed: () =>
                  _handleOnPressed(context: context, materialType: 'lecture'),
            ),
          ),
          Expanded(
            child: UpperUploadingBannerItem(
              icon: FlutterIcons.youtube_ant,
              icon2: false,
              text: 'Upload Video',
              onPressed: () =>
                  _handleOnPressed(context: context, materialType: 'video'),
            ),
          ),
          Expanded(
            child: UpperUploadingBannerItem(
              icon: Icons.playlist_add_check,
              icon2: false,
              text: 'Upload MCQs',
              onPressed: () => Navigator.of(context).pushNamed(RouteNames.UPLOAD_NEW_QUIZ),
            ),
          ),
        ],
      ),
    );
  }
}


// called when anyone of the upper uploading banner items get clicked
void _handleOnPressed({BuildContext context, String materialType}) {
  final String accountType =
      Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
  final String routeName = accountType == 'schteachers'
      ? RouteNames.UPLOAD_NEW_MATERIAL_SCHOOL
      : RouteNames.UPLOAD_NEW_MATERIAL_COLLEGE;

  Navigator.of(context).pushNamed(routeName, arguments: materialType);
}
