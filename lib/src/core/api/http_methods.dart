import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../platform/services/caching_services.dart';
import '../platform/services/network_info.dart';
import 'contract_response.dart';

class HttpMethods {
  static Future<ContractResponse> get({
    @required String url,
    Map<String, String> headers,
    int timeout,
    String queryString,
  }) async {
    print('Getting $url');
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    Map<String, String> _headers = headers ??
        {
          'accept': 'application/json',
        };
    _headers['authorization'] = await CachingServices.getField(key: 'token');

    print(_headers['authorization']);
    http.Response response;
    url += queryString ?? '';

    print('before firing req $url');
    try {
      response = await http.get(Uri.encodeFull(url.trim()), headers: _headers).timeout(Duration(milliseconds: timeout ?? 18000));
      print(response.body);
      switch (response.statusCode) {
        case 200:
          return Success200(message: response.body);
          break;

        case 201:
          return Success201(message: response.body);
          break;

        case 500:
          return InternalServerError();

        case 404:
          return NotFound();

        default:
          return NewBugException(statusCode: response.statusCode, message: 'unHandled status code');
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      print('error inside executing get request');
      print(err);
      throw err;
      return NewBugException(message: err.toString());
    }
  }

  static Future<ContractResponse> post({
    Map<String, String> headers,
    @required Map<String, String> body,
    @required String url,
    int timeoutInSeconds,
  }) async {
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    Map<String, String> _headers = headers ??
        {
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

        case 208: // already reported  208
          return AlreadyReported(message: 'Email you entered is already in use!');
          break;

        case 422:
          return InvalidData();

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
