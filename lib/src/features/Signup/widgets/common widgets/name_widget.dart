import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/validators/signup_login_validators.dart';
import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';
import 'package:provider/provider.dart';

class NameWidget extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<FocusNode> otherFocusNodes;

  NameWidget({@required this.text, @required this.controller,@required this.focusNode,@required this.otherFocusNodes});

  @override
  _NameWidgetState createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  Widget build(BuildContext context) {
    print('${widget.text} rebuilding');
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
          return FieldsValidators.validateFirstAndLastName(firstName: widget.controller.text);
        },
        focusNode: widget.focusNode,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.text,
          labelStyle: TextStyle(color: Colors.black87),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
        ),
      ),
    );
  }
}
