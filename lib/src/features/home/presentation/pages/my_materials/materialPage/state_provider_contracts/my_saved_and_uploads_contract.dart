import 'package:flutter/cupertino.dart';

abstract class MySavedAndUploadsCommonState {
  // ==========================================================================
  // Change the Color of the TabBar singel tab color when the tabIndex get changed

  int get currentTabIndex;

  void updateCurrentTabIndx(int update);

  // ==========================================================================

  PageController get pageController;

  // ==========================================================================

  void onPageChange(int index);

  // ==========================================================================

  Future<void> animateToPage(int index) async {
    pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

// ==========================================================================

  void notifiyMyListeners();
}
