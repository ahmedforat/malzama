
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../../../../../core/validators/signup_login_validators.dart';
class EmailWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  EmailWidget({@required this.controller,@required this.focusNode,@required this.otherFocusNodes});

  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}


class _EmailWidgetState extends State<EmailWidget> {
  Widget build(BuildContext context) {
    print('rebuilding of email');
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
         return FieldsValidators.validateEmail(mail: widget.controller.text);
        },
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.black87),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
        ),
      ),
    );
  }
}
