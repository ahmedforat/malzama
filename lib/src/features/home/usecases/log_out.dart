import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../../core/api/contract_response.dart';
import '../../../core/api/routes.dart';
import '../../../core/platform/services/caching_services.dart';
import '../../../core/platform/services/file_system_services.dart';
import '../../../core/platform/services/network_info.dart';
import '../../../core/references/references.dart';

class AccessManager {
  static Future<ContractResponse> signOut() async {
    bool isConnected = await NetWorkInfo.checkConnection();
    print('we are here signing out .....');
    if (!isConnected) {
      return NoInternetConnection();
    }
    var userdata = await FileSystemServices.getUserData();

    if (userdata is bool) {
      return InternalServerError();
    }

//    if (userdata == null) {
//      await CachingServices.clearAllCachedData();
//      return NotFoundAndMustLeave(message: 'You are not authorized to access here');
//    }
    Response response;
    Map<String, String> _headers = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'authorization': await CachingServices.getField(key: 'token'),
    };

    try {
      response = await post(Uri.encodeFull(Api.LOCALHOST_LOGOUT_URL), headers: _headers, body: json.encode({'email': userdata['email']})).timeout(References.timeout);

      print('this is the status code of the response' + response.statusCode.toString());

      switch (response.statusCode) {
        case 403:
          {
            await CachingServices.clearAllCachedData();
            await FileSystemServices.deleteUserData();
            return ForbiddenAccess(message: 'you are not authorized to access here');
          }

        case 500:
          return InternalServerError();

        case 404:
          {
            await CachingServices.clearAllCachedData();
            await FileSystemServices.deleteUserData();
            return NotFoundAndMustLeave(message: 'you are not authorized to access here');
          }

        case 200:
          {
            print('we are here in 200 status code insdie switch case');
            print('token must be removed');
            await CachingServices.clearAllCachedData();
            await FileSystemServices.deleteUserData();
            return Success200();
          }

        default:
          return NewBugException(message: 'unhandled statusCode ${response.statusCode}');
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      return NewBugException(message: err.toString());
    }
  }

  static Future<ContractResponse> signIn({@required String email, @required String password}) async {
    bool isConnected = await NetWorkInfo.checkConnection();

    if (!isConnected) {
      return NoInternetConnection();
    }

    Response response;
    Map<String, String> _headers = {'content-type': 'application/json', 'Accept': 'application/json'};

    Map<String, String> _body = {'email': email, 'password': password};

    try {
      response = await post(Uri.encodeFull(Api.LOCALHOST_LOGIN_URL), headers: _headers, body: json.encode(_body)).timeout(References.timeout);

      switch (response.statusCode) {
        case 500:
          return InternalServerError();
          break;

        case 404:
          return InternalServerError(message: 'Incorrect email and /or password');
          break;

        case 400:
          Map responseBody = json.decode(response.body);
          if (responseBody.containsKey('validated')) {
            var userdata = responseBody['user'];
            await FileSystemServices.saveUserData(userdata);
            return NotValidated();
          } else if (responseBody.containsKey('incorrect')) {
            return InternalServerError(message: 'Incorrect email and /or password');
          } else {
            return InternalServerError(message: 'this user is already logged in!');
          }
          break;

        case 200:
          String token = json.decode(response.body)['token'];
          await CachingServices.saveStringField(key: 'token', value: 'bearer $token');
          await FileSystemServices.saveUserData(json.decode(response.body)['userdata']);
          return Success200();
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
}
