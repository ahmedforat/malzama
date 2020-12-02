import 'package:flutter/foundation.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_entity.dart';

import '../../contract_response.dart';

// uuid consist of institution code + stage number aaa1
abstract class QuizRepository {
  /// [delete single quiz question] <br>
  /// [require] (quizItemID , quizCollectionID,questionsCount) [as query string]<br>
  /// ................ [GET req ]
  Future<ContractResponse> deleteQuizItem({
    @required String quizItemId,
    @required String quizCollectionId,
    @required int questionsCount,
  });

  /// Edit Quiz item ...... [POST req ]
  Future<ContractResponse> editQuizItem({
    @required String quizItemID,
    @required String quizCollectionID,
    @required QuizEntity quizItem,
  });

  /// [require] id [as query string]
  Future<ContractResponse> fetchQuizByID({
    @required String id,
  });

  /// Fetch quiz collections without their questions (just headers)
  ///  in pagination style  10 by 10<br>
  ///  [require] idFactor [as query string] <br>
  ///   ............... [Get req]
  Future<ContractResponse> fetchQuizHeaders({
    String idFactor,
  });

  /// [Fetch questions of single quiz in pagination style 8 by 8]
  ///  [require] ( quizId,skipCount ) [as query string]
  ///  ................. [GET req ]
  Future<ContractResponse> fetchQuizQuestions({
    @required quizID,
    @required int skipCount,
  });

  /// [Fetch questions of single quiz in pagination style 8 by 8]
  Future<ContractResponse> fetchQuizesCount();

  /// [fetch saved quizes headers] <br>
  ///  [require] collection in addition list of ids as query string <br>
  ///  GET Request
  Future<ContractResponse> fetchSavedQuizesHeaders({@required String collection, @required List<String> ids});
}
