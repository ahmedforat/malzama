import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/api_client/clients/profile_client.dart';
import 'package:malzama/src/core/api/api_client/clients/registration_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

class VerifyNewStateProvider with ChangeNotifier {
  String _errorText;

  String get errorText => _errorText;

  void onChange(String d) {
    if (_errorText != null) {
      _errorText = null;
      notifyMyListener();
    }
  }

  Map<String, dynamic> _data;

  TextEditingController _authCodeController;

  TextEditingController get authCodeController => _authCodeController;

  VerifyNewStateProvider(Map<String, dynamic> data) {
    _data = data;
    _authCodeController = new TextEditingController();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setIsLoadingTo(bool update) {
    _isLoading = update;
    notifyMyListener();
  }

  // ======================================================================================================================================
  bool _isAskingForNewCode = false;

  bool get isAskingForNewCode => _isAskingForNewCode;

  void setIsAskingForNewCode(bool update) {
    _isAskingForNewCode = update;
    notifyMyListener();
  }

  // ======================================================================================================================================

  Future<void> verify(BuildContext context) async {
    _errorText = _validateAuthCode();
    if (_errorText != null) {
      notifyMyListener();
      return;
    }
    setIsLoadingTo(true);
    ContractResponse response = await ProfileClient().verifyAndUpdateInfo(authCode: _authCodeController.text, info: _data);
    var payload = json.decode(response.message);
    if (response is Success) {
      var newToken = payload['token'];
      Navigator.of(context, rootNavigator: true).pop<Map<String, dynamic>>({'result': true, 'token': newToken});
    } else {
      setIsLoadingTo(false);
      await Future.delayed(Duration(milliseconds: 200));
      var message = payload['message'];
      showSnackBar(message, 4);
    }
  }

// ======================================================================================================================================

  String _validateAuthCode() {
    if (_authCodeController.text == null || _authCodeController.text.isEmpty) {
      return 'please enter the 6 digits code';
    }
    if (_authCodeController.text.length !=  6) {
      return 'the authcode must be 6 digits long';
    }

    try {
      int.parse(_authCodeController.text.toString());
      return null;
    } catch (err) {
      return 'auth code should consists of numbers only';
    }
  }

// ======================================================================================================================================

  Future<void> sendMeCodeAgain() async {
    setIsAskingForNewCode(true);
    final String id = locator<UserInfoStateProvider>().userData.id;
    final String accountType = locator<UserInfoStateProvider>().userData.accountType;
    ContractResponse response = await RegistrationClient().sendMeAuthCodeAgain(id: id, accounType: accountType, email: _data['email']);
    final String message = response is Success ? 'Done: auth code has been sent to ${_data['email']}' : 'something went wrong';
    setIsAskingForNewCode(false);
    await Future.delayed(Duration(milliseconds: 200));
    showSnackBar(message, 4);
  }

// ======================================================================================================================================

  GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool _isSnackBarVisible = false;

  showSnackBar(String message, int seconds) {
    if (_isSnackBarVisible) {
      return;
    }
    _isSnackBarVisible = true;
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds ?? 4),
      ),
    ).closed.then((value) => _isSnackBarVisible = false);
  }

// ======================================================================================================================================
  void notifyMyListener() {
    if (_isDisposed) return;
    notifyListeners();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _authCodeController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
