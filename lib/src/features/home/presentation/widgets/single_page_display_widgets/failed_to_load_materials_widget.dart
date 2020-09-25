
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pages_navigators/home_page_navigator/home_page_navigator/state/state_getter.dart';
import '../pages_navigators/videos_navigator/state/state_getter.dart';

class FailedToLoadMaterialsWidget extends StatelessWidget {
  final bool isVideo;

  FailedToLoadMaterialsWidget({
    @required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.sentiment_dissatisfied,
              size: ScreenUtil().setSp(180),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Text(
              'Failed to Load ${isVideo ? 'Videos' : 'Lectures'}',
              style: TextStyle(fontSize: ScreenUtil().setSp(50)),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setSp(40)),
              child: Text(
                'It might be the server is not responding '
                'or  the your internet connection is not established\n'
                'make sure you are connected to the internet and try again',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ScreenUtil().setSp(40)),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            RaisedButton(
              child: Text(
                'Reload',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
              onPressed: () async {
                if (isVideo) {
                  final state = getVideosPageStateProvider(context: context, listen: false);
                  state.setIsFetchingTo(true);
                  state.fetchVideos();
                } else {
                  final state = getHomePageStateProvider(context: context, listen: false);
                  state.setIsFetchingTo(true);
                  state.fetchPDFs();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
