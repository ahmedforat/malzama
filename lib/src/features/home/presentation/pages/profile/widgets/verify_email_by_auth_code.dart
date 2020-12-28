import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/state_provider/verify_new_email_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/small_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class VerifyEmailByAuthCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    VerifyNewStateProvider verifyNewStateProvider = Provider.of<VerifyNewStateProvider>(context, listen: false);
    return SafeArea(
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          key: verifyNewStateProvider.scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(20)),
                    child: IconButton(
                      icon: Icon(
                        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: Navigator.of(context, rootNavigator: true).pop,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(90)),
                    child: Text(
                      'Verify your new email',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(70)),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(200),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(90)),
                    child: Text('Enter the authentication code that we\'ve just sent to'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(90)),
                    child: Text(
                      'k.mohammed1133@gmail.com',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(180),
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(100)),
                    child: Selector<VerifyNewStateProvider, String>(
                      selector: (context, stateProvider) => stateProvider.errorText,
                      builder: (context, errorText, _) => TextField(
                        onChanged: verifyNewStateProvider.onChange,
                        controller: verifyNewStateProvider.authCodeController,
                        maxLength: 6,
                        decoration: InputDecoration(
                          errorText: errorText,
                          labelText: '6 digits code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(400),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(70)),
                    width: ScreenUtil.screenWidth,
                    child: Selector<VerifyNewStateProvider, bool>(
                      selector: (context, stateProvider) => stateProvider.isLoading,
                      builder: (context, isLoading, _) => isLoading
                          ? Center(
                              child:SmallCircularProgressIndicator(),
                            )
                          : RaisedButton(
                              color: Color(0xFF32CD32),
                              child: Text('Verify'),
                              onPressed: () => verifyNewStateProvider.verify(context),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(120),
                  ),
                  Center(
                    child: Text('Didn\'t receive a 6 digits code?'),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Center(
                    child: Selector<VerifyNewStateProvider, bool>(
                      selector: (context, stateProvider) => stateProvider.isAskingForNewCode,
                      builder: (context, isAsking, _) => InkWell(
                        onTap: verifyNewStateProvider.sendMeCodeAgain,
                        child: isAsking
                            ? SmallCircularProgressIndicator()
                            : Text(
                                'Send me again',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
