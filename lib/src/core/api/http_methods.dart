import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/network_info.dart';

class HttpMethods {
  static Future<ContractResponse> get({@required String url,Map<String,dynamic> headers ,int timeout}) async {
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    Map<String,String> _headers  = headers ??  {
      'accept':'application/json'
    };
    _headers['authorization'] = await CachingServices.getField(key: 'token');


    http.Response response;
    try {
      response = await http.get(Uri.encodeFull(url),headers: _headers).timeout(Duration(milliseconds: timeout ?? 18000));
      print(response.body);
      switch (response.statusCode) {
        case 200:
        case 201:
          return response.statusCode == 200
              ? Success200(
                  message: response.body,
                )
              : Success201(
                  message: response.body,
                );
          break;

        case 500:
          return InternalServerError();

        default:
          return NewBugException(statusCode: response.statusCode, message: 'unHandled status code');
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      print('error inside executing get request');
      print(err.toString());
      return NewBugException(message: err.toString());
    }
  }


 static Future<ContractResponse> post({
    Map<String, String> headers,
    @required Map<String, dynamic> body,
    @required String url,
    int timeoutInSeconds,
  }) async {
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    Map<String, String> _headers = headers ?? {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    _headers['authorization'] = await CachingServices.getField(key: 'token');


    http.Response response;

    try {
      response = await http
          .post(
        Uri.encodeFull(url),
        headers: _headers,
        body: json.encode(body),
      )
          .timeout(Duration(seconds: timeoutInSeconds ?? 20));

      switch (response.statusCode) {
        case 200:
          return Success200(message: response.body);
          break;

        case 201:
          return Success201(message: response.body);
          break;

        default:
          return InternalServerError(message: response.body);
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      print(err);
      return NewBugException(message: err.toString());
    }
  }

}
