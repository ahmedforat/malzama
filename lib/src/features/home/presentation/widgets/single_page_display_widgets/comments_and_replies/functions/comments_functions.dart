import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../../../../core/api/contract_response.dart';
import '../../../../../../../core/api/routes.dart';
import '../../../../../../../core/platform/local_database/models/base_model.dart';
import '../../../../../../../core/platform/services/caching_services.dart';
import '../../../../../../../core/platform/services/file_system_services.dart';
import '../../../../../../../core/platform/services/network_info.dart';

class CommentFunctions {
//  id: Schema.Types.ObjectId,
//  collection_name: requiredString,
//  one_signal_id: requiredString,
//  notifications_repo: String,
//  profile_pic_ref: String,
//  firstName: String,
//  lastName: String,
  static Future<ContractResponse> uploadNewComment({
    String content,
    BaseUploadingModel materialInfo,
  }) async {
    // fetch the user data from the filesystem
    var data = await FileSystemServices.getUserData();
    if (data == null || data == false) {
      return NewBugException(message: 'Something went wrong!');
    }

    // set the profile picture field
    String profilePicture;
    if (data['profile_pic_ref'] != null && data['prfile_pic_ref'].toString().isNotEmpty) {
      profilePicture = data['profile_pic_ref'].toString();
    }

    print(materialInfo.getCommentRelatedData());
    // set the http request body
    Map<String, dynamic> newComment = {
      'profile_pic_ref': profilePicture,
      'content': content,
    }..addAll(
        materialInfo.getCommentRelatedData()..remove('one_signal_id'),
      );

    print(newComment);

    return await executeHttpPostRequest(body: newComment, url: Api.UPLOAD_COMMENT);
  }

  // ========================================================================================
  // ========================================================================================

  static Future<ContractResponse> editComment({
    @required String commentContent,
    @required BaseUploadingModel materialInfo,
    @required String commentId,
  }) async {
    Map<String, String> body = {
      'comments_collection': materialInfo.comments_collection,
      'comment_content': commentContent,
      'comment_id': commentId
    };

    return await executeHttpPostRequest(body: body, url: Api.EDIT_COMMENT);
  }

  // ========================================================================================
  // ========================================================================================

  Future<ContractResponse> uploadNewReply() async {}

  // ========================================================================================
  // ========================================================================================

  static Future<ContractResponse> fetchCommentsFromApi(state, List<String> ids) async {
    Map<String, dynamic> body = {'ids': ids, 'collection': state.comments_collection};

    return await executeHttpPostRequest(body: body, url: Api.FETCH_COMMENTS_BY_IDS);
  }

  // ========================================================================================
  // ========================================================================================

  static Future<ContractResponse> deleteComment({BaseUploadingModel materialInfo, String comment_id}) async {
    Map<String, dynamic> body = {
      'comment_id': comment_id,
      'comments_collection': materialInfo.comments_collection,
      'material_id': materialInfo.material_id,
      'material_collection': materialInfo.material_collection
    };
    return await executeHttpPostRequest(body: body, url: Api.DELETE_COMMENT);
  }

// ========================================================================================
// ========================================================================================

}

Future<ContractResponse> executeHttpPostRequest({
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
        return InternalServerError();
    }
  } on TimeoutException {
    return ServerNotResponding();
  } catch (err) {
    print(err);
    return NewBugException(message: err.toString());
  }
}
