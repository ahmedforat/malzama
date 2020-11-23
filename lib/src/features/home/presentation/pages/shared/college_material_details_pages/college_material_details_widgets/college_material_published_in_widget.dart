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
        publishingDate ??'Published in: 22/08/2050',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(35),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
