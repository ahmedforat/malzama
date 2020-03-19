import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'ListVeiw.dart';
import 'quiz_app/home.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selcteditem =0;
  int currentIndex =0;
  var _pages =[BlogHomeOnePage(),BlogHomeOnePage(),BlogHomeOnePage(),QuizHomePage()];
  var _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff696b9e),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
        title: Text("malzama"),
      ),
      body:
        PageView(
          children: _pages,
          onPageChanged: (index){
            setState(() {
              _selcteditem = index;
            });
          },
          controller: _pageController,
        )
      ,bottomNavigationBar: CurvedNavigationBar(
      index: _selcteditem
      ,backgroundColor: Color(0xfff29a94),
        height: 50.0,
        items: <Widget>[
          Icon(Icons.book, size: 20),
          Icon(Icons.video_library, size: 20),
          Icon(Icons.library_books, size: 20),
          Icon(Icons.calendar_today, size: 20),
        ],


        onTap: (index) {
          setState(() {
              _selcteditem = index;
              _pageController.animateToPage
                (_selcteditem, duration: Duration(milliseconds: 400),
                  curve: Curves.linear);
          });
          //Handle button tap
        },
      )

    );
  }
}
