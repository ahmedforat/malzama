import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';



class MaterialTypes{
  static const String VIDEOS = 'videos';
  static const String QUIZES = 'quizes';
  static const String LECTURES = 'lectures';
}

class MaterialFunctions {
  /// delete material pdf or video or quiz
  static Future<ContractResponse> deleteMaterial({
    @required String id,
    @required String collectionName,
    @required String materialType,
  }) async {
    final Map<String, String> body = {
      '_id': id,
      'collection_name': collectionName,
      'material_type': materialType,
    };
    return await HttpMethods.post(body: body, url: Api.DELETE_MATERIAL);
  }

  /// edit material pdf ,video or quiz
  static Future<ContractResponse> editMaterial({
    @required String id,
    @required String collectionName,
    @required Map<String, dynamic> payload,
  }) async {
    final Map<String, dynamic> body = {'_id': id, 'collection_name': collectionName}..addAll(payload);
    return await HttpMethods.post(body: body, url: Api.EDIT_MATERIAL);
  }






}
