import 'package:malzama/src/core/api/contract_response.dart';
import 'package:flutter/foundation.dart';

abstract class RegistrationRepository {
  Future<ContractResponse> registerNewUser({
    @required Map<String, dynamic> user,
  });

  Future<ContractResponse> signIn({
    @required String username,
    @required String password,
    @required String accountType,
  });

  Future<ContractResponse> verifyAccount({
    @required int authCode,
    @required Map<String,String>verificationData
  });

  Future<ContractResponse> sendMeAuthCodeAgain({
    @required String id,
    @required String accounType,
  });
}
