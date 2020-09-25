import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:malzama/src/core/api/contract_response.dart';
import 'dart:async';

import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';

typedef Future<Success> OnSuccess(http.Response response);

class CustomHttpRequest {
  String url;
  Map<String, dynamic> headers;
  Map<String, dynamic> body;
  String method;
  final int successStatusCode, timeout;
  OnSuccess onSuccess;

  // Constructor
  CustomHttpRequest(this.onSuccess,
      {Map<String, dynamic> headers,
      Map<String, dynamic> body,
      String method = 'GET',
      this.timeout,
      @required this.successStatusCode,
      @required this.url}) {
    assert((method == 'POST' && body != null) || method == 'GET');

    this.headers = headers ??
        {
          'accept': 'application/json',
          'content-type': 'application/json',
        };

    if (method == 'Get') {
      this.body = body;
    }
    this.method = method;
  }

  http.Response response;

  Future<ContractResponse> execute() async {
    try {
      if (method == 'GET') {
        response = await http
            .get(Uri.encodeFull(this.url), headers: this.headers)
            .timeout(Duration(seconds: timeout ?? 20));
      } else {
        response = await http
            .post(Uri.encodeFull(this.url),
                headers: this.headers, body: json.encode(this.body))
            .timeout(Duration(seconds: timeout ?? 20));
      }

      if (response.statusCode == successStatusCode) {
        await onSuccess(response);
      } else {
        switch (response.statusCode) {
          case 500:
            return InternalServerError();
            break;
          case 403:
          case 401:
            await CachingServices.clearAllCachedData();
            await FileSystemServices.deleteUserData();
            return ForbiddenAccess(
                message: 'You are not authorized to access here');
            break;

          default:
            return NewBugException(
                message: 'Unhandled status code ${response.statusCode}',
                statusCode: response.statusCode);
        }
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      print(err);
      return NewBugException(
          message: err.toString(), statusCode: response.statusCode);
    }
  }
}
