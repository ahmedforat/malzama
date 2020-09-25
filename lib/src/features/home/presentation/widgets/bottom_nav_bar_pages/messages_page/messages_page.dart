import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatting'),
      ),
      body: Container(
        child: Center(
          child: Icon(Icons.message),
        ),
      ),
    );
  }
}
