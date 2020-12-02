import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SavedCommonState with ChangeNotifier {
  SavedCommonState() {
    _pageController = new PageController();
  }

  // ==========================================================================
  // Change the Color of the TabBar singel tab color when the tabIndex get changed
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void updateCurrentTabIndx(int update) {
    _currentTabIndex = update;
    notifiyMyListeners();
  }

  // ==========================================================================

  PageController _pageController;

  PageController get pageController => _pageController;

  // ==========================================================================

  void onPageChange(int index) {
    updateCurrentTabIndx(index);
  }

  // ==========================================================================

  Future<void> animateToPage(int index) {
    _pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

// ==========================================================================

  bool _isDisposed = false;

  void notifiyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('MySavedStateProvider has been disposed');
    super.dispose();
  }
}
