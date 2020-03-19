


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SpecifyUserTypeWidget extends StatelessWidget {

  void _navigateTo({BuildContext context,String page}){
    Navigator.of(context).pushNamed(page);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('حدد نوع الحساب'),
        ),
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(180)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('استاذ جامعي'),

              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('استاذ اعدادية'),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('طالب جامعي'),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('طالب اعدادي'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
