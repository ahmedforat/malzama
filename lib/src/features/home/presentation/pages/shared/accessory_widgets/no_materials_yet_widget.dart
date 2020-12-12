import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class NoMaterialYetWidget extends StatelessWidget {
  final VoidCallback onReload;
  final String materialName;

  const NoMaterialYetWidget({
    @required this.onReload,
    @required this.materialName,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: ScreenUtil().setHeight(180),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Text('No $materialName available yet'),
            SizedBox(
              height: ScreenUtil().setHeight(150),
            ),
            RaisedButton(
              onPressed: onReload,
              child: Text('Reload'),
            )
          ],
        ),
      ),
    );
  }
}
