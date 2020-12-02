import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollegeMaterialPublishedInWidget extends StatelessWidget {
final String publishingDate ;
const CollegeMaterialPublishedInWidget({@required this.publishingDate});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
      child: Text(
        'Published in: ${publishingDate.substring(0,10)}',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
