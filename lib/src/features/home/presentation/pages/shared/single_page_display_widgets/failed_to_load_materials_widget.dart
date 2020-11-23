
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';
import '../../lectures_pages/state/pdf_state_provider.dart';


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
                Provider.of<UserInfoStateProvider>(context,listen:false).fetchQuizesCount();

                if (isVideo) {
                  // TODO: To Be Implemented Later On
                } else {
                  PDFStateProvider pdfState = Provider.of<PDFStateProvider>(context,listen: false);
                  pdfState.fetchInitialData();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
