import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/style/colors.dart';
import '../../../specify_user_type/specify_user_type.dart';
import '../state_provider/common_widgets_state_provider.dart';
import '../widgets/common%20widgets/email.dart';
import '../widgets/common%20widgets/name_widget.dart';
import '../widgets/common%20widgets/password.dart';
import '../widgets/common%20widgets/phone.dart';
import '../widgets/common%20widgets/select_gender_widget.dart';
import '../widgets/common%20widgets/select_province_widget.dart';

class CommonSignupPage extends StatefulWidget {
  @override
  _CommonSignupPageState createState() => _CommonSignupPageState();
}

class _CommonSignupPageState extends State<CommonSignupPage> {
  // controllers
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneController;

// focusNodes

  FocusNode firstNameNode;
  FocusNode lastNameNode;
  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode phoneNode;

  GlobalKey<FormState> formKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  List<FocusNode> allFocusNodes;

  @override
  void initState() {
    formKey = new GlobalKey<FormState>();
    scaffoldKey = new GlobalKey<ScaffoldState>();

    firstNameController = new TextEditingController();
    lastNameController = new TextEditingController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    phoneController = new TextEditingController();

    firstNameNode = new FocusNode();
    lastNameNode = new FocusNode();
    emailNode = new FocusNode();
    passwordNode = new FocusNode();
    phoneNode = new FocusNode();

    allFocusNodes = [
      firstNameNode,
      lastNameNode,
      emailNode,
      passwordNode,
      phoneNode
    ];

    super.initState();
  }

  @override
  void dispose() {
    print(
        '***********************************************************************************this page has been disposed');
    // dispose controllers
    allFocusNodes = null;

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();

    // dispose focusNodes
    firstNameNode.dispose();
    lastNameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    phoneNode.dispose();

    super.dispose();
  }

  void _filltheBlanks() {
    firstNameController.text = 'Karrar';
    lastNameController.text = 'Mohammed';
    emailController.text = 'karrar@gmail.com';
    passwordController.text = '07718239773';
    phoneController.text = '07718239773';
  }

  void _clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

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
        onTap: _unfocusAllNodes,
        child: Container(
          color: Colors.white70,
          child: Padding(
              padding: EdgeInsets.only(
                right: ScreenUtil().setSp(60),
                left: ScreenUtil().setSp(60),
                top: ScreenUtil().setSp(20),
              ),
              child: SingleChildScrollView(
                child: Form(
                    key: formKey,
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
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(250),
                                child: IconButton(
                                  icon: Text('Fill Fields'),
                                  onPressed: _filltheBlanks,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(250),
                                child: IconButton(
                                  icon: Text('clear Fields'),
                                  onPressed: _clearFields,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(45),
                        ),
                        NameWidget(
                            text: 'FirstName',
                            controller: firstNameController,
                            focusNode: firstNameNode,
                            otherFocusNodes: allFocusNodes
                                .where((node) => node != firstNameNode)
                                .toList()),
                        NameWidget(
                          text: 'LastName',
                          controller: lastNameController,
                          focusNode: lastNameNode,
                          otherFocusNodes: allFocusNodes
                              .where((node) => node != lastNameNode)
                              .toList(),
                        ),
                        EmailWidget(
                            controller: emailController,
                            focusNode: emailNode,
                            otherFocusNodes: allFocusNodes
                                .where((node) => node != emailNode)
                                .toList()),
                        PhoneNumberWidget(
                            controller: phoneController,
                            focusNode: phoneNode,
                            otherFocusNodes: allFocusNodes
                                .where((node) => node != phoneNode)
                                .toList()),
                        PasswordWidget(
                            controller: passwordController,
                            focusNode: passwordNode,
                            otherFocusNodes: allFocusNodes
                                .where((node) => node != passwordNode)
                                .toList()),
                        SelectCityWidget(),
                        SelectGenderWidget(),
                        SizedBox(
                          height: ScreenUtil().setHeight(80),
                        ),
                        SizedBox(
                          width: 140.0,
                          height: 40.0,
                          child: RaisedButton(
                              onPressed: () => _onPressed(context),
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
                    )),
              )),
        ),
      )),
    );
  }

  void _navigateToSpecifyAccountType(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SpecifyUserTypeWidget()));
  }

  void _unfocusAllNodes() {
    if (firstNameNode != null) firstNameNode.unfocus();

    if (lastNameNode != null) lastNameNode.unfocus();

    if (emailNode != null) emailNode.unfocus();

    if (passwordNode != null) passwordNode.unfocus();

    if (phoneNode != null) phoneNode.unfocus();
  }

  void _onPressed(BuildContext context) {
    CommonWidgetsStateProvider commonState =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    if (formKey.currentState.validate()) {
      if (commonState.gender == null || commonState.province == null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(commonState.gender == null
              ? 'Please gender is required'
              : 'Please your city is required'),
          duration: Duration(seconds: 3),
        ));
      } else {
        updateState(state: commonState);
        _navigateToSpecifyAccountType(context);
      }
    }
  }

  void updateState({CommonWidgetsStateProvider state}) {
    state.updateEmail(update: emailController.text);
    state.updateFirstName(update: firstNameController.text);
    state.updateLastName(update: lastNameController.text);
    state.updatePassword(update: passwordController.text);
    state.updatePhone(update: phoneController.text);
  }
}
