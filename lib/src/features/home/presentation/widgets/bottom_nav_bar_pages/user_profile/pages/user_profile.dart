import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/drafts_displayer.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/drafts_icon_widget.dart';
import 'package:provider/provider.dart';

import '../../../../state_provider/profile_page_state_provider.dart';
import '../widgets/material_displayer.dart';
import '../widgets/user_info/sch_student_info.dart';
import '../widgets/user_info/sch_teacher_info.dart';
import '../widgets/user_info/uni_student_info.dart';
import '../widgets/user_info/uni_teacher_data.dart';
import '../widgets/user_profile_header.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building profile page');
    ScreenUtil.init(context);
    ProfilePageState profilePageState =
        Provider.of<ProfilePageState>(context, listen: false);
    return Selector<ProfilePageState, bool>(
        selector: (context, stateProvider) => stateProvider.dataLoaded,
        builder: (context, dataLoaded, _) => !dataLoaded
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.grey[200],
                body: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      // FlatButton(
                      //   child: Text('show me'),
                      //   onPressed: ()async{
                      //   Provider.of<ProfilePageState>(context,listen: false).updateCounter();
                      // },),
                      UserProfileHeader2(),

                      SizedBox(height: ScreenUtil().setHeight(25)),

                      _getSuitableInfoDisplayer(
                          profilePageState.userData.commonFields.account_type),

                      SizedBox(height: ScreenUtil().setHeight(50)),
                      
                      MaterialDisplayer(),
                      SizedBox(height: ScreenUtil().setHeight(50)),
                      DraftIconWidget()
                    ],
                  ),
                ),
              ));
  }
}

Widget _getSuitableInfoDisplayer(String type) {
  final Map<String, Widget> _dictionary = {
    'uniteachers': UniTeacherInfoWidget(),
    'unistudents': UniStudentInfoWidget(),
    'schteachers': SchoolTeacherInfoWidget(),
    'schstudents': SchoolStudentInfoWidget()
  };
  return type == null ? null : _dictionary[type];
}

