import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchoolMaterialPublishedInWidget extends StatelessWidget {
  final String publishingDate ;
  const SchoolMaterialPublishedInWidget({@required this.publishingDate});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
        child: Text(
          publishingDate ??'تاريخ النشر: 22/08/2050',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
