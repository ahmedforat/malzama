import 'package:flutter/material.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../notifications.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> notificationsOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
      builder = (context) => NotificationPage();
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
