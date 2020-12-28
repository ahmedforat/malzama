import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/my_saved_and_uploads_contract.dart';

class SavedCommonState extends MySavedAndUploadsCommonState with ChangeNotifier {
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
