import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalSheetTopHolder extends StatelessWidget {
  const ModalSheetTopHolder();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(380)),
      child: Container(
        height: ScreenUtil().setHeight(30),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
        ),
      ),
    );
  }
}
