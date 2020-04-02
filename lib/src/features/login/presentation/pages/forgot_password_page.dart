import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/style/colors.dart';
import '../widgets/email_widget.dart';

class ForgotPasswordPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(250),
                ),
                Text('Reset your password',
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(50),
                            color: MalzamaColors.appBarColor))),
                SizedBox(height: ScreenUtil().setHeight(230)),
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(30)),
                  child: EmailLoginWidget(),
                ),
                SizedBox(),
                SizedBox(
                  height: ScreenUtil().setHeight(150),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: ScreenUtil().setWidth(280),
                    child: RaisedButton(
                      onPressed: () {
                        if (FocusScope.of(context).hasFocus) {
                          FocusScope.of(context).unfocus();
                        }
                        if (formKey.currentState.validate()) {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.indigo,
                              content: Text(
                                'email:${EmailLoginWidget.email}',
                                style: TextStyle(color: Colors.white),
                              )));
                        }
                      },
                      color: MalzamaColors.appBarColor,
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
