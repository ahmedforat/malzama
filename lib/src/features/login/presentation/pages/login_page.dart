import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/debugging/debugging_widgets.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/style/colors.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/execution_state.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/usecases/log_out.dart';

import 'package:malzama/src/features/verify_your_email/presentation/validate_your_account_msg.dart';
import 'package:provider/provider.dart';

import '../widgets/email_widget.dart';
import '../widgets/forgot_password.dart';
import '../widgets/password_widget.dart';

String accountType;

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
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
                Text(
                  'Login',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(80),
                      color: MalzamaColors.appBarColor,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(230)),
                EmailLoginWidget(),
                PasswordLoginWidget(),
                SizedBox(),
                ChooseAccountType(),
                ForgotPasswordWidget(),
                SizedBox(
                  height: ScreenUtil().setHeight(150),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: ScreenUtil().setWidth(280),
                    child: Consumer<ExecutionState>(
                      builder: (context, state, _) => RaisedButton(
                        onPressed: () async {
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus();
                          }

                          if (formKey.currentState.validate()) {
                            state.setLoadingStateTo(true);
                            print(EmailLoginWidget.email + '\n' + PasswordLoginWidget.password);
                            ContractResponse response =
                                await AccessManager.signIn(email: EmailLoginWidget.email, password: PasswordLoginWidget.password,accountType: accountType);
                            state.setLoadingStateTo(false);
                            print(response.statusCode);
                            if (response is SnackBarException) {
                              scaffoldKey.currentState.showSnackBar(getSnackBar(response.message));
                              await Future.delayed(Duration(seconds: 3));
                              if (response is NotValidated) {
                                Navigator.of(context).pushNamed('/validate-account-page');
                              }
                            } else if (response is Success) {
                              await locator<UserInfoStateProvider>().refreshData();
                              Navigator.of(context).pushNamedAndRemoveUntil('/home-page', (_) => false);
                            } else {
                              DebugTools.showErrorMessageWidget(context: context, message: response.message);
                            }
                          }
                        },
                        color: MalzamaColors.appBarColor,
                        child: state.isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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


class ChooseAccountType extends StatefulWidget {
  @override
  _ChooseAccountTypeState createState() => _ChooseAccountTypeState();
}

class _ChooseAccountTypeState extends State<ChooseAccountType> {
  String selectedType;
  Map<String,String> options = {
    'schteachers':'مدرس ثانوية',
    'schstudents':'طالب ثانوية',
    'uniteachers':'استاذ جامعي',
    'unistudents':'طالب جامعي'
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        items: options.entries.map((entry) => DropdownMenuItem(
          child: Text(entry.value),
          value:entry.key,
        ),).toList(),
        onChanged: (val){
          setState(() {
            accountType = val;
            selectedType = options[accountType];
          });
        },
        value: accountType,
        hint: Text('Specify Account Type'),
      ),
    );
  }
}


