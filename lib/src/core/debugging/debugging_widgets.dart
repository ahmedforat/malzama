import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DebugTools {
  static void showErrorMessageWidget(
      {@required BuildContext context, @required String message}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => _ErrorMessageWidget(
              errorMessage: message,
            )));
  }

  static void showSuccessMessageWidget({@required BuildContext context,String message}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => _SuccessMessageWidget(message)));
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
        color: Colors.redAccent,
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Oops!!',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            Text(
              this.errorMessage,
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

// show success message in a separate page
class _SuccessMessageWidget extends StatelessWidget {

  String message;
  _SuccessMessageWidget(this.message);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon:Text('signup'),
            onPressed: (){
              Navigator.of(context).pushNamed('/landing-page');
            },
          )
        ],
      ),
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
              message??'Your registration is done!',
              style: TextStyle(fontSize: 30.0, color: Colors.white),
            ),
          ]),
        ),
      ),
    );
  }
}


