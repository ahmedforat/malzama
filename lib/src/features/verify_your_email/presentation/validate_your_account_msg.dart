import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/signup/presentation/state_provider/college_post_signup_state.dart';
import 'package:malzama/src/features/signup/presentation/state_provider/common_widgets_state_provider.dart';
import 'package:malzama/src/features/signup/presentation/state_provider/school_student_state_provider.dart';
import 'package:malzama/src/features/signup/usecases/signup_usecase.dart';
import 'package:provider/provider.dart';

import '../../../core/api/contract_response.dart';
import '../../../core/debugging/debugging_widgets.dart';
import '../../../core/platform/services/file_system_services.dart';
import '../../../core/style/colors.dart';
import '../usecases/send_auth_code.dart';

class ValidateYourAccountMessageWidget extends StatelessWidget {
  List<FocusNode> _listOfFocusNodes = List.generate(6, (i) => new FocusNode());
  final List<String> auth_code = new List<String>(6);
  Map<String, dynamic> _user;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return FutureBuilder(
      future: FileSystemServices.getUserData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  onPressed: () {
                    print(auth_code);
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
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(80),
                            fontWeight: FontWeight.bold,
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
                        'Dear ${_user['firstName'] ?? ''}',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(45),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(ScreenUtil().setSp(40)),
                        //color: Colors.blueAccent,
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Thank you for registering with us\n\n',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(40),
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Enter the code that has just been sent to your email account ( ${_user['email']} ) ',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                                //fontWeight: FontWeight.bold,
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
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                                //fontWeight: FontWeight.bold,
                                ),
                          ),
                        ]))),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          for (int i = 0; i < _listOfFocusNodes.length; i++)
                            digitHolder(
                                context: context,
                                pos: i,
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setWidth(200))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Align(
                      child: Consumer<ExecutionState>(
                        builder: (context, state, __) => RaisedButton(
                          color: MalzamaColors.appBarColor,
                          child: state.isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: () async {
                            if (auth_code.any((digit) => digit == null)) {
                              scaffoldKey.currentState.showSnackBar(getSnackBar(
                                  'Please fill all the digits fields'));
                              return;
                            }

                            try {
                              auth_code.forEach((digit) => int.parse(digit));
                            } catch (err) {
                              scaffoldKey.currentState.showSnackBar(
                                  getSnackBar('All digits must be numbers!!'));
                              return;
                            }
                            _user['auth_code'] = auth_code.join();
                            print('here is the code' + auth_code.join());
                            print(_user['auth_code']);
                            print('we are here after setting the auth_code');
                            state.setLoadingStateTo(true);
                            ContractResponse response;
                            response =
                                await ValidationAuthCode(user: _user).send();
                            state.setLoadingStateTo(false);
                            print('after sending');
                            if (response is SnackBarException) {
                              scaffoldKey.currentState
                                  .showSnackBar(getSnackBar(response.message));

                              if (response is AuthorizationBreaking) {
                                await Future.delayed(Duration(seconds: 3));
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/signup-page', (_) => false);
                              }
                            } else if (response is Success) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home-page', (_) => false);
                              //Navigator.of(context).pushNamedAndRemoveUntil('/home-page', (_) => false);
                            } else {
                              DebugTools.showErrorMessageWidget(
                                  context: context, message: response.message);
                            }
                            print(auth_code);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Center(child: Text('Didn\'t receive an email?')),
                    Align(
                      child: FlatButton(
                        child: Text('send me again'),
                        onPressed: () async {
                          ContractResponse response =
                              await ValidationAuthCode(user: _user)
                                  .sendMeAnotherMail();
                          if (response is SnackBarException) {
                            scaffoldKey.currentState
                                .showSnackBar(getSnackBar(response.message));
                            if (response is AuthorizationBreaking)
                              await Future.delayed(Duration(seconds: 3));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/landing-page', (_) => false);
                          } else if (response is Success) {
                            scaffoldKey.currentState.showSnackBar(getSnackBar(
                                'Soon you will receive an email with your authentication code'));
                          } else {
                            DebugTools.showErrorMessageWidget(
                                context: context, message: response.message);
                          }
                        },
                      ),
                    )
                  ],
                ))),
          );
        }
      },
    );
  }

  Widget digitHolder(
          {BuildContext context, int pos, double width, double height}) =>
      SizedBox(
        width: width,
        height: height,
        child: TextField(
          onChanged: (val) {
            if (val.isNotEmpty) {
              if (pos != 5) {
                FocusScope.of(context).requestFocus(_listOfFocusNodes[pos + 1]);
              } else {
                FocusScope.of(context).unfocus();
              }
            }
            auth_code[pos] = val;
          },
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          focusNode: _listOfFocusNodes[pos],
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
          ),
        ),
      );
}

Widget getSnackBar(String text) => SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: 3000),
    );
