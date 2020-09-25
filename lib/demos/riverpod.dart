import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RiverPodDemo extends HookWidget{
  @override
  Widget build(BuildContext context) {
    final text = useProvider(riverpodState);
    return Scaffold(
      appBar: AppBar(
        title: Text('$text'),
      ),
      body: Container(

      ),
    );
  }

}

final riverpodState = Provider((_)=> 'hello');
