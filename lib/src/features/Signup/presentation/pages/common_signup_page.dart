import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malzama/src/features/Signup/presentation/widgets/common_widgets/common_text_field_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/platform/services/caching_services.dart';
import '../../../../core/style/colors.dart';
import '../state_provider/common_widgets_state_provider.dart';

import '../widgets/common_widgets/select_gender_widget.dart';
import '../widgets/common_widgets/select_province_widget.dart';

class CommonSignupPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommonWidgetsStateProvider commonState = Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    print('building the entire signup page page');
    return Scaffold(
      key: scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ()async{
      //    var data = await  TelegramClient.createClient();
      //     print('the code must be done');
      //     print(data);
      //   },
      // ),
      body: SafeArea(
          child: GestureDetector(
        onTap: () => _unfocusAllNodes(commonState),
        child: Container(
          color: Colors.white70,
          child: Padding(
              padding: EdgeInsets.only(
                right: ScreenUtil().setSp(60),
                left: ScreenUtil().setSp(60),
                top: ScreenUtil().setSp(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Register new account',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: MalzamaColors.appBarColor,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(300), child: Text('Have an account?')),
                          SizedBox(
                            width: ScreenUtil().setWidth(180),
                            child: IconButton(
                              icon: Text(
                                'Sign in',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/login-page');
                              },
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(45),
                    ),
                    CommonTextFieldWidget(
                      pos: 0,
                      focusNode: commonState.firstNameNode,
                      text: 'First Name',
                      otherFocusNodes: commonState.otherFocusNodesFor(commonState.firstNameNode),
                    ),
                    CommonTextFieldWidget(
                      pos: 1,
                      focusNode: commonState.lastNameNode,
                      text: 'Last Name',
                      otherFocusNodes: commonState.otherFocusNodesFor(commonState.lastNameNode),
                    ),
                    CommonTextFieldWidget(
                      pos: 2,
                      focusNode: commonState.emailNode,
                      text: 'Email',
                      otherFocusNodes: commonState.otherFocusNodesFor(commonState.emailNode),
                    ),
                    CommonTextFieldWidget(
                      pos: 3,
                      focusNode: commonState.passwordNode,
                      text: 'Password',
                      otherFocusNodes: commonState.otherFocusNodesFor(commonState.passwordNode),
                    ),
                    CommonTextFieldWidget(
                      pos: 4,
                      focusNode: commonState.confirmPasswordNode,
                      text: 'Confirm Password',
                      otherFocusNodes: commonState.otherFocusNodesFor(commonState.confirmPasswordNode),
                    ),
                    SelectCityWidget(),
                    SelectGenderWidget(),
                    SizedBox(
                      height: ScreenUtil().setHeight(80),
                    ),
                    SizedBox(
                      width: 140.0,
                      height: 40.0,
                      child: RaisedButton(
                          onPressed: () {
                            CommonWidgetsStateProvider commonState = Provider.of<CommonWidgetsStateProvider>(context, listen: false);
                            _onPressed(context, commonState);
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xff696b9e)),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )),
        ),
      )),
    );
  }

  void _navigateToSpecifyAccountType(BuildContext context) {
    Navigator.of(context).pushNamed('/specify-account-type');
  }

  void _unfocusAllNodes(CommonWidgetsStateProvider commonState) {
    if (commonState.firstNameNode != null) commonState.firstNameNode.unfocus();
    if (commonState.lastNameNode != null) commonState.lastNameNode.unfocus();
    if (commonState.emailNode != null) commonState.emailNode.unfocus();
    if (commonState.passwordNode != null) commonState.passwordNode.unfocus();
    if (commonState.confirmPasswordNode != null) commonState.confirmPasswordNode.unfocus();
  }

  void _onPressed(BuildContext context, CommonWidgetsStateProvider commonState) async {
    if (commonState.validate()) {
      if (commonState.gender == null || commonState.province == null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(commonState.gender == null ? 'Please gender is required' : 'Please your city is required'),
          duration: Duration(seconds: 3),
        ));
      } else {
        updateState(commonState: commonState);
        _navigateToSpecifyAccountType(context);
      }
    }
  }

  void updateState({CommonWidgetsStateProvider commonState}) {
    CachingServices.saveStringField(key: 'commonState', value: json.encode(commonState.fetchDataAsMap()));
  }
}
