import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/api/contract_response.dart';
import '../../../core/api/routes.dart';
import '../../../core/platform/services/caching_services.dart';
import '../../../core/platform/services/file_system_services.dart';
import '../../../core/platform/services/network_info.dart';
import '../../../core/references/references.dart';

class ValidationAuthCode {
  String _url;

  final Map<String, String> _header = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };
  Map<String, String> _body;
  Map<String, dynamic> _user;

  ValidationAuthCode({Map<String, dynamic> user}) {
    print(user);
    _user =user;
    print('before any thing inside the constructor of the validation authcode');
    _url = Api.getSuitableUrl(accountType: user['account_type']);
    print('after any thing inside the constructor of the validation authcode');

    _body = {'email': user['email'], 'auth_code': user['auth_code']??''};
  }

  Future<ContractResponse> send() async {
    print('hello send');
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    print('after passing over internet checking');
    http.Response response;
    try {
      response = await http
          .post(Uri.encodeFull(_url + '/check-validation'),
              headers: _header, body: json.encode(_body))
          .timeout(References.timeout);

      switch (response.statusCode) {
        case 200:
          var data = json.decode(response.body);
          CachingServices.removeAllAndSave(
              key: 'token', value: 'bearer ${data['token']}');
          _user['validated'] = true;
          await FileSystemServices.saveUserData(_user);
          return Success200();
          break;

        case 500:
          return InternalServerError();
          break;

        case 400:
          return BadRequest(
              message: 'The Code you entered is incorrect\n'
                  'please check your email to get the code we\'ve sent you ');
          break;

        case 404:
          await CachingServices.removeAll();
          await FileSystemServices.deleteUserData();
          return NotFoundAndMustLeave(
              message: 'You are not authorized to access here!');
          break;
        default:
        return NewBugException(message: 'unhandled statusCode ${response.statusCode}');
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      return NewBugException(message: err.toString());
    }
  }

  Future<ContractResponse> sendMeAnotherMail() async {
    try {
      http.Response response = await http
          .post(Uri.encodeFull(_url + '/send-me-another-validation-code'),headers: _header,body: json.encode({'email':_body['email']}))
          .timeout(References.timeout);
      switch (response.statusCode) {
        case 500:
          return InternalServerError();
          break;

        case 404:
          await CachingServices.removeAll();
          await FileSystemServices.deleteUserData();
          return NotFoundAndMustLeave(message: 'You are not authorized to access here!');
          break;
        
        case 200:
          return Success200();
          break;

        default:
          return NewBugException(message: 'Unhandled status code ${response.statusCode}');
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      return NewBugException(message: err.toString());
    }
  }
}
