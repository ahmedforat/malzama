

import 'package:flutter/material.dart';
import 'package:malzama/src/features/Signup/High_school_teacher.dart';
import 'package:malzama/src/features/Signup/School_student_signup.dart';
import 'package:malzama/src/features/Signup/college_student_signup.dart';
import 'package:malzama/src/features/Signup/university_teacher.dart';

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

       home: UniversityTeacher(),
     );
   }
 }