import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../api/contract_response.dart';
import '../../../api/routes.dart';
import '../../../references/references.dart';
import '../../local_database/access_objects/teacher_access_object.dart';
import '../../local_database/models/uploaded_pdf_and_video_model.dart';
import '../caching_services.dart';
import '../file_system_services.dart';
import '../network_info.dart';
import 'dialog_service.dart';
import 'service_locator.dart';

class DialogManagerUseCases {
  static Future<ContractResponse> updatePersonalInfo(
      Map<String, String> updates) async {
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    http.Response response;
    var data = await FileSystemServices.getUserData();
    String accountType = data['account_type'];
    String _url =
        Api.getSuitableUrl(accountType: accountType) + '/update-personal-info';
    Map<String, String> _headers = {
      'authorization': await CachingServices.getField(key: 'token'),
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    try {
      response = await http
          .post(Uri.encodeFull(_url),
              headers: _headers, body: json.encode(updates))
          .timeout(References.timeout);
      switch (response.statusCode) {
        case 500:
          return InternalServerError();
          break;

        case 403:
          await CachingServices.clearAllCachedData();
          await FileSystemServices.deleteUserData();
          return ForbiddenAccess(message: 'You are not authorized as user');
          break;

        case 200:
          var data = json.decode(response.body);
          await CachingServices.saveStringField(
              key: 'token', value: 'bearer ${data['token']}');
          await FileSystemServices.saveUserData(data['userData']);
          var dialogService = locator.get<DialogService>();
          dialogService.profilePageState
              .updateUserData(References.specifyAccountType(data['userData']));
          return Success200();
          break;

        default:
          return NewBugException(
              message: 'Unhandled statusCode ${response.statusCode}');
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      return NewBugException(message: err.toString());
    }
  }

// upload new lecture
  static Future<ContractResponse> uploadNewLecture(
      {@required Map<String, dynamic> lectureData}) async {
    print(lectureData);
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }
    DialogService serviceLocator = locator.get<DialogService>();

    //http.Response response;
    String _url = Api.getSuitableUrl(
            accountType: serviceLocator
                .profilePageState.userData.commonFields.account_type) +
        '/upload-new-lecture';
    http.MultipartRequest multipartRequest =
        new http.MultipartRequest('POST', Uri.parse(_url));
    List<String> mimeType =
        lookupMimeType(lectureData['src'].path, headerBytes: [0xFF, 0xD8])
            .split('/');
    multipartRequest.headers['authorization'] =
        await CachingServices.getField(key: 'token');
    multipartRequest.headers['Accept'] = 'application/json';
    multipartRequest.fields['title'] = lectureData['title'];
    multipartRequest.fields['suggested_file_name'] =
        DateTime.now().millisecond.toString() +
            (lectureData['src'] as File).path.length.toString() +
            (lectureData['src'] as File).path.split('.').last;
    multipartRequest.fields['description'] = lectureData['description'];
    multipartRequest.fields['stage'] =
        (6 - References.schoolStages.indexOf(lectureData['stage'])).toString();
    multipartRequest.fields['school_section'] = lectureData['school_section'];
    multipartRequest.files.add(await http.MultipartFile.fromPath(
        'thumbnail', lectureData['src'].path,
        contentType: MediaType(mimeType[0], mimeType[1])));

    http.StreamedResponse streamedResponse;

    try {
      print('just before firing the http request');
      print(multipartRequest.fields);
      print(multipartRequest.headers);
      streamedResponse =
          await multipartRequest.send().timeout(Duration(seconds: 40));
      switch (streamedResponse.statusCode) {
        case 201:
          var data = await streamedResponse.stream.bytesToString();
          print(json.decode(data)['lecture']);
          print(json.decode(data)['lecture']['_id']);
          await TeacherAccessObject()
              .insert(UploadedPDF.fromJSON(json.decode(data)['lecture']));
          return Success201(message: 'Your lecture uploaded successfully');
          break;

        case 500:
          return InternalServerError();
          break;

        case 403:
          await FileSystemServices.deleteUserData();
          await CachingServices.clearAllCachedData();
          return ForbiddenAccess(message: 'You are not an authorized user');
          break;

        default:
          return NewBugException(
              message: 'Unhandled statusCode ${streamedResponse.statusCode}');
          break;
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      print(err);
      return NewBugException(message: err.toString());
    }
  }

  static Future<ContractResponse> uploadNewVideo(
      Map<String, String> videoData) async {
    bool isConnceted = await NetWorkInfo.checkConnection();

    if (!isConnceted) {
      return NoInternetConnection();
    }
    DialogService serviceLocator = locator.get<DialogService>();
    http.Response response;
    String _url = Api.getSuitableUrl(
            accountType: serviceLocator
                .profilePageState.userData.commonFields.account_type) +
        '/upload-new-video';

    Map<String, String> _headers = {
      'authorization': await CachingServices.getField(key: 'token'),
      'content-type': 'application/json',
      'Accept': 'application/json'
    };
    Map<String,String> videoToUpload = videoData;
    videoToUpload['stage'] = (6 - References.schoolStages.indexOf(videoData['stage'])).toString();
    try{
      response = await http.post(Uri.encodeFull(_url),headers: _headers,body: json.encode(videoToUpload)).timeout(References.timeout);
       switch (response.statusCode) {
        case 201:
          var data = json.decode(response.body);
          print(data['video']);
          print(data['video']['_id']);
          await TeacherAccessObject()
              .insertVideo(UploadedVideo.fromJSON(data['video']));
          return Success201(message: 'Your video uploaded successfully');
          break;

        case 500:
          return InternalServerError();
          break;

        case 403:
          await FileSystemServices.deleteUserData();
          await CachingServices.clearAllCachedData();
          return ForbiddenAccess(message: 'You are not an authorized user');
          break;

        default:
          return NewBugException(
              message: 'Unhandled statusCode ${response.statusCode}');
          break;
      }
    }
    on TimeoutException{
      return ServerNotResponding();
    }
    catch(err){
      return new NewBugException(message: err.toString());
    }
  }
}
