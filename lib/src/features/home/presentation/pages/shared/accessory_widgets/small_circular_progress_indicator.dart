import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SmallCircularProgressIndicator extends StatelessWidget {
  const SmallCircularProgressIndicator();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SizedBox(
      width: ScreenUtil().setWidth(50),
      height: ScreenUtil().setHeight(50),
      child: CircularProgressIndicator(),
    )
    ;
  }
}
