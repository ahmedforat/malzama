import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/execution_state.dart';
import 'package:malzama/src/features/Signup/usecases/signup_usecase.dart';
import 'package:malzama/src/features/verify_your_email/presentation/send_auth_code_btn.dart';

import 'package:provider/provider.dart';

import '../../../core/api/contract_response.dart';
import '../../../core/debugging/debugging_widgets.dart';
import '../../../core/platform/services/file_system_services.dart';
import '../../../core/style/colors.dart';
import '../usecases/send_auth_code.dart';

int auth_code;
Map _user;

class ValidateYourAccountMessageWidget extends StatelessWidget {


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _fetchUserData() async {
    return  FileSystemServices.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    print('building validation page');
    ScreenUtil.init(context);
    return FutureBuilder(
      future: _fetchUserData(),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        else if (snapshot.hasError)
          return Center(
            child: Text('Something went wrong'),
          );
        else {
          print(snapshot.data);
          _user = snapshot.data;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  print(auth_code);
                  var data = await FileSystemServices.getUserData();
                  print(data);
                },
              ),
              key: scaffoldKey,
              body: Container(
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(colors: [
                //     Color(0xFFada996),
                //     Color(0xFFF2F2F2),
                //     Color(0xFFDBDBDB),
                //     Color(0xFFEAEAEA),
                //   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                // ),

                child: ListView(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(40)),
                      //color: Colors.blueAccent,
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Registration Done!',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(60),
                            //  fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(40)),
                      //color: Colors.blueAccent,
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Verify your email address',
                        style: TextStyle(fontSize: ScreenUtil().setSp(80), fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(40)),
                      //color: Colors.blueAccent,
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Dear ${_user['firstName'] ?? 'user'}',
                        style: TextStyle(fontSize: ScreenUtil().setSp(45), fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(40)),
                      //color: Colors.blueAccent,
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Thank you for registering with us\n\n',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Colors.black,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Enter the code that has just been sent to your email account ( ${_user['email']} ) ',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'to verify your email and then click ',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Colors.black,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'OK.',
                              style: TextStyle(fontSize: ScreenUtil().setSp(40), color: Colors.black, fontWeight: FontWeight.bold,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(30),
                      ),
                      child: digitsHolder(),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Align(
                      child: SendAuthCodeButton(onPressed: _sendAuthCodeOnPressed,),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Center(
                      child: Text('Didn\'t receive an email?'),
                    ),
                    Align(
                      child: FlatButton(
                        child: Text('send me again'),
                        onPressed: () async {
                          ContractResponse response = await ValidationAuthCode(user: _user).sendMeAnotherMail();
                          if (response is SnackBarException) {
                            scaffoldKey.currentState.showSnackBar(getSnackBar(response.message));
                            if (response is AuthorizationBreaking)
                              await Future.delayed(
                                Duration(seconds: 3),
                              );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/landing-page',
                                  (_) => false,
                            );
                          } else if (response is Success) {
                            scaffoldKey.currentState.showSnackBar(
                              getSnackBar('Soon you will receive an email with your authentication code'),
                            );
                          } else {
                            DebugTools.showErrorMessageWidget(context: context, message: response.message);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget digitsHolder() =>
      TextField(
        maxLength: 6,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ScreenUtil().setSp(20),
            ),
          ),
          hintText: 'Enter The Code Here',
        ),
        onChanged: (val) {
          try {
            auth_code = int.parse(val);
          } catch (err) {
            scaffoldKey.currentState.showSnackBar(
              getSnackBar('Please Enter only numbers'),
            );
          }
        },
      );

  Future<void> _sendAuthCodeOnPressed(BuildContext context, ExecutionState state) async {
    if (auth_code == null || auth_code
        .toString()
        .length < 6) {
      scaffoldKey.currentState.showSnackBar(getSnackBar('Please Enter The 6 digits code number'));
      return;
    }

    _user['auth_code'] = auth_code.toString();
    state.setLoadingStateTo(true);
    ContractResponse response;
    response = await ValidationAuthCode(user: _user).send();
    state.setLoadingStateTo(false);
    print('after sending');
    if (response is SnackBarException) {
      scaffoldKey.currentState.showSnackBar(getSnackBar(response.message));

      if (response is AuthorizationBreaking) {
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (_) => false);
      }
    } else if (response is Success) {
      var data = await FileSystemServices.getUserData();
      bool isAcademic = data['account_type'] != 'schteachers' && data['account_type'] != 'schstudents';
      Navigator.of(context).pushNamedAndRemoveUntil('/home-page', (_) => false, arguments: isAcademic);
    } else {
      DebugTools.showErrorMessageWidget(context: context, message: response.message);
    }
    print(auth_code);
  }

}


Widget getSnackBar(String text) =>
    SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: 3000),
    );
