import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/core/validators/signup_login_validators.dart';

class PasswordLoginWidget extends StatelessWidget {
  static String password;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Password',icon: FaIcon(FontAwesomeIcons.lock)),
          validator: (pwd) {
            if (pwd == null || pwd.isEmpty)
              return 'Please this field is required';
            else if (pwd.length < 8)
              return 'password must be 8 characters long at least';
            else {
              password = pwd;
              return null;
            }
          },
        ),
      ),
    );
  }
}
