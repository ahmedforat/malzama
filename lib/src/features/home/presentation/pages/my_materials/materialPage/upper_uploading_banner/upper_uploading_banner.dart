import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/Navigator/routes_names.dart';
import '../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../state_provider/user_info_provider.dart';
import 'upper_uploading_banner_item.dart';


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
      locator<UserInfoStateProvider>().userData.accountType;
  final String routeName = accountType == 'schteachers'
      ? RouteNames.UPLOAD_NEW_MATERIAL_SCHOOL
      : RouteNames.UPLOAD_NEW_MATERIAL_COLLEGE;
print('naving to $routeName');
  Navigator.of(context).pushNamed(routeName, arguments: materialType);
}
