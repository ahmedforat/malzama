import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/video_state_provider.dart';
import 'package:provider/provider.dart';

class VideoInfoOverlayWidget extends StatelessWidget {
  final int pos;

  VideoInfoOverlayWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    var text = 'Clinical Pharmacy And Therapeutics Clinical Pharmacy And Therapeutics Clinical Pharmacy And Therapeutics Clinical '
        'Pharmacy And Therapeutics Clinical Pharmacy And Therapeutics Clinical Pharmacy And Therapeutics Clinical Pharmacy And Therapeutics'
        'Clinical Pharmacy And Therapeutics Clinical Pharmacy And Therapeutics Clinical Pharmacy And Therapeutics';
    ScreenUtil.init(context);
    TextStyle _textStyle = TextStyle(fontSize: ScreenUtil().setSp(40), fontWeight: FontWeight.bold, color: Colors.white);
    VideoStateProvider videoStateProvider = Provider.of<VideoStateProvider>(context, listen: false);

    return Container(
      height: ScreenUtil().setHeight(1500),
      padding: EdgeInsets.only(
        left: ScreenUtil().setSp(25),
        right: ScreenUtil().setSp(25),
        top: ScreenUtil().setSp(25),
        bottom: ScreenUtil().setSp(200),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setSp(300),right:ScreenUtil().setSp(300),bottom: ScreenUtil().setSp(50) ),
            child: Container(
              height: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(25))
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(50),
                    ),
                    child: Text(
                      'Clinical Pharmacy And Therapeutics By Ganongs Review of Pharmacology and Pharmaceutical Toxicology',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(60),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(10),
                    ),
                    child: Text(
                      'Published in: 03/09/2021',
                      style: _textStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(100),
                    ),
                    child: Text(
                      'Last Update: 03/09/2021',
                      style: _textStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(100),
                    ),
                    child: Text(
                      text,
                      style: _textStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(100),
                    ),
                    child: Text(
                      text,
                      style: _textStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(100),
                    ),
                    child: Text(
                      text,
                      style: _textStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(20),
                    ),
                    child: Text(
                      'ــــــــــــــــــــــــــــــــــــــــــــــــــ',
                      style: _textStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(20),
                    ),
                    child: Text(
                      'By\nProof Asis Dhiaa Jabbar\nClinical Pharmacy And Therapeutics\nUniversity of Baghdad\nCollege of Pharmacy',
                      style: _textStyle,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
