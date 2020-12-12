import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dialog_service.dart';
import 'service_locator.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({this.child});

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService dialogService = locator.get<DialogService>();

  @override
  void initState() {
    print('initializing the service locator');

    dialogService.registerCloseDialogListner(_closeDialog);

    dialogService.registerShowDialogOfSuccess(showDialogOfSuccess);

    dialogService.registerShowDialogOfFailure(showDialogOfFailure);

    dialogService.registerShowDialogOfUploading(showDialogOfUploading);

    dialogService.registerShowDialogOfLoading(showDialogOfLoading);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  GlobalKey<FormState> formKey;

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  Future<void> showDialogOfSuccess({@required String message}) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(100),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1)),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  if (message != null)
                    Align(
                      alignment: Alignment.center,
                      child: Text(message),
                    ),
                ],
              ),
            )));
  }

  Future<void> showDialogOfFailure({String message}) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogWrapper(
            closingCallback: () => dialogService.completeAndCloseDialog(null),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(15)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.error_outline, size: ScreenUtil().setSp(100)),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Text('Oops!!'),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  Container(
                      constraints: BoxConstraints(),
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () => dialogService.completeAndCloseDialog(null),
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )));
  }

  Widget dialogWrapper({Function closingCallback, Widget child}) {
    return WillPopScope(
      child: child,
      onWillPop: () {
        closingCallback();
        return Future.value(false);
      },
    );
  }

  void showDialogOfUploading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialogWrapper(
        closingCallback: () {},
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
          ),
          child: Container(
            height: ScreenUtil().setHeight(400),
            padding: EdgeInsets.all(ScreenUtil().setSp(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: ScreenUtil().setHeight(50)),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Uploading ... please wait',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(50)),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDialogOfLoading({String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialogWrapper(
        closingCallback: () {},
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
          ),
          child: Container(
            height: ScreenUtil().setHeight(400),
            padding: EdgeInsets.all(ScreenUtil().setSp(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: ScreenUtil().setHeight(50)),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${message ?? 'Loading'}... please wait',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(50)),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
