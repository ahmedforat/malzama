

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecifySpecialityWidget extends StatefulWidget {
  final TextEditingController controller;

  SpecifySpecialityWidget({@required this.controller});
  @override
  _SpecifySpecialityWidgetState createState() => _SpecifySpecialityWidgetState();
}

class _SpecifySpecialityWidgetState extends State<SpecifySpecialityWidget> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'type here your speciality',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
            )
          ),
        ),
    );
  }
}