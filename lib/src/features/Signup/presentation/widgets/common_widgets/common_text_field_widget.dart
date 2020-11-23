import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/common_widgets_state_provider.dart';
import 'package:provider/provider.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final int pos;
  final List<FocusNode> otherFocusNodes;

  final FocusNode focusNode;
  final String text;

  const CommonTextFieldWidget({@required this.pos, @required this.otherFocusNodes, @required this.focusNode, @required this.text});

  @override
  Widget build(BuildContext context) {
    CommonWidgetsStateProvider state = Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(40),
      ),
      child: Selector<CommonWidgetsStateProvider, List>(
        selector: (context, stateProvider) => [stateProvider.errorMessages[pos],stateProvider.hidePassword],
        builder: (context, data, _) => TextField(
          controller: state.textControllers[pos],
          onTap: () {
            otherFocusNodes.forEach(
              (node) {
                node.unfocus();
              },
            );
          },
          onChanged: (_) => state.onChanged(pos),
          focusNode: focusNode,
          obscureText: pos > 2 && data[1],
          decoration: InputDecoration(
            suffix: PasswordVisiblilityWidget(pos),
            errorText: state.errorMessages[pos],
            labelText: text,
            labelStyle: TextStyle(color: Colors.black87),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ScreenUtil().setSp(15),
              ),
            ),
            //focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(15),),borderSide: BorderSide(color: Colors.blueAccent)),
          ),
        ),
      ),
    );
  }
}

class PasswordVisiblilityWidget extends StatelessWidget {
  final int pos;

  const PasswordVisiblilityWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    CommonWidgetsStateProvider commonState = Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    return pos <= 2
        ? SizedBox()
        : Selector<CommonWidgetsStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.hidePassword,
            builder: (context, hidePassword, _) => GestureDetector(
              onTap: commonState.switchPasswordVisibility,
              child: Icon(
                !hidePassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          );
  }
}
