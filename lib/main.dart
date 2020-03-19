

import 'package:flutter/material.dart';
import 'package:malzama/pdfpresent.dart';
import 'package:malzama/quiz_app/home.dart';
import 'Cont.login.dart';
import 'ListVeiw.dart';
import 'bottom_navigation_bar.dart';
import 'homepage.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
 class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,

       home: AuthThreePage(),
     );
   }
 }