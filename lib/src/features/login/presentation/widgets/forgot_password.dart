import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          alignment: Alignment.centerRight,
          child: FlatButton(
              onPressed: () {
                // TODO : forgot password implementation
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 1.5, 
                ),
              ))),
    );
  }
}
