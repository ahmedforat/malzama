import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../../../../../core/validators/signup_login_validators.dart';


class PasswordWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  PasswordWidget({@required this.controller,@required this.focusNode,@required this.otherFocusNodes});
  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  Widget build(BuildContext context) {
    print('pwd rebuilding');
    ScreenUtil.init(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(40),
      ),
      child: TextFormField(
        onTap: (){
          widget.otherFocusNodes.forEach((node){
            node.unfocus();
          });
        },
        validator: (val){
          return FieldsValidators.validatePassword(password: widget.controller.text);
        },
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.black87),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
        ),
      ),
    );
  }
}
