import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:malzama/src/core/api/api_client/repositories/common_materials_repository.dart';
import 'package:malzama/src/core/api/api_routes/common_routes.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';

class CommonMaterialClient implements CommonMaterialsRepository {
  @override
  Future<ContractResponse> deleteMaterial({String materialId, String collectionName}) async {
    final String queryString = '?id=$materialId&collectionName=$collectionName';
    return await HttpMethods.get(url: CommonRoutes.DELETE_MATERIAL, queryString: queryString);
  }

  @override
  Future<ContractResponse> editMaterial({Map<String, dynamic> payload, String id, String collectionName}) async {
    Map<String, dynamic> body = {
      'id': id,
      'collectionName': collectionName,
    }..addAll(payload);
    return await HttpMethods.post(body: body, url: CommonRoutes.EDIT_MATERIAL);
  }

  @override
  Future<ContractResponse> saveMaterial({String id, String fieldName, String indicator}) async {
    final String queryString = '?id=$id&fieldName=$fieldName&indicator=$indicator';
    return await HttpMethods.get(url: CommonRoutes.MARK_MATERIAL_AS_SAVED, queryString: queryString);
  }

  @override
  Future<ContractResponse> uploadNewMaterial({String uploadType, Map<String, dynamic> payload}) async {
    String downloadUrl;
    if (uploadType == 'lectures') {
      downloadUrl = await HelperFucntions.uploadPDFToCloud(payload['src']);
      if (downloadUrl == null) {
        return InternalServerError(message: 'an error occured while uploading, try again');
      } else {
        payload['size'] = (payload['src'] as File).lengthSync().toString();
        payload['src'] = downloadUrl;
      }
    }

    payload['upload_type'] = uploadType;

    return await HttpMethods.post(body: payload, url: CommonRoutes.UPLOAD_NEW_MATERIAL, timeoutInSeconds: 20);
  }

  // upload pdf at first to the cloud ie Firabase for testing and digitalOcean for production
}
