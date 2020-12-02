import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/models/materials/college_material.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/video_state_provider.dart';
import 'package:provider/provider.dart';

class CollegeVideoInfoOverlayWidget extends StatelessWidget {
  final int pos;

  CollegeVideoInfoOverlayWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    TextStyle _textStyle = TextStyle(fontSize: ScreenUtil().setSp(40), fontWeight: FontWeight.bold, color: Colors.white);
    VideoStateProvider videoStateProvider = Provider.of<VideoStateProvider>(context, listen: false);
    CollegeMaterial studyMaterial = videoStateProvider.materials[pos];

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
            padding: EdgeInsets.only(
              left: ScreenUtil().setSp(300),
              right: ScreenUtil().setSp(300),
              bottom: ScreenUtil().setSp(50),
            ),
            child: Container(
              height: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(25)),
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
                      studyMaterial.title,
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
                      'Published in: ${studyMaterial.postDate.substring(0, 10)}',
                      style: _textStyle,
                    ),
                  ),
                  if (studyMaterial.lastUpdate != null)
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setSp(30),
                        bottom: ScreenUtil().setSp(100),
                      ),
                      child: Text(
                        'Last Update: ${studyMaterial.lastUpdate.substring(0, 10)}',
                        style: _textStyle,
                      ),
                    ),
                  if (studyMaterial.lastUpdate == null)
                    SizedBox(
                      height: ScreenUtil().setHeight(100),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setSp(30),
                      bottom: ScreenUtil().setSp(100),
                    ),
                    child: Text(
                      studyMaterial.description,
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
                      'By\n${studyMaterial.author.firstName + ' ' + studyMaterial.author.lastName}\n'
                      '${studyMaterial.author.university + '\n' + studyMaterial.author.college}'
                      '${studyMaterial.author.speciality ?? ''}',
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
