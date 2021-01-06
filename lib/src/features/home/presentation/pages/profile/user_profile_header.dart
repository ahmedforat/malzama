import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/state_provider/edit_personal_info_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/widgets/cover_picture_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/widgets/edit_personal_info_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/widgets/personal_info_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/widgets/profile_picture_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/widgets/verify_email_by_auth_code.dart';
import 'package:provider/provider.dart';

import '../../state_provider/profile_page_state_provider.dart';

String accountTypeMapper(String type) {
  switch (type) {
    case 'uniteachers':
      return 'University Lecturer';
      break;
    case 'unistudents':
      return 'University Student';
      break;
    case 'schteachers':
      return 'School Teacher';
      break;
    case 'schstudents':
      return 'School Student';
      break;
    default:
      return null;
  }
}

class UserProfileHeader2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: ScreenUtil().setHeight(750),
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            ProfileCoverPictureWidget(),
            Positioned(
              child: ProfilePictureWidget(),
              top: ScreenUtil().setHeight(270),
              left: ScreenUtil().setWidth(50),
            ),
            Positioned(
              child: PersonalInfoWidget(),
              top: ScreenUtil().setHeight(490),
              left: ScreenUtil().setWidth(30),
            ),
          
            Positioned(
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.edit),
                onPressed: () async {

                  final data = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => ChangeNotifierProvider<EditPersonalInfoState>(
                      create: (context) => EditPersonalInfoState(),
                      builder: (context, _) => EditPersonalInfoWidget(),
                    ),
                  );
                  //  print(data);
                },
              ),
              top: ScreenUtil().setHeight(470),
              left: ScreenUtil().setWidth(900),
            ),
          ],
        ),
      ),
    );
  }
}
