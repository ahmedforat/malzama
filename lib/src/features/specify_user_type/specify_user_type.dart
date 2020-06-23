import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/core/references/references.dart';

import '../../core/platform/services/caching_services.dart';

class SpecifyUserTypeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    

    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff696b9e),
        title: Text('choose account type'),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(180)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('استاذ جامعي'),
              onTap: () async {
                await _navigateToCollegePostSignupPage(
                    context, AccountType.uniteachers);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('طالب جامعي'),
              onTap: () async {
                _navigateToCollegePostSignupPage(
                    context, AccountType.unistudents);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('استاذ اعدادية'),
              onTap: () async {
                await _navigateToSchoolPostSignUpPage(
                    context, AccountType.schteachers);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              title: Text('طالب اعدادي'),
              onTap: () async {
                await _navigateToSchoolPostSignUpPage(
                    context, AccountType.schstudents);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// navigate to college post signup page with proper user type
Future<void> _navigateToCollegePostSignupPage(
    BuildContext context, String accountType) async {
        print('from inside the specify user type  ' +accountType);
        print('below from insdide above ${AccountType.unistudents}');
  await CachingServices.saveStringField(
      key: 'accountType', value: '$accountType');
      print('after saving cache');
      print('$accountType');
  Navigator.of(context).pushNamed('/college-post-signup');
}

//  navigate to school post signup page with proper user type
Future<void> _navigateToSchoolPostSignUpPage(
    BuildContext context, String accountType) async {
print('from inside the specify user type  ' +accountType);
  await CachingServices.saveStringField(
      key: 'accountType', value: '$accountType');
 print('after saving cache');
  print('$accountType');
  Navigator.of(context).pushNamed('/school-post-signup');
}
