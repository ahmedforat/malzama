import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallCircularProgressIndicator extends StatelessWidget {
  final Color _color;

  // Constructor
  const SmallCircularProgressIndicator({Color color}) : this._color = color ?? Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SizedBox(
      width: ScreenUtil().setWidth(50),
      height: ScreenUtil().setHeight(50),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(_color),
      ),
    );
  }
}
