import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailLoginWidget extends StatelessWidget {
  static String email;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Theme(
          data: Theme.of(context).copyWith(primaryColor: Color(0xFF7f7f7f7f)),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              //border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF70707070),width: 5.5)),
              icon: FaIcon(
                FontAwesomeIcons.userAlt,
              ),

              //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF70707070),width: 3.5))
            ),
            validator: (emailValue) {
              if (emailValue == null || emailValue.isEmpty)
                return 'please this field is required';
              RegExp mailFormat = new RegExp(r'.+@[gmail.com|tyahoo.com]');
              if (!mailFormat.hasMatch(emailValue))
                return 'please provide a valid mail';
              else {
                email = emailValue;
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
