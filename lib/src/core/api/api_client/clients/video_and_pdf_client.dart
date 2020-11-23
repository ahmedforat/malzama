

import 'package:flutter/foundation.dart';

import '../../contract_response.dart';
import '../../http_methods.dart';
import '../../routes.dart';
import '../repositories/video_and_pdf_repository.dart';

class VideosAndPDFClient implements VideoAndPDFRepository {
  @override
  Future<ContractResponse> fetch({@required String idFactor, @required String collectionName}) async {
    print('Fetching ......');
    String queryString = '?collectionName=$collectionName';
    queryString += idFactor == null ? '' : '&$idFactor';
    return await HttpMethods.get(url: Api.FETCH_VIDEOS_OR_PDFS, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchByID({@required String id, @required String collectionName}) async {
    final String queryString = '?id=$id&collectionName=$collectionName';
    return await HttpMethods.get(url: Api.FETCH_VIDEO_OR_PDF_BY_ID, queryString: queryString);
  }
}
