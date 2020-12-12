import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/api_client/repositories/registration_repo.dart';
import 'package:malzama/src/core/api/api_routes/registration_routes.dart';

import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';

import 'package:malzama/src/core/platform/local_database/local_caches/cached_user_info.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class RegistrationClient implements RegistrationRepository {
  @override
  Future<ContractResponse> registerNewUser({@required Map<String, dynamic> user}) async {
    String oneSignalID = await CachingServices.getField(key: 'one_signal_id');
    if (oneSignalID == null || oneSignalID.isEmpty) {
      oneSignalID = null;

      while (oneSignalID == null) {
        var subscriptionState = await OneSignal.shared.getPermissionSubscriptionState();
        oneSignalID = subscriptionState.subscriptionStatus.userId;
      }
    }
    Map<String, String> payload = {};
    user['one_signal_id'] = oneSignalID;
    user.forEach((key, value) {
      payload[key] = value.toString();
    });
    ContractResponse response = await HttpMethods.post(body: payload, url: RegistrationRoutes.SIGNUP_URL);
    if (response is Success) {
      var data = json.decode(response.message);
      if (data == null) {
        return InternalServerError();
      }
      User newUser = References.specifyAccountType(data['userData'] as Map<String, dynamic>);
      FileSystemServices.saveUserData(newUser.toJSON());
      await CachingServices.saveStringField(key: 'initial-page', value: '/validate-account-page');
      await UserCachedInfo().saveStringKey('account_type', newUser.accountType);
      return Success201(message: 'your account created successfully');
    }
    return response;
  }

  @override
  Future<ContractResponse> sendMeAuthCodeAgain({String id, String accounType}) async {
    final String query = '?id=$id&accountType=$accounType';
    return await HttpMethods.get(url: RegistrationRoutes.SEND_ANOTHER_AUTH_CODE_URL, queryString: query);
  }

  @override
  Future<ContractResponse> signIn({String username, String password, String accountType}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<ContractResponse> verifyAccount({int authCode, Map<String, String> verificationData}) async {
    Map<String, dynamic> body = {
      'authCode': authCode,
    }
      ..addAll(verificationData);

    Map<String, String> payload = {};
    body.forEach((key, value) {
      payload[key] = value.toString();
    });

    ContractResponse response = await HttpMethods.post(body: payload, url: RegistrationRoutes.VERIFY_EMAIL_URL);

    if (response is Success) {
      var data = json.decode(response.message);
      await CachingServices.saveStringField(key: 'token', value: 'bearer ${data['token']}');
    }
    if (response is NotFound) {
      await FileSystemServices.deleteUserData();
      await CachingServices.clearAllCachedData();
      await Future.delayed(Duration(seconds: 2));
    }

    return response;
  }
}
