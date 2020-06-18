import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/validators/signup_login_validators.dart';
import '../../state_provider/common_widgets_state_provider.dart';

class PhoneWidget extends StatelessWidget {
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  PhoneWidget({@required this.focusNode, @required this.otherFocusNodes});

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
              return FieldsValidators.vaildatePhoneNumber(phoneNumber: val);
            },
            onChanged: (val) {
              state.updatePhone(update: val);
            },
            focusNode: focusNode,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone',
              labelStyle: TextStyle(color: Colors.black87),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
            ),
          )
    );
  }
}
