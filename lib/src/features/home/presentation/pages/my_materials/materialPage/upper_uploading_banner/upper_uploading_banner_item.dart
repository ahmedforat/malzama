import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class UpperUploadingBannerItem extends StatelessWidget {
  final IconData iconData;
  final addPlus;
  final String text;
  final VoidCallback onPressed;
  const UpperUploadingBannerItem({@required IconData icon,bool icon2, this.text,@required this.onPressed}) : iconData = icon,addPlus = icon2;


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ConstrainedBox(
      constraints: BoxConstraints(),
      child: Card(
        color: Colors.white,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.grey.withOpacity(0.2),
            splashColor: Colors.grey.withOpacity(0.28),
            onTap:onPressed,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(20)),
              child: Column(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(140),
                    height: ScreenUtil().setWidth(140),
                    child: SizedBox.expand(
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                              child: Icon(
                            iconData,
                            color: Colors.black,
                            size: ScreenUtil().setSp(100),
                          )),
                          if(addPlus)
                          Positioned.fill(
                            top: ScreenUtil().setSp(25),
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: ScreenUtil().setSp(50),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10),),
                  Text(text??'Un passed text',style: TextStyle(fontSize: ScreenUtil().setSp(33)),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
