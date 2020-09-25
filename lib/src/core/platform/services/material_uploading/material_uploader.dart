import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../api/contract_response.dart';
import '../../../api/routes.dart';
import '../../local_database/access_objects/teacher_access_object.dart';
import '../../local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import '../../local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import '../../local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import '../../local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import '../caching_services.dart';
import '../dialog_services/dialog_service.dart';
import '../dialog_services/service_locator.dart';
import '../file_system_services.dart';
import '../network_info.dart';

class MaterialUploader {
  static Future<ContractResponse> uploadNewMaterial({@required Map<String, dynamic> materialData}) async {
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    String downloadUrl;

    // show progress indicator of uploading
    locator<DialogService>().showDialogOfUploading();

    if (materialData['upload_type'] == 'lectures') {
      // here we are uploading a new lecture

      // upload the file to the cloud
      downloadUrl = await _uploadPDFToCloud(materialData['src']);

      if (downloadUrl == null) {
        // close the progress indicator of uploading
        locator<DialogService>().completeAndCloseDialog(null);

        // return internal server error
        return InternalServerError(message: 'an error occured while uploading, try again');
      }
    }

    // if the material is a lecture file
    if (downloadUrl != null) {
      materialData['size'] = (materialData['src'] as File).lengthSync();
      materialData['src'] = downloadUrl;
    }

    ContractResponse response = await _uploadNewMaterial(materialData);
    locator<DialogService>().completeAndCloseDialog(null);
    return response;
  }

  static Future<ContractResponse> _uploadNewMaterial(Map<String, dynamic> materialData) async {
    // make sure the device is connected online
    print(materialData);
    bool isConnected = await NetWorkInfo.checkConnection();
    if (!isConnected) {
      return NoInternetConnection();
    }

    Map<String, String> _headers = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'authorization': await CachingServices.getField(key: 'token'),
    };

    http.Response response;

    try {
      response = await http.post(Uri.encodeFull(Api.UPLOAD_NEW_MATERIAL), headers: _headers, body: json.encode(materialData)).timeout(Duration(seconds: 20));
      var serviceLocator = locator.get<DialogService>();

      switch (response.statusCode) {
        case 201:
          var data = json.decode(response.body);
          // saved the uploaded pdf to the local storage
          print(data['data']);
          await _handleSavingToLocalDB(data['data'], materialData['upload_type']);
          return Success201(message: 'Lecture Uploaded Successfully');
          break;

        case 500:
          return InternalServerError();

        case 403:
        case 401:
          await CachingServices.clearAllCachedData();
          await FileSystemServices.deleteUserData();
          return ForbiddenAccess(message: 'You are not authorized to access here');
          break;

        default:
          return NewBugException(message: 'Unhandled status Code ${response.statusCode}', statusCode: response.statusCode);
      }
    } on TimeoutException {
      return ServerNotResponding();
    } catch (err) {
      print(err);
      return NewBugException(message: err.toString());
    }
  }

  static Future<void> _handleSavingToLocalDB(Map<String, dynamic> data, String upload_type) async {
    String account_type = locator.get<DialogService>().profilePageState.userData.commonFields.account_type;
    var userdata = await FileSystemServices.getUserData();
    data['author'] = {
      'firstName':userdata['firstName'],
      'lastName':userdata['lastName'],
      '_id':userdata['_id'],
      'one_signal_id':userdata['one_signal_id'],
      'account_type':userdata['account_type'],
      'notifications_repo':userdata['notifications_repo'],
    };
    if (upload_type == 'lectures') {
      var uploadedLecture = account_type == 'schteachers' ? new SchoolUploadedPDF.fromJSON(data) : new CollegeUploadedPDF.fromJSON(data);
      await TeacherAccessObject().insert(uploadedLecture);
    } else if (upload_type == 'videos') {
      var uploadedVideo = account_type == 'schteachers' ? new SchoolUploadedVideo.fromJSON(data) : new CollegeUploadedVideo.fromJSON(data);
      await TeacherAccessObject().insertVideo(uploadedVideo);
    } else {
      // implement quiz insertion
    }
  }

  // upload pdf at first to the cloud ie Firabase for testing and digitalOcean for production
  static Future<String> _uploadPDFToCloud(File pdf) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String pdfName = 'pdf_' + DateTime.now().millisecondsSinceEpoch.toString();
    StorageTaskSnapshot snapshot = await storage.ref().child('school_pdfs/$pdfName.pdf').putFile(pdf).onComplete.catchError((err){
      print(err);
    });
    print(snapshot.ref.getDownloadURL());
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl == null || downloadUrl.isEmpty ? null : downloadUrl;
  }
}
