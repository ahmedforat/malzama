import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/api/api_client/clients/profile_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/validators/signup_login_validators.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

class EditPersonalInfoState with ChangeNotifier {
  bool _isUpdating = false;

  bool get isUpdating => _isUpdating;

  void setIsUpdatingTo(bool update) {
    _isUpdating = update;
    notifyMyListeners();
  }

  User userData;

  EditPersonalInfoState() {
    _initializeControllers();
    _initializeState();
  }

  List<String> _errorMessages = List<String>.filled(3, null);

  List<String> get errorMessages => _errorMessages;

  void updateErrorMessage(int pos, String update) {
    if (_errorMessages[pos] != update) {
      _errorMessages[pos] = update;
      notifyMyListeners();
    }
  }

  void _initializeState() {
    userData = locator<UserInfoStateProvider>().userData;
    _firstNameController.text = userData.firstName;
    _lastNameController.text = userData.lastName;
    _emailController.text = userData.email;
  }

  void _initializeControllers() {
    _firstNameController = new TextEditingController();
    _lastNameController = new TextEditingController();
    _emailController = new TextEditingController();
  }

  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;

  TextEditingController get firstNameController => _firstNameController;

  TextEditingController get lastNameController => _lastNameController;

  TextEditingController get emailController => _emailController;

  void onValidate(BuildContext context) {
    _errorMessages[0] = FieldsValidators.validateFirstAndLastName(firstName: _firstNameController.text);
    _errorMessages[1] = FieldsValidators.validateFirstAndLastName(firstName: _lastNameController.text);
    _errorMessages[2] = FieldsValidators.validateEmail(mail: _emailController.text);
    notifyMyListeners();

    if (_errorMessages.every((element) => element == null)) {
      bool isThereAnyChanges = !(userData.firstName == firstNameController.text &&
          userData.lastName == _lastNameController.text &&
          userData.email == _emailController.text);
      if (isThereAnyChanges) {
        _update(context);
      } else {
        Navigator.of(context).pop();
      }
    } else {
      print('nothing');
    }
  }

  Future<void> _update(BuildContext context) async {
    Map<String, dynamic> body = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
    };
    final bool isEmailModified = userData.email != _emailController.text;
    setIsUpdatingTo(true);
    ContractResponse response = await ProfileClient().updatePersonalInfo(isEmailModified: isEmailModified, info: body);
    if (response is Success) {
      if (isEmailModified) {
        print('Email changes');
        setIsUpdatingTo(false);
        var data = await Navigator.of(context, rootNavigator: true).pushNamed<Map<String, dynamic>>(
          RouteNames.VERIFY_NEW_EMAIL,
          arguments: body,
        );
        if (data == null) {
          return;
        }
        if (data['result'] == true) {
          var newToken = data['token'];
          await _saveTokenAndUpdateInfo(context, newToken);
        }
      } else {
        print('no email change and success');
        final payload = json.decode(response.message);
        final token = payload['token'];
        await _saveTokenAndUpdateInfo(context, token);
      }
    } else {
      setIsUpdatingTo(false);
      locator<DialogService>().showDialogOfFailure(message: 'Failed to update data');
    }
  }

  Future<void> _saveTokenAndUpdateInfo(BuildContext context, String token) async {
    final newToken = 'bearer $token';
    await CachingServices.saveStringField(key: 'token', value: newToken);
    var userInfo = locator<UserInfoStateProvider>();
    userInfo.userData.firstName = _firstNameController.text;
    userInfo.userData.lastName = _lastNameController.text;
    userInfo.userData.email = _emailController.text;
    userInfo.updateUserInfo();
    userInfo.notifyMyListeners();
    setIsUpdatingTo(false);
    Navigator.of(context).pop();
    locator<DialogService>().showDialogOfSuccess(message: 'data updated');
  }

  // =========================================================================
  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    print('disposed the state');
    super.dispose();
  }
}
