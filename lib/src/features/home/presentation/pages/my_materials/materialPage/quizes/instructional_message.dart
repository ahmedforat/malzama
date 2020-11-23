import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class QuizInstructionalMessage extends StatefulWidget {
  @override
  _QuizInstructionalMessageState createState() => _QuizInstructionalMessageState();
}

class _QuizInstructionalMessageState extends State<QuizInstructionalMessage> {
  final String _message = 'The lower number of mcq questions to be uploaded is 10'
      ' also you has the privilege to save any number of mcq questions to the drafts'
      ' and you can later on add to them anothe questions or even edit ,delete or upload them ';
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(25))),
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hint',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            Text(_message),
            CheckboxListTile(
              title: Text('Don\'t show this message again',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
              controlAffinity: ListTileControlAffinity.leading,
              value: isChecked,
              onChanged: (value) {
                print(value);
                setState(() {
                  isChecked = value;
                });
              },
            ),
            SizedBox(height: ScreenUtil().setHeight(100),),
            RaisedButton(
              child: Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop(isChecked);
              },
            ),
          ],
        ),
      ),
    );
  }
}
