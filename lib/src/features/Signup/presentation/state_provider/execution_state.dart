import 'package:flutter/foundation.dart';

class ExecutionState extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoadingStateTo(bool update) {
    _isLoading = update;
    notifyListeners();
  }
}