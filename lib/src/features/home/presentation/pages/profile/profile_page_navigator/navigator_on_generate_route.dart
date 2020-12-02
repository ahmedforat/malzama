import 'package:flutter/material.dart';
import '../user_profile.dart';

Route<dynamic> profileOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) => UserProfilePage();
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
