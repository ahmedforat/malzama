import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/validators/signup_login_validators.dart';
import '../../state_provider/common_widgets_state_provider.dart';

class NameWidget extends StatelessWidget {
  final String text;
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  NameWidget(
      {@required this.text,
      @required this.focusNode,
      @required this.otherFocusNodes});

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommonWidgetsStateProvider state =
        Provider.of<CommonWidgetsStateProvider>(context);
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
            return FieldsValidators.validateFirstAndLastName(firstName: val);
          },
          onChanged: (val) {
            text == 'FirstName'
                ? state.updateFirstName(update: val)
                : state.updateLastName(update: val);
          },
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(color: Colors.black87),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
          ),
        ));
  }
}
