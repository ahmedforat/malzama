import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DebugTools {
  static void showErrorMessageWidget(
      {@required BuildContext context, @required String message}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => _ErrorMessageWidget(
              errorMessage: message,
            )));
  }

  static void showSuccessMessageWidget({@required BuildContext context}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => _SuccessMessageWidget()));
  }
}


// show error message in a separate page
class _ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;
  _ErrorMessageWidget({@required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Text(
          this.errorMessage,
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
    );
  }
}


// show success message in a separate page
class _SuccessMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.green,
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          width: MediaQuery.of(context).size.width,
          child: Column(children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(200),
            ),
            SizedBox(
                width: ScreenUtil().setWidth(1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Malzama',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(30),
                    ),
                    FaIcon(
                      FontAwesomeIcons.book,
                      color: Colors.white,
                    ),
                  ],
                )),
            SizedBox(
              height: ScreenUtil().setHeight(300),
            ),
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: ScreenUtil().setSp(150),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Text(
              'Your registration is done!',
              style: TextStyle(fontSize: 30.0, color: Colors.white),
            ),
          ]),
        ),
      ),
    );
  }
}
