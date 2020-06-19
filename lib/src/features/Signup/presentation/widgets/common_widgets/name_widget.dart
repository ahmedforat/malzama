import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/validators/signup_login_validators.dart';
import '../../state_provider/common_widgets_state_provider.dart';

class FirstNameWidget extends StatelessWidget {
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  FirstNameWidget({@required this.focusNode, @required this.otherFocusNodes});

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommonWidgetsStateProvider state = Provider.of<CommonWidgetsStateProvider>(context);
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
            state.updateFirstName(update: val);
          },
          focusNode: focusNode,
          decoration: InputDecoration(
            suffixIcon: state.firstName == null
                ? null
                : FieldsValidators.validateFirstAndLastName(firstName: state.firstName) == null
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
            labelText: 'FirstName',
            labelStyle: TextStyle(color: Colors.black87),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
            //focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(15),),borderSide: BorderSide(color: Colors.blueAccent)),
          ),
        ));
  }
}

class LastNameWidget extends StatelessWidget {
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  LastNameWidget({@required this.focusNode, @required this.otherFocusNodes});

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CommonWidgetsStateProvider state = Provider.of<CommonWidgetsStateProvider>(context);
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
            state.updateLastName(update: val);
          },
          focusNode: focusNode,
          decoration: InputDecoration(
            suffixIcon: state.lastName == null
                ? null
                : FieldsValidators.validateFirstAndLastName(firstName: state.lastName) == null
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
            labelText: 'LastName',
            labelStyle: TextStyle(color: Colors.black87),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
          ),
        ));
  }
}
