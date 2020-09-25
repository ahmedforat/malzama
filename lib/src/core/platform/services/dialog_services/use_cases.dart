import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:mime/mime.dart';

import '../../../api/contract_response.dart';
import '../../../api/routes.dart';
import '../../../references/references.dart';
import '../../local_database/access_objects/teacher_access_object.dart';
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

  // for universities

//  final Map<String, dynamic> lectureData = {
//    'title': title,
//    'description': description,
//    'stage': collegeUploadingState.stage,
//    'section': dialogService.profilePageState.userData.section,
//    'topic':collegeUploadingState.topic,
//    'src': collegeUploadingState.lectureToUpload
//  };

  // for schools

//  final Map<String, dynamic> lectureData = {
//    'title': title,
//    'description': description,
//    'stage': lectureState.targetStage,
//    'school_section': lectureState.targetSchoolSection,
//    'src': lectureState.lectureToUpload
//  };

  // **********************************************************************************************************

  // videos

  // for universities
//  Map<String, String> videoData = {
//    'title': title,
//    'description': description,
//    'videoId': videoId,
//    'stage': videoState.stage.toString(),
//    'topic': videoState.topic,
//  };

  // for schools
//  Map<String, String> videoData = {
//    'title': title,
//    'description': description,
//    'videoId': videoId,
//    'stage': videoState.targetStage,
//    'school_section': videoState.targetSchoolSection,
//  };

// upload new lecture (for both universities and schools)
  // static Future<ContractResponse> uploadNewLecture({@required Map<String, dynamic> lectureData}) async {
  //   print(lectureData);
  //   bool isConnected = await NetWorkInfo.checkConnection();
  //   if (!isConnected) {
  //     return NoInternetConnection();
  //   }
  //   DialogService serviceLocator = locator.get<DialogService>();
  //   String account_type = serviceLocator.profilePageState.userData.commonFields..account_type;

  //   //http.Response response;

  //   // setting the suitable url
  //   String _url = Api.getSuitableUrl(accountType: account_type) + '/upload-new-lecture';

  //   // instantiation of the http multipart request
  //   http.MultipartRequest multipartRequest = new http.MultipartRequest('POST', Uri.parse(_url));
  //   List<String> mimeType = lookupMimeType(lectureData['src'].path, headerBytes: [0xFF, 0xD8]).split('/');

  //   // setting headers
  //   multipartRequest.headers['authorization'] = await CachingServices.getField(key: 'token');
  //   multipartRequest.headers['Accept'] = 'application/json';

  //   // setting common request body fields
  //   multipartRequest.fields['title'] = lectureData['title'];
  //   multipartRequest.fields['description'] = lectureData['description'];
  //   multipartRequest.files.add(await http.MultipartFile.fromPath('thumbnail', lectureData['src'].path, contentType: MediaType(mimeType[0], mimeType[1])));

  //   // setting the field per account type
  //   if (account_type != 'schteachers') {
  //     multipartRequest.fields['university'] = serviceLocator.profilePageState.userData.university;
  //     multipartRequest.fields['college'] = serviceLocator.profilePageState.userData.college;
  //     multipartRequest.fields['section'] = lectureData['section'];
  //     multipartRequest.fields['topic'] = lectureData['topic'];
  //     multipartRequest.fields['stage'] = lectureData['stage'];
  //     multipartRequest.fields['stage'] = lectureData['stage'];
  //   } else {
  //     multipartRequest.fields['stage'] = (6 - References.schoolStages.indexOf(lectureData['stage'])).toString();
  //     multipartRequest.fields['school_section'] = lectureData['school_section'];
  //     multipartRequest.fields['topic'] = serviceLocator.profilePageState.userData.speciality;
  //   }

  //   http.StreamedResponse streamedResponse;

  //   try {
  //     print('just before firing the http request');
  //     print(multipartRequest.fields);
  //     print(multipartRequest.headers);
  //     streamedResponse = await multipartRequest.send().timeout(Duration(seconds: 40));
  //     switch (streamedResponse.statusCode) {
  //       case 201:
  //         var data = await streamedResponse.stream.bytesToString();
  //         print(json.decode(data)['lecture']);
  //         print(json.decode(data)['lecture']['_id']);

  //         BaseUploadingModel uploadingModel;

  //         if (account_type == 'schteachers') {
  //           uploadingModel = SchoolUploadedPDF.fromJSON(json.decode(data)['lecture']);
  //           await TeacherAccessObject().insert<SchoolUploadedPDF>(uploadingModel);
  //         } else {
  //           uploadingModel = CollegeUploadedPDF.fromJSON(json.decode(data)['lecture']);
  //           await TeacherAccessObject().insert<CollegeUploadedPDF>(uploadingModel);
  //         }

  //         return Success201(message: 'Your lecture uploaded successfully');
  //         break;

  //       case 500:
  //         return InternalServerError();
  //         break;

  //       case 403:
  //         await FileSystemServices.deleteUserData();
  //         await CachingServices.clearAllCachedData();
  //         return ForbiddenAccess(message: 'You are not an authorized user');
  //         break;

  //       default:
  //         return NewBugException(message: 'Unhandled statusCode ${streamedResponse.statusCode}');
  //         break;
  //     }
  //   } on TimeoutException {
  //     return ServerNotResponding();
  //   } catch (err) {
  //     print(err);
  //     return NewBugException(message: err.toString());
  //   }
  // }

  
}
