

import 'package:flutter/foundation.dart';

class TempProvider with ChangeNotifier{
  int count = 0;

  void increment(){
    count++;
    notifyListeners();
  }

  void decrement(){
    if(count > 0){
      count--;
      notifyListeners();
    }
  }
}