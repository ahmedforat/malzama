import 'package:flutter/material.dart';
import 'package:malzama/src/core/debugging/wrapper.dart';
import 'package:provider/provider.dart';

class CounterState with ChangeNotifier {
  int _count = 0;
  int get count => _count;

static  CounterState _s;

CounterState();
factory CounterState.instance(){
  if(_s == null){
    _s = new CounterState();
  }
  return _s;
  
}

  @override
  void dispose() {
    print('counterState has been disposed');
    super.dispose();
  }

  void increment() {
    _count++;
    notifyListeners();
  }
}

class TargetState with ChangeNotifier{
  String get message => 'Hello from the state provider';
  @override
  void dispose() {
    print('targetState has been disposed');
    super.dispose();
  }
}

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          children: <Widget>[
            Consumer<CounterState>(
              builder: (context, state, _) =>
                  FloatingActionButton(onPressed: () {
                state.increment();
              }),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/target');
              },
              child: Text('try dispose'),
            )
          ],
        ),
        body: Container(
                  child: Consumer<CounterState>(
            builder: (context, state, _) =>
                Container(child: Center(child: Text(state.count.toString()))),
          ),
        ));
  }
}

class Target extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state  = Provider.of<CounterState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Target Page'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
            child: Text(state._count.toString(), style: TextStyle(fontSize: 30))),

            RaisedButton(
              child: Text('update'),
              onPressed: (){
                state.increment();
              },
            )
          ],
        )
      ),
    );
  }
}
