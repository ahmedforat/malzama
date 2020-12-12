import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/api_routes/video_and_pdf_routes.dart';

import '../../contract_response.dart';
import '../../http_methods.dart';
import '../repositories/video_and_pdf_repository.dart';

class VideosAndPDFClient implements VideoAndPDFRepository {
  @override
  Future<ContractResponse> fetch({@required String idFactor, @required String collectionName}) async {
    print('Fetching ......');
    String queryString = '?collectionName=$collectionName';
    queryString += idFactor == null ? '' : '&idFactor=$idFactor';
    return await HttpMethods.get(url: VideoAndPDFRoutes.FETCH_VIDEOS_OR_PDFS, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchByID({@required String id, @required String collectionName}) async {
    final String queryString = '?id=$id&collectionName=$collectionName';
    return await HttpMethods.get(url: VideoAndPDFRoutes.FETCH_VIDEO_OR_PDF_BY_ID, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchSavedMaterials({@required String collection, @required List<String> ids}) async {
    final String idList = ids.join(',');
    final String query = '?collection=$collection&ids=$idList';
    return await HttpMethods.get(url: VideoAndPDFRoutes.FETCH_SAVED_VIDEOS_OR_PDFS, queryString: query);
  }

  @override
  Future<ContractResponse> fetchOnRefresh({@required String collection, @required String idFactor}) async {
    final String query = '?collection=$collection&idFactor=$idFactor';
    return await HttpMethods.get(url: VideoAndPDFRoutes.FETCH_MATERIALS_ON_REFRESH, queryString: query);
  }
}
