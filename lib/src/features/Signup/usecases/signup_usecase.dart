import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/api/contract_response.dart';
  

import '../../../core/api/routes.dart';
import '../../../core/platform/network_info.dart';
import '../../../core/references/references.dart';


class ExecutionState with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoadingStateTo(bool update) {
    _isLoading = update;
    notifyListeners();
  }
}


class SignUpNewUser {
  String _url;
  Map<String, String> user;
  Map<String, String> _header = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  http.Response response;
  var recievedData;

  SignUpNewUser({@required this.user}) {
    _url = Api.getSuitableUrl(accountType: user['account_type'],fromCloud: false ) + '/signup';
  }

  Future<ContractResponse> execute() async {
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      // check whether the device is connected to internet
      return NoInternetConnection();
    }
    try {
      // initiate http request , Method = POST
      response = await http
          .post(Uri.encodeFull(_url),
              headers: _header, body: json.encode(this.user))
          .timeout(References.timeout);

      switch (response.statusCode) {
        case 208: // already reported  208
          return AlreadyReported(
              message: 'Email you entered is already in use!');
          break;
        case 500: // internal server error 500
          return InternalServerError();
          break;
        case 201:
          return Success201(
              // created , 201
              message: 'your account has been created successfully');
          break;
        default: // unexpected status code
          return NewBugException(
            statusCode: response.statusCode,
            message: 'unhandled status code ${response.statusCode}',
          );
      }
    } on TimeoutException {
      // when the timeout duration (12 seconds) has passed without any returned response
      return ServerNotResponding(); //  service unavailable 503
    } catch (err) {
      return NewBugException(message: err.toString()); // bug!
    }
  }
}
