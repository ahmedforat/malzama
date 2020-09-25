import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:malzama/quiz_app/demo.values.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../core/api/contract_response.dart';
import '../../../core/api/routes.dart';
import '../../../core/platform/services/network_info.dart';
import '../../../core/references/references.dart';






class SignUpNewUser {
  Map<String, dynamic> user;
  Map<String, String> _header = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  http.Response response;
  var recievedData;

  SignUpNewUser({@required this.user});

  Future<ContractResponse> execute() async {


    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      // check whether the device is connected to internet
      return NoInternetConnection();
    }

    String oneSignalID = await CachingServices.getField(key: 'one_signal_id');
    if(oneSignalID == null || oneSignalID.isEmpty){
      oneSignalID = null;

      while(oneSignalID == null){
        var subscriptionState = await OneSignal.shared.getPermissionSubscriptionState();
        oneSignalID = subscriptionState.subscriptionStatus.userId;
      }
    }
    user['one_signal_id'] = oneSignalID;
    try {
      // initiate http request , Method = POST
      response = await http
          .post(Uri.encodeFull(Api.SIGNUP_URL),
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
          var newUser;
          try{
            print('****************************************************************');
            print('userData sent by the server: ${json.decode(response.body)}');
            print('****************************************************************');

          newUser = References.specifyAccountType(json.decode(response.body)['userData'] as Map<String,dynamic>);
          print('***************************************************');
          print(newUser.runtimeType.toString());
          print('***************************************************');
         }catch(err){
           print(err);
         }
        if(newUser == null){
          print('we are here');
          print(newUser);
          return InternalServerError();
        }
          var data = json.decode(response.body);
          await FileSystemServices.saveUserData(data['userData']);
          await CachingServices.saveStringField(
              key: 'initial-page', value: '/validate-account-page');
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
    } catch ( err) {
      print(err.toString());
      print(err.stackTrace);
      return NewBugException(message: err.toString()); // bug!
    }
  }
}
