import 'package:flutter/material.dart';
class BottomNavigationBarWidget extends StatelessWidget {
  final TabController _controller;

  BottomNavigationBarWidget({TabController controller}):_controller = controller;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _controller,
      tabs: <Widget>[
        Tab(
          icon: Icon(Icons.home,color:Colors.black),
        ),
        Tab(
          icon: Icon(Icons.home,color:Colors.black),
        ),
        Tab(
          icon: Icon(Icons.notifications,color:Colors.black),
        ),
        Tab(
          icon: Icon(Icons.account_circle,color:Colors.black),
        ),
      ],
    );
  }
}
