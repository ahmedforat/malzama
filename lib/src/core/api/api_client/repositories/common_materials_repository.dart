import '../../contract_response.dart';
import 'package:flutter/foundation.dart';

abstract class CommonMaterialsRepository {
  /// upload new material ............. [POST req]
  Future<ContractResponse> uploadNewMaterial({
    @required String uploadType,
    @required Map<String, dynamic> payload,
  });

  /// [delete entire Material] require (id , collectionName) [as query string]
  ///  ................ [GET req]
  Future<ContractResponse> deleteMaterial({
    @required String materialId,
    @required String collectionName,
  });

  /// Edit material (include entire quiz)       .............. [POST req]
  Future<ContractResponse> editMaterial({
    @required Map<String, dynamic> payload,
    @required String id,
    @required String collectionName,
  });

  /// add a material to user saved material
  /// => require (id , fieldName) [as query string]
  /// .......... [GET req]
  Future<ContractResponse> saveMaterial({
    @required String id,
    @required String fieldName,
    @required String indicator,
  });
}
