// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
//
//
// class CollegeStudent extends StatefulWidget {
//   @override
//   _CollegeStudentState createState() => _CollegeStudentState();
// }
//
// class _CollegeStudentState extends State<CollegeStudent> {
//   final _formKey = GlobalKey<FormState>();
//   var name = TextEditingController();
//
//
//   String _name;
//
//   String _mySelection;
//   String _mySelection1;
//   String _mySelection2;
//   String _mySelection3;
//   String _mySelection4;
//   List<Map> _myJason = [
//     {
//       "id" : 0,
//       "image":"assets/12.jpg",
//       "name": "University of baghdad1"
//     },
//     {
//       "id" : 1,
//       "image":"assets/12.jpg",
//       "name": "University of baghdad2"
//     },
//     {
//       "id" : 2,
//       "image":"assets/12.jpg",
//       "name": "University of baghdad3"
//     },  {
//       "id" :3,
//       "image":"assets/12.jpg",
//       "name": "University of baghdad4"
//     },
//     {
//       "id" : 4,
//       "image":"assets/12.jpg",
//       "name": "University of baghdad5"
//     }
//   ];
//   List<Map> _myJason1 = [
//     {
//       "id" : 0,
//       "image":"assets/12.jpg",
//       "name": "FIRST"
//     },
//     {
//       "id" : 1,
//       "image":"assets/12.jpg",
//       "name": "SECOND"
//     },
//     {
//       "id" : 2,
//       "image":"assets/12.jpg",
//       "name": "THIRD"
//     },  {
//       "id" :3,
//       "image":"assets/12.jpg",
//       "name": "FORTH"
//     },
//     {
//       "id" : 4,
//       "image":"assets/12.jpg",
//       "name": "FIFTH"
//     }
//   ];
//   List<Map> _myJason2 =[
//     {
//       "id" : 0,
//       "image":"assets/12.jpg",
//       "name": "male"
//     },
//     {
//       "id" : 1,
//       "image":"assets/12.jpg",
//       "name": "Female"
//     },
//
//   ];
//   List<Map> _myJason3 =[
//     {
//       "id" : 0,
//       "image":"assets/12.jpg",
//       "name": "level1"
//     },
//     {
//       "id" : 1,
//       "image":"assets/12.jpg",
//       "name": "level2"
//     },
//     {
//       "id" : 1,
//       "image":"assets/12.jpg",
//       "name": "level3"
//     },
//     {
//       "id" : 1,
//       "image":"assets/12.jpg",
//       "name": "level4"
//     },
//
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff696b9e),
//         title: Text("malzama"),
//       ),
//       body: SafeArea(child: Container(
//         color: Colors.white70,
//         child: Padding(padding: EdgeInsets.only(
//           right: 10,
//           left: 10,
//           top: 10,
//         ),
//             child: SingleChildScrollView(
//               child: Container(
//                 margin: EdgeInsets.only(
//                   top: 20,
//                   bottom: 100,
//                 ),
//                 child: Form(
//
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Container(
//                           margin: EdgeInsets.only(bottom: 10,),
//                           child: TextFormField(
//
//
//                             decoration: InputDecoration(
//                                 labelText:  "your name",
//                                 labelStyle: TextStyle(
//                                     color: Colors.black87
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10)
//                                 ),
//                                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
//
//                             ),))
//
//
//
//
//                       ,TextFormField(
//
//                           decoration: InputDecoration(
//                               labelText: "phone number",
//                               labelStyle: TextStyle(
//                                 color: Colors.black87,
//                               ),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10)
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10)
//                               )
//
//                           ),
//
//                           keyboardType: TextInputType.number
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                             border: Border.all(width: 1,color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Expanded(child: DropdownButtonHideUnderline(child: ButtonTheme(
//                               alignedDropdown: true,
//                               child: DropdownButton<String>(
//                                 isDense: true,
//                                 hint: new Text("select university"),
//                                 value: _mySelection,
//                                 onChanged: (String newValue){
//                                   setState(() {
//                                     _mySelection = newValue;
//
//                                   });
//                                   print (_mySelection);
//                                 },
//                                 items: _myJason.map((Map map){
//                                   return new DropdownMenuItem<String>(
//                                     value: map["name"].toString(),
//
//                                     child: Row (
//                                       children: <Widget>[
//                                         Image.asset(map[
//                                         "image"],width: 25,),
//                                         Container(
//                                           margin: EdgeInsets.only(left: 10),
//                                           child: Text(map["name"]),
//                                         ),
//
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//
//                               ),
//                             )))
//                           ],
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                             border: Border.all(width: 1,color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Expanded(child: DropdownButtonHideUnderline(child: ButtonTheme(
//                               alignedDropdown: true,
//                               child: DropdownButton<String>(
//                                 isDense: true,
//                                 hint: new Text(" College Type"),
//                                 value: _mySelection1,
//                                 onChanged: (String newValue){
//                                   setState(() {
//                                     _mySelection1 = newValue;
//
//                                   });
//                                   print (_mySelection1);
//                                 },
//                                 items: _myJason1.map((Map map){
//                                   return new DropdownMenuItem<String>(
//                                     value: map["name"].toString(),
//
//                                     child: Row (
//                                       children: <Widget>[
//                                         Image.asset(map[
//                                         "image"],width: 25,),
//                                         Container(
//                                           margin: EdgeInsets.only(left: 10),
//                                           child: Text(map["name"]),
//                                         ),
//
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             )
//
//                             )
//
//                             ),
//
//                           ],
//
//                         ),
//
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                             border: Border.all(width: 1,color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Expanded(child: DropdownButtonHideUnderline(child: ButtonTheme(
//                               alignedDropdown: true,
//                               child: DropdownButton<String>(
//                                 isDense: true,
//                                 hint: new Text("select section"),
//                                 value: _mySelection2,
//                                 onChanged: (String newValue){
//                                   setState(() {
//                                     _mySelection2 = newValue;
//
//                                   });
//                                   print (_mySelection2);
//                                 },
//                                 items: _myJason1.map((Map map){
//                                   return new DropdownMenuItem<String>(
//                                     value: map["name"].toString(),
//
//                                     child: Row (
//                                       children: <Widget>[
//                                         Image.asset(map[
//                                         "image"],width: 25,),
//                                         Container(
//                                           margin: EdgeInsets.only(left: 10),
//                                           child: Text(map["name"]),
//                                         ),
//
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             )
//
//                             )
//
//                             ),
//
//                           ],
//
//                         ),
//
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                             border: Border.all(width: 1,color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Expanded(child: DropdownButtonHideUnderline(child: ButtonTheme(
//                               alignedDropdown: true,
//                               child: DropdownButton<String>(
//                                 isDense: true,
//                                 hint: new Text("select level"),
//                                 value: _mySelection3,
//                                 onChanged: (String newValue){
//                                   setState(() {
//                                     _mySelection3 = newValue;
//
//                                   });
//                                   print (_mySelection3);
//                                 },
//                                 items: _myJason3.map((Map map){
//                                   return new DropdownMenuItem<String>(
//                                     value: map["name"].toString(),
//
//                                     child: Row (
//                                       children: <Widget>[
//                                         Image.asset(map[
//                                         "image"],width: 25,),
//                                         Container(
//                                           margin: EdgeInsets.only(left: 10),
//                                           child: Text(map["name"]),
//                                         ),
//
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//
//                               ),
//                             )))
//                           ],
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                             border: Border.all(width: 1,color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Expanded(child: DropdownButtonHideUnderline(child: ButtonTheme(
//                               alignedDropdown: true,
//                               child: DropdownButton<String>(
//                                 isDense: true,
//                                 hint: new Text("Gender"),
//                                 value: _mySelection4,
//                                 onChanged: (String newValue){
//                                   setState(() {
//                                     _mySelection4 = newValue;
//
//                                   });
//                                   print (_mySelection4);
//                                 },
//                                 items: _myJason2.map((Map map){
//                                   return new DropdownMenuItem<String>(
//                                     value: map["name"].toString(),
//
//                                     child: Row (
//                                       children: <Widget>[
//                                         Image.asset(map[
//                                         "image"],width: 25,),
//                                         Container(
//                                           margin: EdgeInsets.only(left: 10),
//                                           child: Text(map["name"]),
//                                         ),
//
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//
//                               ),
//                             )))
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 60.0),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: RaisedButton(
//                           padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
//                           color: Color(0xfff29a94),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(30.0),
//                                   bottomLeft: Radius.circular(30.0))),
//                           onPressed: () {
//
//                           },
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Text(
//                                 "Sign up".toUpperCase(),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16.0),
//                               ),
//                               const SizedBox(width: 40.0),
//                               Icon(
//                                 FontAwesomeIcons.arrowRight,
//                                 size: 18.0,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//
//
//                     ],
//
//                   ),
//                 ),
//               ),
//             )
//         ),
//
//       )),
//     );
//   }
// }
