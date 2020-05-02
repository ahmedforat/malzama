import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/platform/services/caching_services.dart';
import '../../../core/style/colors.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
     Future.delayed(Duration(milliseconds: 2800),_startLaunching);
  }

  Future<void> _startLaunching() async {
    if (await CachingServices.containsKey(key: 'token')) {
      print(await CachingServices.getField(key: 'token'));
      print('we are here naving to /home-page');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home-page', (Route route) => false);
    } else if (await CachingServices.containsKey(key: 'initial-page')) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          await CachingServices.getField(key: 'initial-page'), (_) => false);
    } else {
//      Navigator.of(context)
//      pushNamedAndRemoveUntil('/signup-page', (_) => false);
    print('we are here naving to /signup-page');
    Navigator.of(context).pushNamedAndRemoveUntil('/signup-page',(_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Malzama',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(50),
                  color: MalzamaColors.appBarColor)),
        ),
      ),
    );
  }
}
