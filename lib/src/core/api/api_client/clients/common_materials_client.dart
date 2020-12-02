import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:malzama/src/core/api/api_client/repositories/common_materials_repository.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';

class CommonMaterialClient implements CommonMaterialsRepository {
  @override
  Future<ContractResponse> deleteMaterial({String materialId, String collectionName}) async {
    final String queryString = '?id=$materialId&collectionName=$collectionName';
    return await HttpMethods.get(url: Api.DELETE_MATERIAL, queryString: queryString);
  }

  @override
  Future<ContractResponse> editMaterial({Map<String, dynamic> payload, String id, String collectionName}) async {
    Map<String, dynamic> body = {
      'id': id,
      'collectionName': collectionName,
    }..addAll(payload);
    return await HttpMethods.post(body: body, url: Api.EDIT_MATERIAL);
  }

  @override
  Future<ContractResponse> saveMaterial({String id, String fieldName,String indicator}) async {
    final String queryString = '?id=$id&fieldName=$fieldName&indicator=$indicator';
    return await HttpMethods.get(url: Api.MARK_MATERIAL_AS_SAVED, queryString: queryString);
  }

  @override
  Future<ContractResponse> uploadNewMaterial({String uploadType, Map<String, dynamic> payload}) async {
    String downloadUrl;
    if(uploadType == 'lectures'){
      downloadUrl = await _uploadPDFToCloud(payload['src']);
      if(downloadUrl == null){
        return InternalServerError(message: 'an error occured while uploading, try again');
      }else{
        payload['size'] = (payload['src'] as File).lengthSync().toString();
        payload['src'] = downloadUrl;
      }
    }




    payload['upload_type'] = uploadType;
    Map<String,String> body = {};
    payload.entries.toList().forEach((element) {
      body[element.key] = element.value.toString();
    });
    return await HttpMethods.post(body: body, url: Api.UPLOAD_NEW_MATERIAL,timeoutInSeconds: 20);
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
