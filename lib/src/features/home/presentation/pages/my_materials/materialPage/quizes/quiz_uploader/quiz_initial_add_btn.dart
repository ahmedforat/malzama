import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizInitialAddButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Center(
      child: Container(
        width: ScreenUtil().setWidth(200),
       height: ScreenUtil().setHeight(200),
       decoration: BoxDecoration(
         shape: BoxShape.circle,
         //color: Colors.blueAccent,
         border: Border.all(color: Colors.blueAccent,width: 2.3),
       ),
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 50,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
