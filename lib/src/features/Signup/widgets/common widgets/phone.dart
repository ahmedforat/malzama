import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/validators/signup_login_validators.dart';


class PhoneNumberWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;
  PhoneNumberWidget({@required this.controller,@required this.focusNode,@required this.otherFocusNodes});
  @override
  _PhoneNumberWidgetState createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    print('phone rebuilding');
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
          return FieldsValidators.vaildatePhoneNumber(phoneNumber:widget.controller.text);
        },
          focusNode: widget.focusNode,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: "PhoneNumber",
            labelStyle: TextStyle(
              color: Colors.black87,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.number),
    );
  }
}
