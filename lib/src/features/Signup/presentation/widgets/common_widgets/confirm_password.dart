import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/common_widgets_state_provider.dart';

class ConfirmPassword extends StatelessWidget {
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  ConfirmPassword({@required this.focusNode, @required this.otherFocusNodes});

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommonWidgetsStateProvider state = Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    return Container(
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setHeight(40),
        ),
        child: TextFormField(
          onTap: () => otherFocusNodes.forEach((node) => node.unfocus()),
          validator: (val) {
            return state.passwordMatchingMessage;
          },
          onChanged: (val) {
            state.updateConfirmPassword(update: val);
          },
          focusNode: focusNode,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            suffixIcon: state.confirmPassword == null
                ? null
                : state.confirmPassword == state.password
                ? Icon(
              Icons.check,
              color: Colors.green,
            )
                : Icon(
              Icons.clear,
              color: Colors.red,
            ),

            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: Colors.black87),


            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ScreenUtil().setSp(15),
              ),
            ),
          ),
        ));
  }
}
