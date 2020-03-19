

import 'package:flutter/material.dart';

import 'login.dart';
import 'src/features/specify_user_type/specify_user_type.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
 class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,

       home: SpecifyUserTypeWidget(),
     );
   }
 }