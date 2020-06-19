import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/validators/signup_login_validators.dart';
import '../../state_provider/common_widgets_state_provider.dart';

class EmailWidget extends StatelessWidget {
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  EmailWidget({@required this.focusNode, @required this.otherFocusNodes});

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommonWidgetsStateProvider state =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(40),
      ),
      child: TextFormField(
        onTap: () {
          otherFocusNodes.forEach((node) {
            node.unfocus();
          });
        },
        validator: (val) {
          return FieldsValidators.validateEmail(mail: val);
        },
        onChanged: (val) {
          state.updateEmail(update: val);
        },
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          suffixIcon: state.email == null
              ? null
              : FieldsValidators.validateEmail(mail: state.email) == null
              ? Icon(
            Icons.check,
            color: Colors.green,
          )
              : Icon(
            Icons.clear,
            color: Colors.red,
          ),
          labelText: 'Email',
          helperText: state.email == null ? null : FieldsValidators.validateEmail(mail: state.email),


          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
        ),
      ),
    );
  }
}
