import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YesOrNoAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String text = 'Are You Sure you want to unsave this item';
    final Widget yesButton = RaisedButton(
      child: Text('Yes'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    final Widget noButton = RaisedButton(
      child: Text('No'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
    );

    List<Widget> _actions = [yesButton, noButton];
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(text),
            actions: _actions,
          )
        : CupertinoAlertDialog(
            title: Text(text),
            actions: _actions,
          );
  }
}
