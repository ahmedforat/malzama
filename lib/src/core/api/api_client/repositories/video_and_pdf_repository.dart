

import 'package:flutter/cupertino.dart';

import '../../contract_response.dart';
abstract class VideoAndPDFRepository {

  /// Fetch Videos or PDFs in pagination style 10 by 10
  /// => [require] ( idFactor,collectionName ) [ as query string ]
  ///  .............. [ GET req ]
  Future<ContractResponse> fetch({
    @required String idFactor,
    @required String collectionName,
});

  /// fetch single video or pdf by id  .......... [GET req]
  /// require ( id , collectionName ) [ as query string ]
  Future<ContractResponse> fetchByID({
    @required String id,
    @required String collectionName,
  });


}
