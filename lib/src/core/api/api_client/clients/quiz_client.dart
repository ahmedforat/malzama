import 'package:malzama/src/core/api/api_client/repositories/quiz_repository.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_entity.dart';

class QuizClient implements QuizRepository {
  @override
  Future<ContractResponse> deleteQuizItem({String quizItemId, String quizCollectionId, int questionsCount}) async {
    final String queryString = '?quizItemID=$quizItemId&quizCollectionID=$quizCollectionId&questionsCount=$questionsCount';
    return await HttpMethods.get(url: Api.DELETE_QUIZ_ITEM, queryString: queryString);
  }

  @override
  Future<ContractResponse> editQuizItem({String quizItemID, String quizCollectionID, QuizEntity quizItem}) async {
    Map<String, dynamic> body = {'quizItemID': quizItemID, 'quizCollectionID': quizCollectionID, 'quizItem': quizItem.toJSON()};
    return await HttpMethods.post(body: body, url: Api.EDIT_QUIZ_ITEM);
  }

  @override
  Future<ContractResponse> fetchQuizByID({String id}) async {
    final String queryString = '?id=$id';
    return await HttpMethods.get(url: Api.FETCH_QUIZ_BY_ID, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchQuizHeaders({String idFactor}) async {
    final String queryString = '?idFactor=$idFactor';
    return await HttpMethods.get(url: Api.FETCH_QUIZES_HEADERS, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchQuizQuestions({quizID, int skipCount}) async {
    final String queryString = '?quizID=$quizID&skipCount=$skipCount';
    return await HttpMethods.get(url: Api.FETCH_QUIZES_QUESTIONS, queryString: queryString);
  }

  @override
  Future<ContractResponse> fetchQuizesCount() async => await HttpMethods.get(url: Api.FETCH_QUIZES_COUNT);
}
