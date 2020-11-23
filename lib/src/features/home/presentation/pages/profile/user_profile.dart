import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/users/college_user.dart';
import 'package:provider/provider.dart';

import '../../../models/users/user.dart';
import '../../state_provider/user_info_provider.dart';
import 'user_info/sch_student_info.dart';
import 'user_info/sch_teacher_info.dart';
import 'user_info/uni_student_info.dart';
import 'user_info/uni_teacher_data.dart';
import 'user_profile_header.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building profile page');
    ScreenUtil.init(context);

    return Selector<UserInfoStateProvider, User>(
        selector: (context, stateProvider) => stateProvider.userData,
        builder: (context, info, _) => info == null
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.grey[200],
                appBar: AppBar(
                  actions: [
                    IconButton(
                        icon: Text('user info'),
                        onPressed: () {
                          print(locator<UserInfoStateProvider>().userData.toJSON());
                          print(RegExp(r'سنان').hasMatch((locator<UserInfoStateProvider>().userData as CollegeUser).college));
                        })
                  ],
                ),
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

                      _getSuitableInfoDisplayer(info.accountType),

                      SizedBox(height: ScreenUtil().setHeight(50)),
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
