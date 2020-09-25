import 'package:flutter/material.dart';
import 'package:malzama/demos/google_map.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/messages_page/messages_page.dart';

Route<dynamic> messagesOnGenerateRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {
    case '/':
      builder = (context) => GoogleMapDemo();
      break;

    case '/view-message':
      builder = (context) => throw UnimplementedError();
      break;

//    default:
//      builder = (context) => Container(
//            color: Colors.white,
//            child: Center(
//              child: Text('Unknown Route ${settings.name}'),
//            ),
//          );
  }

  return MaterialPageRoute(builder: builder);
}
