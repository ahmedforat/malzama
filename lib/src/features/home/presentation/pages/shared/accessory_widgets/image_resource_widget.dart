import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageResourceWidget extends StatelessWidget {
  final PageController _pageController;

  const ImageResourceWidget(this._pageController);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          GestureDetector(
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            ),
            onTap: () => _pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          Text(
            'Choose Image Resource',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(50),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(250),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop('camera'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_sharp,
                      size: ScreenUtil().setSp(120),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Text('Camera'),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop('gallery'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo,
                      size: ScreenUtil().setSp(120),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Text('Gallery'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
