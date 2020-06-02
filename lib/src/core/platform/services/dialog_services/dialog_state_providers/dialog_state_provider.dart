import 'dart:io';

import 'package:flutter/cupertino.dart';


class DialogStateProvider with ChangeNotifier {
  bool _isLoading = false;
//
  bool get isLoading => _isLoading;

//  void setIsLoadingTo(bool update) {
//    if (update != null) {
//      _isLoading = update;
//      notifyListeners();
//    }
//  }

  File _lecture;

  File get lecture => _lecture;

  void updateLecture(File update) {
    if (update != null) {
      _lecture = update;
      notifyListeners();
    }
  }
}

