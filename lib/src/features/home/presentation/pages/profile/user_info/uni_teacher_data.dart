import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../models/users/college_teacher.dart';
import '../../../../models/users/user.dart';
import '../../../state_provider/user_info_provider.dart';

class UniTeacherInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    return Selector<UserInfoStateProvider,User>(
        selector: (context, stateProvider) => stateProvider.userData,
        builder: (context, userData, _) {
          return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(50),
                      vertical: ScreenUtil().setSp(15)),
                  child: Text(
                    'Info',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(80)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                  //color:Colors.red,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.my_location),
                        title: Text('City'),
                        subtitle: Text(
                          userData.province.replaceFirst(userData.province[0], userData.province[0].toUpperCase()),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                      ),
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text('University'),
                        subtitle: Text(
                          (userData as CollegeTeacher).university,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                      ),
                      Tooltip(
                        message: (userData as CollegeTeacher).college,
                        child: ListTile(
                          leading: FaIcon(FontAwesomeIcons.book),
                          title: Text('College'),
                          subtitle: Text(
                            (userData as CollegeTeacher).college,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                      ),
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text('Section'),
                        subtitle: Text(
                          (userData as CollegeTeacher).section,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                      ),
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text('Speciality'),
                        subtitle: Text(
                          (userData as CollegeTeacher).speciality,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
