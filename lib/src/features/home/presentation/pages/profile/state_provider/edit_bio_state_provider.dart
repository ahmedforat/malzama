import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/api_client/clients/profile_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

class EditBioStateProvider with ChangeNotifier {
  String _title = 'Add new bio';

  String get title => _title;
  String _errorText;

  String get errorText => _errorText;

  TextEditingController _bioController;

  TextEditingController get bioController => _bioController;

  EditBioStateProvider(bool edit, {String bio}) {
    _bioController = new TextEditingController();
    if (edit) {
      _title = 'Edit bio';
      _bioController.text = bio;
    }
  }

  bool _isUpdatingBio = false;

  bool get isUpdatingBio => _isUpdatingBio;

  void setIsUpdatingBio(bool update) {
    _isUpdatingBio = update;
    notifyMyListeners();
  }

  void onChanged(String input) {
    if (_errorText != null) {
      _errorText = null;
      notifyMyListeners();
    }
  }

  Future<void> editBio(BuildContext context) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(milliseconds: 200));
    }
    validateBio();
    User userData = locator<UserInfoStateProvider>().userData;
    if (_errorText != null) {
      return;
    }

    if (_bioController.text.isEmpty || _bioController.text == userData.bio) {
      Navigator.of(context).pop();
      return;
    }

    final update = _bioController.text.isEmpty ? null : _bioController.text;
    setIsUpdatingBio(true);
    ContractResponse response = await ProfileClient().editBio(update: update);
    if (response is Success) {
      locator<UserInfoStateProvider>().userData.bio = update;
      await locator<UserInfoStateProvider>().updateUserInfo();
      setIsUpdatingBio(false);
      await Future.delayed(Duration(milliseconds: 200));
      Navigator.of(context).pop([true, _bioController.text]);
    } else {
      setIsUpdatingBio(false);
      await Future.delayed(Duration(milliseconds: 200));
      locator<DialogService>().showDialogOfFailure(message: 'Failed to update bio');
    }
  }

  void validateBio() {
    _errorText = _bioController.text.length > 130 ? 'Bio msut not be longer than 100 characters' : null;
    notifyMyListeners();
  }

  // ============================================================================
  bool _isDisposed = false;

  void notifyMyListeners() {
    if (_isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _bioController.dispose();
    super.dispose();
  }

// ============================================================================
}
