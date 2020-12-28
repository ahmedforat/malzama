import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/api_routes/profile_routes.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';

class ProfileClient {
  Future<ContractResponse> editBio({@required String update}) async {
    final String query = '?update=$update';
    return await HttpMethods.get(url: ProfileRoutes.EDIT_BIO, queryString: query);
  }

  Future<ContractResponse> deleteBio() async {
    return await HttpMethods.get(url: ProfileRoutes.DELETE_BIO);
  }

  Future<ContractResponse> editOrDeleteProfilePicture(bool edit, String url, String fieldName) async {
    final String query = '?edit=$edit&picUrl=$url&fieldName=$fieldName';
    return await HttpMethods.get(url: ProfileRoutes.EDIT_OR_DELETE_PROFILE_PICTURES, queryString: query);
  }

  Future<ContractResponse> updatePersonalInfo({@required bool isEmailModified, @required Map<String, dynamic> info}) async {
    Map<String, dynamic> body = {
      'isEmailModified': isEmailModified,
      ...info,
    };
    return await HttpMethods.post(body: body, url: ProfileRoutes.UPDATE_PERSONAL_INFO);
  }

  Future<ContractResponse> verifyAndUpdateInfo({@required String authCode, @required Map<String, dynamic> info}) async {
    Map<String, dynamic> body = {
      'authCode': authCode,
      ...info,
    };
    return await HttpMethods.post(body: body, url: ProfileRoutes.VERIFY_AND_UPDATE_INFO);
  }
}
